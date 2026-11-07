# 🛠️ Dotfiles (Neovim & WezTerm)

Kişisel **Neovim** ve **WezTerm** geliştirme ortamı konfigürasyonları. Neovim tarafı Windows üzerinde kullanılıp test ediliyor.

---

## ⚡ Özellikler

- **Paket Yöneticisi:** Neovim 0.12'nin yerleşik `vim.pack`'i. Eklentiler `lua/plugins.lua`'da tanımlı, sürümler `nvim-pack-lock.json`'da sabit.
- **Otomatik Tamamlama:** [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (LSP, imza yardımı, buffer, path, cmdline, calc, vsnip kaynakları)
- **LSP:** Native `vim.lsp.config` / `vim.lsp.enable` + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Lua (`lua_ls`), TypeScript/JavaScript (`ts_ls`), C# ([roslyn.nvim](https://github.com/seblyng/roslyn.nvim)). İlerleme bildirimi için [fidget.nvim](https://github.com/j-hui/fidget.nvim).
- **Sözdizimi Vurgulama:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch): `c_sharp`, `css`, `html`, `javascript`, `typescript`, `tsx`
- **Bulanık Arama:** [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + `live-grep-args`, `file-browser`, `ui-select`
- **Git:** [vim-fugitive](https://github.com/tpope/vim-fugitive), [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim), [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- **Arayüz:** [sonokai](https://github.com/sainnhe/sonokai) tema, [nvim-hardline](https://github.com/ojroques/nvim-hardline) durum çubuğu, [which-key.nvim](https://github.com/folke/which-key.nvim), [mini.icons](https://github.com/nvim-mini/mini.icons), [mini.cursorword](https://github.com/nvim-mini/mini.cursorword)
- **C# Test Çalıştırıcı:** `:RunXUnitClass`, açık dosyadaki xUnit test sınıfını `dotnet test --filter` ile yeni bir sekmede çalıştırır.
- **Yapay Zeka (AI) Kopyalama:** `<leader>yl`, `<leader>yc`, `<leader>yf` ile AI sohbetlerine doğrudan dosya yolu, kod bloğu veya sınıf/fonksiyon adı aktarma.
- **Terminal:** [WezTerm](https://wezfurlong.org/wezterm/) (Acrylic / Blur, sekme isimlendirme, kısayol rehberi, Windows & macOS uyumlu).

---

## 🪟 Windows Kurulumu

### 1. Gereksinimleri Yükleyin

PowerShell ile:

```powershell
# Neovim 0.12+ (vim.pack için gerekli), arama araçları, treesitter derleyicisi
scoop install neovim git ripgrep fd gcc tree-sitter lua-language-server

# TypeScript/JavaScript ve HTML (Razor) dil sunucuları
npm install -g typescript-language-server typescript vscode-langservers-extracted

# C#: .NET SDK 10+ ve Roslyn dil sunucusu
dotnet tool install -g roslyn-language-server --prerelease

# İkonlar için Nerd Font (WezTerm kendi içinde Nerd Font sembolleri getirir, ayrıca gerekmez)
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
```

> **Not:** `tree-sitter` CLI'ını npm ile değil scoop ile kurun. Neovim (libuv) npm'in `.cmd` shim'lerini çalıştıramadığı için parser derlemesi `ENOENT` ile başarısız olur. Parser'lar `gcc` ile derlenir: `after/plugin/treesitter.lua` Windows'ta `CC=gcc` ayarlar (MSVC gerekmez).

### 2. Neovim Konfigürasyonunu Klonlayın

```powershell
git clone https://github.com/doguclks/dotfiles.git $env:LOCALAPPDATA\nvim
```

### 3. Başlatın

```powershell
nvim
```

> İlk açılışta `vim.pack` eklentileri `nvim-pack-lock.json`'daki sürümlerle kurmak için onay ister. Treesitter parser'ları arka planda derlenir. Kurulum bitince Neovim'i kapatıp tekrar açın ve `:checkhealth` ile kontrol edin.

**Güncelleme:** `:lua vim.pack.update()` (eklentiler), ardından `:TSUpdate` (parser'lar).

### 4. (İsteğe Bağlı) WezTerm Konfigürasyonunu Bağlayın

```powershell
Copy-Item "$env:LOCALAPPDATA\nvim\wezterm\wezterm.lua" "$HOME\.wezterm.lua"
```

---

## 🍎 macOS Kurulumu

> Neovim konfigürasyonu Windows üzerinde test ediliyor. macOS'ta aynı araçlar Homebrew ile kurulabilir.

```bash
xcode-select --install   # treesitter parser'larını derlemek için C derleyicisi
brew install neovim git ripgrep fd tree-sitter-cli lua-language-server
npm install -g typescript-language-server typescript vscode-langservers-extracted

# Mevcut konfigürasyon varsa yedekleyin, sonra klonlayın
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/doguclks/dotfiles.git ~/.config/nvim
```

### (İsteğe Bağlı) WezTerm Konfigürasyonunu Bağlayın

```bash
brew install --cask wezterm

# Çapraz platform otomatik algılamalı konfigürasyon:
cp ~/.config/nvim/wezterm/wezterm.lua ~/.wezterm.lua

# VEYA sadece macOS'a özel bağımsız konfigürasyon:
# cp ~/.config/nvim/wezterm/wezterm.mac.lua ~/.wezterm.lua
```

---

## ⌨️ Temel Kısayollar (Cheat Sheet)

Leader tuşu: **`Space` (Boşluk)**. `<leader>` ile başlayan tüm kısayollar which-key menüsünde de görünür.

### 📁 Dosya ve Arama (Telescope)
| Kısayol | Açıklama |
|---|---|
| `<leader>ff` | Dosya ara (visual modda: seçili metinle ara) |
| `<leader>fg` | Proje içinde metin ara, live grep args (visual modda: seçili metinle ara) |
| `<leader>fb` | Açık buffer'lar arasında ara |
| `<leader>fh` | Neovim yardım etiketleri |
| `<leader>fx` | Dosya gezgini (Telescope file browser) |
| `<leader>fs` | Git'te değişen dosyalar |
| `<leader>r`  | (Visual) Seçili metni dosya genelinde değiştir |

### 🧰 Genel
| Kısayol | Açıklama |
|---|---|
| `<leader>x`  | Netrw dosya gezgini (`:Ex`) |
| `<leader>hh` | Arama vurgusunu temizle (`:noh`) |
| `<leader>ed` | Dosyayı DOS satır sonlarıyla yeniden aç |
| `<leader>oc` | Neovim konfigürasyonunu yeni sekmede aç |

### 🌿 Git (Fugitive, Gitsigns & Diffview)
| Kısayol | Açıklama |
|---|---|
| `<leader>gs` | Git durum penceresi (Fugitive) |
| `<leader>gS` | Git durumu (Telescope) |
| `<leader>gb` | Git blame |
| `<leader>gp` / `<leader>gP` | Git push / pull |
| `]c` / `[c`  | Sonraki / önceki değişiklik (hunk) |
| `<leader>hi` | Değişikliği satır içinde önizle |
| `<leader>dv` / `<leader>dc` | Diffview aç / kapat |
| `<leader>dh` | Mevcut dosyanın geçmişi |
| `<leader>df` | Branch geçmişi |

### 🔍 LSP & Kod Gezinme
| Kısayol | Açıklama |
|---|---|
| `gd` / `gD` / `gi` | Tanıma / bildirime / implementasyona git |
| `K`  | Hover dokümantasyonu (Neovim varsayılanı) |
| `<C-k>` | İmza yardımı |
| `<leader>rn` | Yeniden adlandır (Rename) |
| `<leader>ca` | Kod eylemleri (Code Actions) |
| `<leader>p`  | Dosyayı formatla |
| `<leader>e`  | Hata/uyarı detayını float pencerede göster |
| `[d` / `]d`  | Önceki / sonraki hata-uyarı |
| `<leader>q`  | Hata/uyarıları location list'e aktar |

### ✍️ Otomatik Tamamlama (nvim-cmp)
| Kısayol | Açıklama |
|---|---|
| `<C-Space>` | Tamamlama menüsünü aç |
| `<CR>` | Seçimi onayla |
| `<C-e>` | Menüyü kapat |
| `<C-b>` / `<C-f>` | Dokümantasyonu kaydır |

### 🤖 Yapay Zeka Kopyalama Yardımcısı (Yank to AI)
| Kısayol | Mod | Açıklama |
|---|---|---|
| `<leader>yl` | Normal / Visual | Dosya yolu ve satır numaralarını panoya kopyalar (`src/app.ts:12-25`) |
| `<leader>yc` | Normal / Visual | Seçili kodu dosya referansıyla markdown blok olarak kopyalar |
| `<leader>yf` | Normal | İmlecin bulunduğu sınıf / fonksiyon / metot adını dosya referansıyla kopyalar |
