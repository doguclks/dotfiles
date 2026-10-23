# 🛠️ Dotfiles (Neovim & WezTerm)

Kişisel çapraz platform (macOS & Windows) **Neovim** ve **WezTerm** geliştirme ortamı konfigürasyonları.

---

## ⚡ Özellikler

- **Paket Yöneticisi:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Hızlı Otomatik Tamamlama (Autocomplete):** [blink.cmp](https://github.com/saghen/blink.cmp) (Rust tabanlı yüksek performans)
- **LSP Entegrasyonu:** Neovim native LSP + [Mason.nvim](https://github.com/williamboman/mason.nvim) (Lua, TypeScript/JavaScript, Python, C# / OmniSharp)
- **Sözdizimi Vurgulama:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- **Bulanık Arama:** [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + `fzf-native`
- **Dosya Gezgini & Sekmeler:** [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) & [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- **Git:** [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) & [vim-fugitive](https://github.com/tpope/vim-fugitive)
- **Tema:** [Catppuccin Mocha](https://github.com/catppuccin/nvim) (Tam şeffaflık destekli)
- **Yapay Zeka (AI) Kopyalama:** `<leader>yl`, `<leader>yc`, `<leader>yf` ile AI sohbetlerine doğrudan dosya yolu, kod bloğu veya sınıf/fonksiyon adı aktarma.
- **Terminal:** [WezTerm](https://wezfurlong.org/wezterm/) (Acrylic / Blur, sekme isimlendirme, kısayol rehberi, Windows & macOS uyumlu).

---

## 🍎 macOS Kurulumu

### 1. Gereksinimleri Yükleyin (Homebrew)

Terminal'de (`bash` veya `zsh`) çalıştırın:

```bash
# Xcode geliştirici araçları (Treesitter ve C kütüphaneleri için gereklidir)
xcode-select --install

# Temel paketler
brew install neovim ripgrep fd make cmake node python3

# JetBrains Mono Nerd Font (İkonların düzgün görünmesi için)
brew install --cask font-jetbrains-mono-nerd-font
```

> **Önemli Not:** Bu konfigürasyon modern native `vim.lsp.enable()` API'sini kullandığı için **Neovim 0.11 veya üzeri** önerilir:
> ```bash
> brew install neovim --HEAD
> ```

### 2. Neovim Konfigürasyonunu Klonlayın

```bash
# Mevcut konfigürasyon varsa yedekleyin
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup

# Repoyu ~/.config/nvim olarak klonlayın
git clone https://github.com/doguclks/dotfiles.git ~/.config/nvim
```

### 3. Başlatın

```bash
nvim
```
> İlk açılışta `lazy.nvim` tüm eklentileri otomatik olarak indirecek ve kuracaktır. Eklentiler yüklendikten sonra `nvim`'i kapatıp tekrar açın. Mason LSP sunucuları (`lua_ls`, `ts_ls`, `pyright`, `omnisharp`) otomatik kurulacaktır.

### 4. (İsteğe Bağlı) WezTerm Konfigürasyonunu Bağlayın

```bash
brew install --cask wezterm
cp ~/.config/nvim/wezterm/wezterm.lua ~/.wezterm.lua
```

---

## 🪟 Windows Kurulumu

### 1. Gereksinimleri Yükleyin (Scoop veya Winget)

PowerShell ile:

```powershell
# Scoop ile:
scoop install neovim ripgrep fd git cmake python nodejs
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
```

### 2. Neovim Konfigürasyonunu Klonlayın

```powershell
git clone https://github.com/doguclks/dotfiles.git $env:LOCALAPPDATA\nvim
```

### 3. (İsteğe Bağlı) WezTerm Konfigürasyonunu Bağlayın

```powershell
Copy-Item "$env:LOCALAPPDATA\nvim\wezterm\wezterm.lua" "$HOME\.wezterm.lua"
```

---

## ⌨️ Temel Kısayollar (Cheat Sheet)

Leader tuşu: **`Space` (Boşluk)**

### 📁 Dosya ve Arama (Telescope & Neo-tree)
| Kısayol | Açıklama |
|---|---|
| `<leader>ff` | Dosya ara (Fuzzy find files) |
| `<leader>fg` | Proje içinde metin ara (Live grep) |
| `<leader>fb` | Açık buffer'lar arasında ara |
| `<leader>fh` | Neovim yardım etiketleri |
| `<leader>e`  | Dosya ağacına odaklan / aç / kapat (Neo-tree) |
| `<Tab>`      | Sonraki sekmeye (buffer) geç |
| `<S-Tab>`    | Önceki sekmeye geç |
| `<leader>x`  | Mevcut sekmeyi kapat |
| `<leader>X`  | Mevcut sekmeyi kaydetmeden zorla kapat |

### 🌿 Git (Gitsigns & Fugitive)
| Kısayol | Açıklama |
|---|---|
| `<leader>gs` | Git durum penceresi (Fugitive) |
| `<leader>gd` | Yan yana git diff (Gvdiffsplit) |
| `]c` / `]h`  | Sonraki Git değişikliğine git (Next hunk) |
| `[c` / `[h`  | Önceki Git değişikliğine git (Prev hunk) |
| `<leader>gp` / `<leader>hp` | Değişikliği önizle (Hunk preview) |
| `<leader>ga` / `<leader>hs` | Değişikliği sahneye al (Stage hunk) |
| `<leader>gr` / `<leader>hr` | Değişikliği geri al / sıfırla (Reset hunk) |
| `<leader>gb` | Satır içi Git blame penceresi |
| `<leader>gB` | Canlı satır içi blame aç/kapat |

### 🤖 Yapay Zeka Kopyalama Yardımcısı (Yank to AI)
| Kısayol | Mod | Açıklama |
|---|---|---|
| `<leader>yl` | Normal / Visual | Dosya yolu ve satır numaralarını panoya kopyalar (`src/app.ts:12-25`) |
| `<leader>yc` | Normal / Visual | Seçili kodu dosya referansıyla markdown blok olarak kopyalar |
| `<leader>yf` | Normal | İmlecin bulunduğu sınıf / fonksiyon / metot adını dosya referansıyla kopyalar |

### 🔍 LSP & Kod Gezinme
| Kısayol | Açıklama |
|---|---|
| `gd` | Tanıma git (Go to definition) |
| `gr` | Referansları listele |
| `K`  | Hover dokümantasyonu aç |
| `<leader>rn` | Değişken/fonksiyonu yeniden adlandır (Rename) |
| `<leader>ca` | Kod eylemleri (Code Actions) |
| `<leader>d`  | Hata/uyarı detayını float pencerede göster |
