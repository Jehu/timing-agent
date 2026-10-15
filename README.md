# timing-agent

Portable macOS installer for tracking coding-agent work in [Timing](https://timingapp.com).

`ta` starts and stops Timing timers through the local `TimingHelper` AppleScript interface. The included `timing-track` agent skill tells compatible coding agents to call it around substantive work.

## Requirements

- macOS and Timing installed
- Timing **Expert** for timer automation
- Timing **Connect** only if `ta` must create a missing project automatically

## Install

### Directly from GitHub

```bash
curl -fsSL https://raw.githubusercontent.com/Jehu/timing-agent/main/install.sh | bash
```

`curl | bash` executes code received from GitHub. Pin `main` to a commit SHA
in the URL if you need a reproducible installation.

### From a local copy

Clone or download the repository, then run:

```bash
./install.sh
```

The installer writes:

- `~/.local/bin/ta`
- `~/.agents/skills/timing-track/SKILL.md`

If `~/.local/bin` is absent from `PATH`, it prints the exact export to add to
the shell profile. Restart the agent after installation so it discovers the
skill.

## Project selection

`ta` resolves a project in this order:

1. `timing-project: Project Name` in `<repo>/.timing-project`
2. The same declaration in `<repo>/AGENTS.md`
3. Git repository directory name

Example `.timing-project`:

```text
timing-project: aesthetic & soul
```

The explicit declaration is useful when the repository name is not the Timing
project name. Commit it when this mapping is shared by the team; put
`.timing-project` in `.gitignore` when it is a personal mapping.

When only the Git name is available and no matching Timing project exists,
`ta start` creates it. Set `TA_DEFAULT_PARENT` to group created projects:

```bash
export TA_DEFAULT_PARENT='Clients'
```

## Commands

```bash
ta project
ta start 'Implement checkout validation'
ta status
ta stop
```

Only one Timing timer can be active at a time. Do not run `ta start`
concurrently from multiple agent threads.
