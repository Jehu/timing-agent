---
name: timing-track
description: Track substantive agent work in Timing. Use inside any Git repository; resolve the Timing project from a declaration or from the repository name.
---

# Timing tracking

Use the installed `ta` command to track substantive work in Timing.

## Project resolution

1. A `timing-project: <Timing project name>` line in `.timing-project` or `AGENTS.md` at the Git repository root wins.
2. Otherwise `ta` uses the Git repository directory name. If that Timing project does not exist, `ta start` creates it; this requires Timing Connect.
3. Outside a Git repository, only an explicit project declaration enables tracking.

## Required workflow

- On the first actionable step, run `ta start "<short task description>"`.
- Immediately before the final response for that work block, run `ta stop`.
- Do not track pure questions or reading-only requests.
- If starting fails, report the failure once in the final response and continue normally.

## Commands

- `ta start [title]`
- `ta stop`
- `ta status`
- `ta project`
