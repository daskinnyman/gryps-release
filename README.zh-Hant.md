# Gryps

[English](README.md) · **繁體中文**

Gryps 讓 coding agent 做 QA 工程師每天的工作。它包含一組用純 Markdown 寫的
QA 技能，加上一個小的 `gryps` CLI。你已經在用的 agent（Claude Code、Codex、
Cursor 或其他）照著技能做，只透過 `gryps drive web|api|mobile` 操作受測系統。
Gryps 記錄每個檢查，並寫出報告。

這個儲存庫放 Gryps 的公開安裝檔：curl 安裝腳本、Homebrew formula 和發布的
安裝包。原始碼儲存庫是私有的。

## 安裝

需要 Node.js 20.19 以上或 22.12 以上。

curl：

```sh
curl -fsSL https://raw.githubusercontent.com/daskinnyman/gryps-release/main/install.sh | bash
```

它把 `gryps` 裝到 `~/.local/bin`，並下載 Gryps 要操作的 Chromium。
設定 `GRYPS_VERSION=0.1.0` 可以指定版本。

Homebrew：

```sh
brew tap daskinnyman/gryps https://github.com/daskinnyman/gryps-release
brew trust --formula daskinnyman/gryps/gryps
brew install gryps
```

然後執行 `brew` 印出的那行 `playwright install chromium`。

## 使用

```sh
gryps skills                      # 列出內建技能
gryps run --skill smoke --target https://staging.example.com \
  --agent "claude -p --allowedTools=Bash"
```

每次執行都會在 `reports/` 下寫出 Markdown 和 HTML 報告。
`gryps --help` 列出全部指令和參數。

## 更新

curl：再執行一次安裝腳本。Homebrew：`brew upgrade gryps`。
