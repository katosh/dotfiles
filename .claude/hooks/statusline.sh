#!/bin/bash
# Claude Code status line — high-res Unicode bar + token counts + cost + lines changed
# + cache hit ratio + live API traffic indicator + Anthropic API status
# Input: JSON from stdin with model, context_window, cost fields

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
session_id=$(echo "$input" | jq -r '.session_id // "default"')

# Fallback: no context data yet
if [ -z "$used_pct" ]; then
    echo "$model"
    exit 0
fi

# Token count from current usage (what's actually in the context window now)
cur_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cur_output=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
cur_cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cur_cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
used_tokens=$((cur_input + cur_cache_create + cur_cache_read))

# Cache hit ratio
cache_total=$((cur_cache_create + cur_cache_read + cur_input))
if [ "$cache_total" -gt 0 ]; then
    cache_pct=$(awk "BEGIN { printf \"%.0f\", $cur_cache_read / $cache_total * 100 }")
    cache_str="⚡${cache_pct}%"
else
    cache_str="⚡--"
fi

# Live API traffic indicator — compare total_api_duration_ms to detect active requests
api_dur=$(echo "$input" | jq -r '.cost.total_api_duration_ms // 0')
state_file="/tmp/statusline-state-${session_id}"

traffic=""
if [ -f "$state_file" ]; then
    prev_api_dur=$(cat "$state_file" 2>/dev/null)
    if [ "$api_dur" != "$prev_api_dur" ]; then
        traffic="◉"  # API active — filled circle
    else
        traffic="○"  # Idle — empty circle
    fi
else
    traffic="◉"  # First call, assume active
fi
echo "$api_dur" > "$state_file"

# Anthropic API status — cached with 60s TTL to avoid hammering the endpoint
status_cache="/tmp/statusline-apistatus"
status_str=""
now=$(date +%s)
cache_age=999
if [ -f "$status_cache" ]; then
    cache_mtime=$(stat -c %Y "$status_cache" 2>/dev/null || stat -f %m "$status_cache" 2>/dev/null || echo 0)
    cache_age=$((now - cache_mtime))
fi

if [ "$cache_age" -gt 60 ]; then
    # Fetch in background to avoid blocking; use cached value this tick
    (
        result=$(curl -s --connect-timeout 2 --max-time 3 \
            'https://tymt9n04zgry.statuspage.io/api/v2/components.json' 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            # Check Claude API + Claude Code components
            api_status=$(echo "$result" | jq -r '.components[] | select(.name | test("Claude API|Claude Code")) | .status' 2>/dev/null)
            worst="operational"
            for s in $api_status; do
                case "$s" in
                    major_outage)       worst="major_outage"; break ;;
                    partial_outage)     [ "$worst" != "major_outage" ] && worst="partial_outage" ;;
                    degraded_performance) [ "$worst" = "operational" ] && worst="degraded_performance" ;;
                esac
            done
            echo "$worst" > "$status_cache"
        fi
    ) &
fi

if [ -f "$status_cache" ]; then
    cached_status=$(cat "$status_cache" 2>/dev/null)
    case "$cached_status" in
        operational)            status_str="" ;;  # no indicator when healthy
        degraded_performance)   status_str=" ⚠ degraded" ;;
        partial_outage)         status_str=" 🟡 partial outage" ;;
        major_outage)           status_str=" 🔴 outage" ;;
        *)                      status_str="" ;;
    esac
fi

# Format token counts as K or M
fmt_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ]; then
        awk "BEGIN { printf \"%.1fM\", $n/1000000 }"
    elif [ "$n" -ge 1000 ]; then
        awk "BEGIN { printf \"%.0fK\", $n/1000 }"
    else
        echo "$n"
    fi
}

used_str=$(fmt_tokens "$used_tokens")
total_str=$(fmt_tokens "$ctx_size")

# High-res Unicode bar: 10 chars wide, 8 sub-levels per char = 80 levels
# Block elements: ▏▎▍▌▋▊▉█ (U+258F..U+2588) + ░ for empty, ▓ for compaction zone
blocks=("" "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█")
bar_width=10
compact_pct=95  # auto-compaction threshold
filled_units=$(awk "BEGIN { printf \"%.0f\", $used_pct / 100 * $bar_width * 8 }")
compact_char_idx=$(awk "BEGIN { printf \"%d\", int($compact_pct / 100 * $bar_width) }")

bar=""
i=0
while [ $i -lt $bar_width ]; do
    cell_units=$((filled_units - i * 8))
    if [ $cell_units -ge 8 ]; then
        bar="${bar}█"
    elif [ $cell_units -gt 0 ]; then
        bar="${bar}${blocks[$cell_units]}"
    elif [ $i -ge $compact_char_idx ]; then
        bar="${bar}▓"
    else
        bar="${bar}░"
    fi
    i=$((i + 1))
done

# Format cost
cost_str=$(awk "BEGIN { printf \"$%.2f\", $cost }")

# Lines changed
lines=""
if [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
    lines=" +${added}/-${removed}"
fi

echo "${traffic} $model │ ${bar} ${used_str}/${total_str} │ ${cache_str} │ ${cost_str}${lines}${status_str}"
