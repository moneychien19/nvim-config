# Neovim 設定

一套精簡、模組化的個人 Neovim 設定，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理外掛。
本文件的目的是讓這套設定能在**任何全新環境**下重現並成功套用。

## 功能總覽

| 類別 | 外掛 | 說明 |
| --- | --- | --- |
| 外掛管理 | [lazy.nvim](https://github.com/folke/lazy.nvim) | 外掛安裝與版本鎖定 |
| 主題 | [onedark.nvim](https://github.com/navarasu/onedark.nvim) | OneDark（`light` 風格） |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | 語言伺服器（預設啟用 `clangd`） |
| 自動補全 | [blink.cmp](https://github.com/saghen/blink.cmp) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 補全與 snippet |
| 模糊搜尋 | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | 檔案 / 內容 / 符號搜尋 |
| 語法高亮 | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 語法解析與高亮（`main` 分支） |
| Git | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | 在左側標記欄顯示 Git 增/改/刪狀態 |
| 格式化 | [conform.nvim](https://github.com/stevearc/conform.nvim) | 程式碼格式化（C/C++ 使用 `clang-format`） |
| 終端機 | 內建 | 可切換的底部浮動終端機（`<C-/>`） |
| 按鍵提示 | [which-key.nvim](https://github.com/folke/which-key.nvim) | 按下 leader 等前綴鍵時彈出可用按鍵提示 |

外掛版本皆由 `lazy-lock.json` 鎖定，確保跨環境安裝到相同的 commit。

## 系統需求

| 需求 | 用途 | 備註 |
| --- | --- | --- |
| **Neovim ≥ 0.11**（建議 0.12+） | 設定使用 `vim.lsp.enable()` 與 treesitter `main` 分支等新 API | 舊版無法運作 |
| **git** | 下載外掛 | 必要 |
| **C 編譯器**（gcc / clang） | 編譯 treesitter parser | 必要 |
| **tree-sitter CLI**（`tree-sitter`） | nvim-treesitter `main` 分支用它建置 parser | **必要**（否則 parser 無法安裝） |
| **ripgrep**（`rg`） | Telescope `live_grep` 內容搜尋 | 建議安裝 |
| **fd**（`fd` / `fdfind`） | Telescope `find_files` 加速 | 選用 |
| **clangd** | 預設的 C/C++ 語言伺服器 | 需要 LSP 才需安裝 |
| **clang-format** | conform.nvim 格式化 C/C++ 用 | 需要格式化才需安裝（通常隨 llvm / clang 提供） |
| **Nerd Font** | 補全選單圖示（`nerd_font_variant = "mono"`） | 建議，需在終端機設定字型 |

### 依平台安裝需求（範例）

**macOS（Homebrew）**
```sh
brew install neovim git tree-sitter ripgrep fd llvm
# clangd 隨 llvm 一起提供；C 編譯器可用系統內建 clang
```

**Ubuntu / Debian**
```sh
sudo apt install neovim git ripgrep fd-find build-essential clangd
# tree-sitter CLI 通常不在套件庫，改用下方任一方式安裝
# 注意：Debian/Ubuntu 套件庫的 neovim 可能過舊，建議改用官方 AppImage 或 PPA 取得 0.11+
```

**Arch Linux**
```sh
sudo pacman -S neovim git tree-sitter-cli ripgrep fd base-devel clang
```

**tree-sitter CLI（若套件庫沒有）**
```sh
# 方式一：cargo
cargo install tree-sitter-cli
# 方式二：npm
npm install -g tree-sitter-cli
# 方式三：直接下載對應版本的預編譯 binary（見下方「受限環境」）
```

> Nerd Font 請至 [nerdfonts.com](https://www.nerdfonts.com/) 下載並在你的終端機設定為顯示字型。

### 受限環境安裝（無 sudo / 共用主機，例如學校 server）

在沒有 root 權限、無法用套件管理器的機器上，把所有工具裝到家目錄的 `~/.local/bin`（確認它在 `PATH` 中），
下載官方預編譯 binary 即可。要點：

- **Neovim 要下載「完整」release**（含 `share/nvim/runtime`），不能只複製執行檔，否則會出現
  `module 'vim.uri' not found` / 找不到 `syntax.vim` 而無法啟動。建議解壓整包後把 `bin/nvim` 連結進 `~/.local/bin`：
  ```sh
  curl -fsSL -o /tmp/nvim.tar.gz \
    https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
  tar -C ~/.local -xzf /tmp/nvim.tar.gz && mv ~/.local/nvim-linux-x86_64 ~/.local/nvim
  ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
  ```
- **glibc 相容性**：舊系統（如 Ubuntu 22.04 = glibc 2.35）跑不動用新 glibc 編譯的最新 binary
  （會出現 `GLIBC_2.39 not found`）。此時挑**較舊的版本**，或選 **musl 靜態版**（ripgrep 有提供）。
  實測可用組合：`tree-sitter 0.25.8`、`ripgrep 14.1.1`（musl）、`clangd 18.1.3`。
- tree-sitter / ripgrep / clangd 皆可從各自的 GitHub Releases 下載單一 binary，`chmod +x` 後放進 `~/.local/bin`。

## 安裝步驟

### 1. 備份既有設定（若有）

```sh
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
# 一併清除舊的外掛與快取，避免衝突
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null || true
mv ~/.cache/nvim       ~/.cache/nvim.bak       2>/dev/null || true
```

### 2. 取得這份設定

```sh
git clone https://github.com/moneychien19/nvim-config.git ~/.config/nvim
```

### 3. 手動安裝 lazy.nvim（重要）

本設定的 `lua/config/lazy.lua` **不會自動下載** lazy.nvim，若找不到會直接報錯。
請先手動 clone 到 Neovim 的 data 目錄：

```sh
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
  --branch=stable "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim"
```

### 4. 啟動 Neovim

```sh
nvim
```

首次啟動時 lazy.nvim 會依 `lazy-lock.json` 自動安裝所有外掛，treesitter 也會編譯所需的 parser。
安裝完成後可執行下列指令確認狀態：

```
:Lazy         " 檢視外掛安裝狀態
:checkhealth  " 檢查環境相依（編譯器、rg、字型等）
```

## 目錄結構

```
~/.config/nvim
├── init.lua                 # 進入點，依序載入 config 與 keymaps
├── lazy-lock.json           # 外掛版本鎖定檔（跨環境重現的關鍵）
├── lua
│   ├── config
│   │   ├── options.lua       # 編輯器基本選項（行號、縮排、剪貼簿、leader…）
│   │   └── lazy.lua          # lazy.nvim 載入與外掛設定入口
│   ├── keymaps
│   │   ├── general.lua       # 一般按鍵（存檔、離開）
│   │   ├── lsp.lua           # LSP 相關按鍵
│   │   ├── telescope.lua     # Telescope 搜尋按鍵
│   │   ├── format.lua        # 格式化按鍵（conform.nvim）
│   │   └── terminal.lua      # 終端機切換按鍵與邏輯
│   └── plugins               # 每個外掛一個檔案，lazy.nvim 自動載入整個資料夾
│       ├── colorscheme.lua
│       ├── completion.lua
│       ├── conform.lua
│       ├── git.lua
│       ├── lsp.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       └── which-key.lua
```

## 主要設定

Leader 鍵為 **空白鍵（Space）**。按鍵不在此逐一列出——本設定已安裝 [which-key.nvim](https://github.com/folke/which-key.nvim)，按下 leader（或其他前綴鍵）稍作停頓即會彈出所有可用按鍵與功能。實際的按鍵定義請見 `lua/keymaps/`。

### 編輯器選項（`lua/config/options.lua`）
- 顯示絕對與相對行號
- 縮排：4 空格、使用空白取代 tab、smartindent
- 搜尋：`ignorecase` + `smartcase`
- 啟用滑鼠、`termguicolors`
- 系統剪貼簿整合（`clipboard = unnamedplus`）

### Git 標記（`lua/plugins/gitsigns` → `lua/plugins/git.lua`）
在 git 專案內編輯檔案時，左側標記欄會即時顯示每一行的 Git 狀態（使用預設設定）：

| 符號 | 意義 |
| --- | --- |
| `│` | 新增 / 修改的行 |
| `_` `‾` | 刪除的行 |
| `~` | 修改後又刪除 |
| `┆` | 未追蹤的檔案 |

> 需系統已安裝 `git`（已列於系統需求），且檔案位於 git 儲存庫內才會顯示。

### 格式化（`lua/plugins/conform.lua` + `lua/keymaps/format.lua`）
使用 [conform.nvim](https://github.com/stevearc/conform.nvim) 做程式碼格式化，目前設定 C/C++ 使用 `clang-format`。
按 `<leader>f` 會非同步格式化目前檔案；若該檔案類型沒有設定對應的 formatter，會退回使用 LSP 格式化（`lsp_format = "fallback"`）。

> 需系統已安裝 `clang-format`（已列於系統需求）。要新增其他語言，於 `formatters_by_ft` 加入對應的 formatter 即可。

### 終端機切換（`lua/keymaps/terminal.lua`）
按 `<C-/>` 可在編輯畫面底部開關一個高度 15 的終端機視窗（一般模式與終端機模式皆可觸發）：

- 第一次開啟會在底部 `botright 15split` 建立終端機並自動進入插入模式。
- 再按一次即關閉終端機視窗，但保留該 terminal buffer。
- 之後再開啟時會重用同一個 terminal buffer，維持先前的工作階段。

### 按鍵提示（`lua/plugins/which-key.lua`）
使用 [which-key.nvim](https://github.com/folke/which-key.nvim)，按下前綴鍵（如 leader 空白鍵）後短暫停頓，會彈出視窗列出接下來可用的按鍵與功能，不必特意記憶。目前使用 `modern` preset，延遲 `200` 毫秒（`delay = 200`）。

## 自訂與擴充

### 新增語言的 LSP
編輯 `lua/plugins/lsp.lua`，在 `config` 中加入更多 `vim.lsp.enable("<server>")`，
並確保該語言伺服器已安裝於系統 PATH。例如加入 Lua 與 Python：

```lua
config = function()
    vim.lsp.enable("clangd")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("pyright")
end,
```

> 需在系統另外安裝對應的 LSP（如 `lua-language-server`、`pyright`）。
> 可用外掛設定名稱請參考 [nvim-lspconfig 的 server 清單](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)。

### 新增 Treesitter parser
編輯 `lua/plugins/treesitter.lua` 頂端的 `parsers` 清單即可，目前包含：
`c`、`lua`、`python`、`markdown`、`markdown_inline`、`yaml`、`json`。
存檔後重開 Neovim，或執行 `:TSUpdate`。

### 新增外掛
在 `lua/plugins/` 底下新增一個回傳 lazy 規格表的 `.lua` 檔即可，lazy.nvim 會自動載入整個資料夾。

## 更新與維護

```
:Lazy sync     " 依 lazy-lock.json 安裝/更新外掛
:Lazy update   " 更新外掛並寫入新的 lazy-lock.json
:TSUpdate      " 更新 treesitter parser
```

更新後記得將變動的 `lazy-lock.json` 一併 commit，才能在其他環境重現相同版本。

## 疑難排解

- **啟動時出現 `lazy.nvim not found`**：尚未完成上面「步驟 3」手動安裝 lazy.nvim。
- **Neovim 版本過舊 / 出現 API 錯誤**：本設定需 Neovim 0.11 以上，請升級。
- **啟動出現 `module 'vim.uri' not found` / 找不到 `syntax.vim`**：Neovim 執行檔缺 runtime，請安裝「完整」release（見「受限環境安裝」）。
- **Treesitter 編譯失敗**：確認已安裝 C 編譯器（gcc 或 clang）。
- **Treesitter 出現 `no such file or directory (cmd): 'tree-sitter'`**：未安裝 tree-sitter CLI（`main` 分支必需），見上方安裝說明。
- **binary 出現 `GLIBC_2.xx not found`**：系統 glibc 太舊，改裝較舊版本或 musl 靜態版的該工具。
- **`<leader>fg` 沒有結果**：確認已安裝 `ripgrep`（`rg`）。
- **補全選單圖示為方框/亂碼**：終端機未使用 Nerd Font。
- **LSP 沒有作用**：確認對應的語言伺服器（如 `clangd`）已安裝並在 PATH 中，可用 `:checkhealth lsp` 檢查。
