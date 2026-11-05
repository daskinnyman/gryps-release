# Gryps

**English** · [繁體中文](README.zh-Hant.md)

Gryps gives a coding agent the daily work of a QA engineer. It is a set of
QA skills in plain Markdown and a small `gryps` CLI. The agent you already use
(Claude Code, Codex, Cursor or another) follows a skill and operates the
system under test only through `gryps drive web|api|mobile`. Gryps records
every check and writes the report.

This repository holds Gryps's public install artifacts: the curl installer,
the Homebrew formula and the release tarballs. The source repository is
private.

## Install

Needs Node.js 20.19+ or 22.12+.

curl:

```sh
curl -fsSL https://raw.githubusercontent.com/daskinnyman/gryps-release/main/install.sh | bash
```

It installs `gryps` into `~/.local/bin` and downloads the Chromium that Gryps
drives. Set `GRYPS_VERSION=0.1.0` to pick a release.

Homebrew:

```sh
brew tap daskinnyman/gryps https://github.com/daskinnyman/gryps-release
brew trust --formula daskinnyman/gryps/gryps
brew install gryps
```

Then run the `playwright install chromium` line that `brew` prints.

## Use

```sh
gryps skills                      # list the bundled skills
gryps run --skill smoke --target https://staging.example.com \
  --agent "claude -p --allowedTools=Bash"
```

Each run writes a Markdown and an HTML report under `reports/`.
`gryps --help` lists every command and flag.

## Update

curl: run the installer again. Homebrew: `brew upgrade gryps`.
