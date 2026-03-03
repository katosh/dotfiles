#!/bin/bash
# Claude Code status line — high-res Unicode bar + token counts + cost + lines changed
# Input: JSON from stdin with model, context_window, cost fields

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Fallback: no context data yet
if [ -z "$used_pct" ]; then
    echo "$model"
    exit 0
fi

# Token count from current usage (what's actually in the context window now)
cur_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cur_cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cur_cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
used_tokens=$((cur_input + cur_cache_create + cur_cache_read))

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
# Block elements: ▏▎▍▌▋▊▉█ (U+258F..U+2588) + ░ for empty
blocks=("" "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█")
bar_width=10
filled_units=$(awk "BEGIN { printf \"%.0f\", $used_pct / 100 * $bar_width * 8 }")

bar=""
i=0
while [ $i -lt $bar_width ]; do
    cell_units=$((filled_units - i * 8))
    if [ $cell_units -ge 8 ]; then
        bar="${bar}█"
    elif [ $cell_units -gt 0 ]; then
        bar="${bar}${blocks[$cell_units]}"
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

echo "$model │ ${bar} ${used_str}/${total_str} │ ${cost_str}${lines}"
