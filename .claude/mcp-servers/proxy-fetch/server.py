#!/usr/bin/env python3
"""MCP server that fetches web content through a SOCKS proxy."""

import os
import sys
import json
import re
from urllib.parse import urlparse

# Use macOS native certificate store (fixes SSL verification with uv-managed Python).
import truststore
truststore.inject_into_ssl()

import httpx
from mcp.server.fastmcp import FastMCP

PROXY_URL = os.environ.get("SOCKS_PROXY", "socks5://localhost:1080")
TIMEOUT = int(os.environ.get("FETCH_TIMEOUT", "30"))
MAX_CONTENT_LENGTH = int(os.environ.get("MAX_CONTENT_LENGTH", "500000"))

mcp = FastMCP("proxy-fetch")


def html_to_text(html: str) -> str:
    """Basic HTML to readable text conversion."""
    import re
    # Remove script and style blocks
    text = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'<style[^>]*>.*?</style>', '', text, flags=re.DOTALL | re.IGNORECASE)
    # Convert common elements
    text = re.sub(r'<br\s*/?\s*>', '\n', text, flags=re.IGNORECASE)
    text = re.sub(r'</?p[^>]*>', '\n\n', text, flags=re.IGNORECASE)
    text = re.sub(r'<h[1-6][^>]*>(.*?)</h[1-6]>', r'\n\n## \1\n\n', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'<li[^>]*>(.*?)</li>', r'\n- \1', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'<a[^>]+href="([^"]*)"[^>]*>(.*?)</a>', r'[\2](\1)', text, flags=re.DOTALL | re.IGNORECASE)
    # Strip remaining tags
    text = re.sub(r'<[^>]+>', '', text)
    # Decode entities
    text = text.replace('&amp;', '&').replace('&lt;', '<').replace('&gt;', '>')
    text = text.replace('&quot;', '"').replace('&#39;', "'").replace('&nbsp;', ' ')
    # Collapse whitespace
    text = re.sub(r'\n{3,}', '\n\n', text)
    text = re.sub(r' {2,}', ' ', text)
    return text.strip()


@mcp.tool()
def fetch(url: str, raw: bool = False) -> str:
    """Fetch a web page through the SOCKS proxy.

    Args:
        url: The URL to fetch.
        raw: If true, return raw HTML instead of converted text.
    """
    parsed = urlparse(url)
    if not parsed.scheme:
        url = "https://" + url

    try:
        with httpx.Client(proxy=PROXY_URL, timeout=TIMEOUT, follow_redirects=True) as client:
            resp = client.get(url, headers={
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            })

        content_type = resp.headers.get("content-type", "")
        status = resp.status_code

        if status >= 400:
            return f"HTTP {status}: {resp.reason_phrase}\n\nURL: {url}"

        body = resp.text[:MAX_CONTENT_LENGTH]

        if raw or "text/plain" in content_type:
            return f"HTTP {status} | {content_type}\n\n{body}"

        if "html" in content_type:
            text = html_to_text(body)
            return f"HTTP {status} | {content_type}\n\n{text}"

        if "json" in content_type:
            try:
                formatted = json.dumps(json.loads(body), indent=2)
                return f"HTTP {status} | {content_type}\n\n{formatted}"
            except json.JSONDecodeError:
                return f"HTTP {status} | {content_type}\n\n{body}"

        if "pdf" in content_type:
            return f"HTTP {status} | {content_type}\n\n[PDF content - {len(resp.content)} bytes. Save to disk to read.]"

        return f"HTTP {status} | {content_type}\n\n{body}"

    except httpx.ProxyError as e:
        return f"Proxy error (is your SSH tunnel running on {PROXY_URL}?): {e}"
    except httpx.ConnectError as e:
        return f"Connection error: {e}"
    except httpx.TimeoutException:
        return f"Timeout after {TIMEOUT}s fetching {url}"
    except Exception as e:
        return f"Error: {type(e).__name__}: {e}"


@mcp.tool()
def fetch_pdf(url: str, save_path: str = "/tmp/fetched.pdf") -> str:
    """Download a PDF through the SOCKS proxy and save it locally.

    Args:
        url: The URL of the PDF to download.
        save_path: Where to save the PDF (default: /tmp/fetched.pdf).
    """
    parsed = urlparse(url)
    if not parsed.scheme:
        url = "https://" + url

    try:
        with httpx.Client(proxy=PROXY_URL, timeout=60, follow_redirects=True) as client:
            resp = client.get(url, headers={
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
                "Accept": "application/pdf,*/*",
            })

        if resp.status_code >= 400:
            return f"HTTP {resp.status_code}: {resp.reason_phrase}"

        with open(save_path, "wb") as f:
            f.write(resp.content)

        return f"Saved {len(resp.content)} bytes to {save_path}"

    except httpx.ProxyError as e:
        return f"Proxy error (is your SSH tunnel running on {PROXY_URL}?): {e}"
    except Exception as e:
        return f"Error: {type(e).__name__}: {e}"


@mcp.tool()
def check_proxy() -> str:
    """Check if the SOCKS proxy is reachable and working."""
    try:
        with httpx.Client(proxy=PROXY_URL, timeout=10) as client:
            resp = client.get("https://httpbin.org/ip")
            data = resp.json()
            return f"Proxy OK. External IP: {data.get('origin', 'unknown')}\nProxy: {PROXY_URL}"
    except httpx.ProxyError as e:
        return f"Proxy UNREACHABLE at {PROXY_URL}: {e}\nIs your SSH tunnel running?"
    except Exception as e:
        return f"Error: {type(e).__name__}: {e}"


if __name__ == "__main__":
    mcp.run(transport="stdio")
