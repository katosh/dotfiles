# Agent Preferences

When spawning agents for tasks, prefer **Agent Teams** (TeamCreate + Agent with team_name) over plain subagents for any non-trivial work. This gives each agent its own interactive terminal pane in tmux.

Use Agent Teams when:
- The task involves multiple steps (research + implementation, parallel work)
- The agent will run bash commands, edit files, or do anything beyond simple search
- Multiple agents could work in parallel
- The work would benefit from being visible and interactable

Keep plain subagents (Agent tool without team_name) only for:
- Quick single-file lookups or searches
- Simple questions that need a fast answer
- Tasks that complete in a few seconds
