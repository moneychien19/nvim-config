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

外掛版本皆由 `lazy-lock.json` 鎖定，確保跨環境安裝到相同的 commit。

## 系統需求

| 需求 | 用途 | 備註 |
| --- | --- | --- |
| **Neovim ≥ 0.11**（建議 0.12+） | 設定使用 `vim.lsp.enable()` 與 treesitter `main` 分支等新 API | 舊版無法運作 |
| **git** | 下載外掛 | 必要 |
| **C 編譯器**（gcc / clang） | 編譯 treesitter parser | 必要 |
| **ripgrep**（`rg`） | Telescope `live_grep` 內容搜尋 | 建議安裝 |
| **fd**（`fd` / `fdfind`） | Telescope `find_files` 加速 | 選用 |
| **clangd** | 預設的 C/C++ 語言伺服器 | 需要 LSP 才需安裝 |
| **Nerd Font** | 補全選單圖示（`nerd_font_variant = "mono"`） | 建議，需在終端機設定字型 |

### 依平台安裝需求（範例）

**macOS（Homebrew）**
```sh
brew install neovim git ripgrep fd llvm
# clangd 隨 llvm 一起提供；C 編譯器可用系統內建 clang
```

**Ubuntu / Debian**
```sh
sudo apt install neovim git ripgrep fd-find build-essential clangd
# 注意：Debian/Ubuntu 套件庫的 neovim 可能過舊，建議改用官方 AppImage 或 PPA 取得 0.11+
```

**Arch Linux**
```sh
sudo pacman -S neovim git ripgrep fd base-devel clang
```

> Nerd Font 請至 [nerdfonts.com](https://www.nerdfonts.com/) 下載並在你的終端機設定為顯示字型。

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
git clone <this-repo-url> ~/.config/nvim
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
│   │   └── telescope.lua     # Telescope 搜尋按鍵
│   └── plugins               # 每個外掛一個檔案，lazy.nvim 自動載入整個資料夾
│       ├── colorscheme.lua
│       ├── completion.lua
│       ├── lsp.lua
│       ├── telescope.lua
│       └── treesitter.lua
```

## 主要設定

Leader 鍵為 **空白鍵（Space）**。以下為預設按鍵：

### 一般
| 按鍵 | 功能 |
| --- | --- |
| `<leader>w` | 儲存檔案 |
| `<leader>q` | 關閉視窗 |

### Telescope 搜尋
| 按鍵 | 功能 |
| --- | --- |
| `<leader>ff` | 搜尋檔案 |
| `<leader>fg` | 內容搜尋（live grep，需 ripgrep） |
| `<leader>fb` | 搜尋 buffer |
| `<leader>fh` | 搜尋說明文件 |

### LSP
| 按鍵 | 功能 |
| --- | --- |
| `gd` | 跳到定義 |
| `gr` | 尋找參照 |
| `gi` | 跳到實作 |
| `K` | 顯示懸浮說明 |
| `<leader>rn` | 重新命名符號 |
| `<leader>ca` | Code action |
| `<leader>d` | 顯示該行診斷 |
| `<leader>ds` | 文件內符號 |
| `<leader>ws` | 工作區符號 |

### 編輯器選項（`lua/config/options.lua`）
- 顯示絕對與相對行號
- 縮排：4 空格、使用空白取代 tab、smartindent
- 搜尋：`ignorecase` + `smartcase`
- 啟用滑鼠、`termguicolors`
- 系統剪貼簿整合（`clipboard = unnamedplus`）

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
- **Treesitter 編譯失敗**：確認已安裝 C 編譯器（gcc 或 clang）。
- **`<leader>fg` 沒有結果**：確認已安裝 `ripgrep`（`rg`）。
- **補全選單圖示為方框/亂碼**：終端機未使用 Nerd Font。
- **LSP 沒有作用**：確認對應的語言伺服器（如 `clangd`）已安裝並在 PATH 中，可用 `:checkhealth lsp` 檢查。
