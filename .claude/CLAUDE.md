# Agent Preferences

When spawning agents for tasks, prefer **Agent Teams** (TeamCreate + Agent with team_name) over plain subagents for any non-trivial work. This gives each agent its own interactive terminal pane in cmux.

Use Agent Teams when:
- The task involves multiple steps (research + implementation, parallel work)
- The agent will run bash commands, edit files, or do anything beyond simple search
- Multiple agents could work in parallel
- The work would benefit from being visible and interactable

Keep plain subagents (Agent tool without team_name) only for:
- Quick single-file lookups or searches
- Simple questions that need a fast answer
- Tasks that complete in a few seconds

# Web Fetching

An MCP server called `proxy-fetch` is available. It routes requests through a SOCKS proxy to bypass paywalls and geo-restrictions.

- When WebFetch fails (403, paywall, geo-restricted), retry using the `proxy-fetch` MCP tool `fetch` instead.
- For paywalled or geo-restricted content, use `proxy-fetch` `fetch` directly.
- To download PDFs through the proxy, use the `fetch_pdf` tool.
- Use `check_proxy` to verify the SSH tunnel is running if proxy requests fail.
- The proxy requires an active SSH tunnel (DynamicForward on localhost:1080). If proxy errors occur, tell the user to check their SSH connection.

## Proxy fetch in subagents / teammates

MCP tools are NOT available in agent mode (Claude Code limitation). Subagents and teammates must use the CLI wrapper instead:

```bash
# Fetch URL (HTML → text):
~/.claude/bin/proxy-fetch https://example.com

# Fetch raw HTML:
~/.claude/bin/proxy-fetch --raw https://example.com

# Download PDF:
~/.claude/bin/proxy-fetch --pdf https://example.com/paper.pdf /tmp/paper.pdf

# Check proxy:
~/.claude/bin/proxy-fetch --check
```

When spawning agents that need web fetching, include this in their prompt:
> Use `Bash(~/.claude/bin/proxy-fetch <url>)` to fetch web pages through the SOCKS proxy. MCP tools are not available to you.
