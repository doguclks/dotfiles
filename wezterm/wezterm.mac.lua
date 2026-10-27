local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================================
-- macOS Görünüm ve Bulanıklık (Blur) Ayarları
-- ============================================================================
config.window_background_opacity = 0.50
config.macos_window_background_blur = 20

-- Gözü yormayan yumuşak arka plan gradyanı (Eye-friendly Gradient)
config.window_background_gradient = {
  colors = {
    '#161a23e6', -- Sol üst: yumuşak koyu arduvaz
    '#1f2432e6', -- Orta: dengeli gece mavisi tonu
    '#272e40e6', -- Sağ alt: zarif füme / lacivert
  },
  orientation = { Linear = { angle = -45.0 } },
  blend = 'Oklab',
  interpolation = 'CatmullRom',
  noise = 64,
}

-- macOS Varsayılan Çalışma Dizini (Dilediğiniz dizinle değiştirebilirsiniz)
config.default_cwd = wezterm.home_dir .. '/Projects'

-- Yazı Tipi (Font) Ayarları: JetBrains Mono + Apple Color Emoji
config.font = wezterm.font_with_fallback({
  { family = 'JetBrains Mono' },
  { family = 'Symbols Nerd Font Mono' },
  { family = 'Apple Color Emoji' },
})
config.font_size = 13.0 -- macOS Retina ekranlar için ideal boyut
config.color_scheme = 'Bright Lights'

-- ============================================================================
-- Renk Paleti ve Sekme Çubuğu Teması
-- ============================================================================
config.colors = {
  ansi = {
    '#363c4a',
    '#ff355b',
    '#b7e876',
    '#ffc251',
    '#76d4ff',
    '#ba76e7',
    '#6cbfb5',
    '#c2c8d7',
  },
  brights = {
    '#78869e',
    '#ff355b',
    '#b7e876',
    '#ffc251',
    '#76d5ff',
    '#ba76e7',
    '#6cbfb5',
    '#c2c8d7',
  },
  tab_bar = {
    background = '#12151c',
    active_tab = {
      bg_color = '#272e40',
      fg_color = '#ffffff',
    },
    inactive_tab = {
      bg_color = '#161a23',
      fg_color = '#78869e',
    },
    inactive_tab_hover = {
      bg_color = '#1f2432',
      fg_color = '#c2c8d7',
    },
    new_tab = {
      bg_color = '#161a23',
      fg_color = '#78869e',
    },
    new_tab_hover = {
      bg_color = '#272e40',
      fg_color = '#ffffff',
    },
  },
}

-- Sekme Çubuğu Görünümü
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- ============================================================================
-- Akıllı Sekme (Tab) Başlıkları
-- ============================================================================
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local is_active = tab.is_active
  local bg = is_active and '#272e40' or (hover and '#1f2432' or '#161a23')
  local fg = is_active and '#ffffff' or (hover and '#c2c8d7' or '#78869e')
  local index_fg = is_active and '#76d4ff' or '#566075'

  local index = tab.tab_index + 1
  local pane = tab.active_pane

  local title = tab.tab_title
  if not title or #title == 0 then
    local proc = pane.foreground_process_name or ''
    local proc_clean = proc:match("([^/\\]+)$") or ''
    proc_clean = proc_clean:gsub("%.exe$", ""):lower()

    local is_shell = proc_clean == 'zsh' or proc_clean == 'bash' or proc_clean == 'fish' or proc_clean == 'pwsh'

    local icon = '⚡'
    if proc_clean == 'node' or proc_clean == 'npm' or proc_clean == 'yarn' or proc_clean == 'pnpm' then
      icon = '🟢'
    elseif proc_clean == 'python' or proc_clean == 'py' then
      icon = '🐍'
    elseif proc_clean == 'git' then
      icon = '🐙'
    elseif proc_clean == 'cargo' or proc_clean == 'rustc' then
      icon = '🦀'
    elseif proc_clean == 'nvim' or proc_clean == 'vim' then
      icon = '📝'
    elseif is_shell then
      icon = '⚡'
    elseif proc_clean ~= '' then
      icon = '📟'
    end

    local dir = ''
    if pane.current_working_dir then
      local path = pane.current_working_dir.file_path or pane.current_working_dir.path or ''
      local base = path:match("([^/\\]+)[/\\]?$")
      if base and #base > 0 then
        dir = base
      end
    end

    if dir ~= '' and proc_clean ~= '' and not is_shell then
      title = icon .. ' ' .. proc_clean .. ' · ' .. dir
    elseif dir ~= '' then
      title = '📁 ' .. dir
    elseif proc_clean ~= '' then
      title = icon .. ' ' .. proc_clean
    else
      title = pane.title or 'terminal'
    end
  end

  if pane.is_zoomed then
    title = title .. ' 🔍'
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = index_fg } },
    { Text = ' ' .. index .. ' ' },
    { Foreground = { Color = fg } },
    { Text = title .. ' ' },
  }
end)

-- ============================================================================
-- Sağ Durum Çubuğu (Sağ üstte Workspace, Pil ve Saat/Tarih gösterir)
-- ============================================================================
wezterm.on('update-right-status', function(window, pane)
  local cells = {}

  -- Çalışma Alanı (Workspace) - 'default' dışında bir isimdeyse göster
  local ws = window:active_workspace()
  if ws and #ws > 0 and ws ~= 'default' then
    table.insert(cells, { Background = { Color = '#1f2432' } })
    table.insert(cells, { Foreground = { Color = '#ffc251' } })
    table.insert(cells, { Text = ' 🗂️  ' .. ws .. ' ' })
  end

  -- Pil Durumu (MacBook pil seviyesi ve şarj durumu)
  local battery_info = wezterm.battery_info()
  if battery_info and #battery_info > 0 then
    local b = battery_info[1]
    local charge = math.floor(b.state_of_charge * 100)
    local icon = '🔋'
    if b.state == 'Charging' then
      icon = '⚡'
    end
    local color = '#b7e876'
    if charge <= 20 and b.state ~= 'Charging' then
      color = '#ff355b'
    elseif charge <= 40 and b.state ~= 'Charging' then
      color = '#ffc251'
    end
    table.insert(cells, { Background = { Color = '#161a23' } })
    table.insert(cells, { Foreground = { Color = color } })
    table.insert(cells, { Text = ' ' .. icon .. ' ' .. charge .. '% ' })
  end

  -- Tarih ve Saat
  local time_str = wezterm.strftime('%d.%m.%Y  %H:%M')
  table.insert(cells, { Background = { Color = '#272e40' } })
  table.insert(cells, { Foreground = { Color = '#76d4ff' } })
  table.insert(cells, { Text = ' 🕒 ' .. time_str .. ' ' })

  window:set_right_status(wezterm.format(cells))
end)

-- ============================================================================
-- Terminal Geçmişini (Scrollback Buffer) Neovim'de Yeni Sekmede Açma
-- ============================================================================
local open_scrollback_in_nvim = wezterm.action_callback(function(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  local temp_dir = os.getenv('TMPDIR') or os.getenv('TEMP') or os.getenv('TMP') or '/tmp'
  local name = string.format('%s/wezterm-scrollback-%d.txt', temp_dir:gsub('\\', '/'), os.time())
  local f = io.open(name, 'w+')
  if f then
    f:write(text)
    f:flush()
    f:close()
  end

  window:perform_action(
    wezterm.action.SpawnCommandInNewTab {
      args = { 'nvim', '+', name },
    },
    pane
  )
end)

-- ============================================================================
-- Sekme Yeniden İsimlendirme Aksiyonu (PromptInputLine)
-- ============================================================================
local rename_tab_action = wezterm.action.PromptInputLine {
  description = 'Sekme için yeni isim girin (Varsayılana dönmek için boş bırakıp Enter\'a basın):',
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
}

-- Komut Paletine (Cmd + Shift + P) özel aksiyonları ekle
wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = 'Rename tab: Sekmeyi yeniden isimlendir',
      icon = 'md_rename_box',
      action = rename_tab_action,
    },
    {
      brief = 'QuickSelect: Metin / Link / Hash hızlı kopyala',
      icon = 'md_select_drag',
      action = wezterm.action.QuickSelect,
    },
    {
      brief = 'Neovim scrollback: Terminal geçmişini Neovim\'de aç',
      icon = 'md_file_document_edit',
      action = open_scrollback_in_nvim,
    },
  }
end)

-- ============================================================================
-- Kısayol Rehberi (Cheat Sheet)
-- ============================================================================
local cheatsheet_choices = {
  { id = 'spawn_tab',    label = '📑 [Cmd + t / Ctrl + t]       Yeni Tab Aç' },
  { id = 'rename_tab',   label = '✏️  [F2 / Cmd + Shift + e]     Sekmeyi Yeniden İsimlendir' },
  { id = 'close_tab',    label = '🗑️  [Cmd + w / Ctrl + Shift + w] Mevcut Tabı Kapat' },
  { id = 'next_tab',     label = '➡️  [Cmd + Shift + ] / Ctrl + Tab] Sonraki Tab' },
  { id = 'prev_tab',     label = '⬅️  [Cmd + Shift + [ / Ctrl + Shift + Tab] Önceki Tab' },
  { id = 'move_tab_left',  label = '◀️  [Cmd + Shift + ◄ / PageUp] Tabı Sola Taşı (Yerini Değiştir)' },
  { id = 'move_tab_right', label = '▶️  [Cmd + Shift + ► / PageDown] Tabı Sağa Taşı (Yerini Değiştir)' },
  { id = 'tab_jump',     label = '🚀 [Cmd + 1..9 / Alt + 1..9]   Sekmelere Doğrudan Zıpla (1-9)' },
  { id = 'quick_select', label = '⚡ [Cmd + Shift + Space]      QuickSelect (Metin / Link / Hash Hızlı Kopyala)' },
  { id = 'nvim_scrollback', label = '📝 [F3 / Cmd + Shift + s]    Terminal Geçmişini Neovim\'de Aç' },
  { id = 'zoom_pane',    label = '🔍 [Ctrl + f / Cmd + Shift + z] Pane Zoom (Büyüt / Odaklan)' },
  { id = 'search_mode',  label = '🔎 [Cmd + f / Ctrl + Shift + f] Terminal Geçmişinde Canlı Arama' },
  { id = 'pane_left',    label = '🧭 [Ctrl + h]                 Pane Gezinme (Sol)' },
  { id = 'pane_down',    label = '🧭 [Ctrl + j]                 Pane Gezinme (Aşağı)' },
  { id = 'pane_up',      label = '🧭 [Ctrl + k]                 Pane Gezinme (Yukarı)' },
  { id = 'pane_right',   label = '🧭 [Ctrl + l]                 Pane Gezinme (Sağ)' },
  { id = 'resize_left',  label = '📏 [Ctrl + Shift + h]         Pane Boyutlandırma (Sola 5)' },
  { id = 'resize_down',  label = '📏 [Ctrl + Shift + j]         Pane Boyutlandırma (Aşağı 5)' },
  { id = 'resize_up',    label = '📏 [Ctrl + Shift + k]         Pane Boyutlandırma (Yukarı 5)' },
  { id = 'resize_right', label = '📏 [Ctrl + Shift + l]         Pane Boyutlandırma (Sağa 5)' },
  { id = 'split_left',   label = '🪟 [Ctrl + Alt + h]           Pane Bölme (Sol %50)' },
  { id = 'split_down',   label = '🪟 [Ctrl + Alt + j]           Pane Bölme (Aşağı %50)' },
  { id = 'split_up',     label = '🪟 [Ctrl + Alt + k]           Pane Bölme (Yukarı %50)' },
  { id = 'split_right',  label = '🪟 [Ctrl + Alt + l]           Pane Bölme (Sağ %50)' },
  { id = 'close_pane',   label = '❌ [Ctrl + Alt + x]           Geçerli Pane\'i Kapat' },
  { id = 'fullscreen',   label = '🖥️  [Cmd + Ctrl + f / F11]    Tam Ekran (Aç / Kapat)' },
  { id = 'font_zoom',    label = '🔍 [Cmd / Ctrl + Tekerlek]   Font Yakınlaştır / Uzaklaştır (Cmd + 0 Sıfırla)' },
  { id = 'palette',      label = '⚙️  [Cmd + Shift + p]         WezTerm Komut Paleti' },
  { id = 'reload',       label = '🔄 [Cmd + Shift + r]         Ayarları Yeniden Yükle' },
}

local show_cheatsheet = wezterm.action.InputSelector {
  title = '📋 WezTerm macOS Kısayol Rehberi',
  choices = cheatsheet_choices,
  fuzzy = true,
  action = wezterm.action_callback(function(window, pane, id, label)
    if not id then return end
    if id == 'spawn_tab' then
      window:perform_action(wezterm.action.SpawnTab 'CurrentPaneDomain', pane)
    elseif id == 'rename_tab' then
      window:perform_action(rename_tab_action, pane)
    elseif id == 'close_tab' then
      window:perform_action(wezterm.action.CloseCurrentTab { confirm = false }, pane)
    elseif id == 'next_tab' then
      window:perform_action(wezterm.action.ActivateTabRelative(1), pane)
    elseif id == 'prev_tab' then
      window:perform_action(wezterm.action.ActivateTabRelative(-1), pane)
    elseif id == 'move_tab_left' then
      window:perform_action(wezterm.action.MoveTabRelative(-1), pane)
    elseif id == 'move_tab_right' then
      window:perform_action(wezterm.action.MoveTabRelative(1), pane)
    elseif id == 'quick_select' then
      window:perform_action(wezterm.action.QuickSelect, pane)
    elseif id == 'nvim_scrollback' then
      window:perform_action(open_scrollback_in_nvim, pane)
    elseif id == 'zoom_pane' then
      window:perform_action(wezterm.action.TogglePaneZoomState, pane)
    elseif id == 'search_mode' then
      window:perform_action(wezterm.action.Search 'CurrentSelectionOrEmptyString', pane)
    elseif id == 'pane_left' then
      window:perform_action(wezterm.action.ActivatePaneDirection 'Left', pane)
    elseif id == 'pane_down' then
      window:perform_action(wezterm.action.ActivatePaneDirection 'Down', pane)
    elseif id == 'pane_up' then
      window:perform_action(wezterm.action.ActivatePaneDirection 'Up', pane)
    elseif id == 'pane_right' then
      window:perform_action(wezterm.action.ActivatePaneDirection 'Right', pane)
    elseif id == 'resize_left' then
      window:perform_action(wezterm.action.AdjustPaneSize { 'Left', 5 }, pane)
    elseif id == 'resize_down' then
      window:perform_action(wezterm.action.AdjustPaneSize { 'Down', 5 }, pane)
    elseif id == 'resize_up' then
      window:perform_action(wezterm.action.AdjustPaneSize { 'Up', 5 }, pane)
    elseif id == 'resize_right' then
      window:perform_action(wezterm.action.AdjustPaneSize { 'Right', 5 }, pane)
    elseif id == 'split_left' then
      window:perform_action(wezterm.action.SplitPane { direction = 'Left', size = { Percent = 50 } }, pane)
    elseif id == 'split_down' then
      window:perform_action(wezterm.action.SplitPane { direction = 'Down', size = { Percent = 50 } }, pane)
    elseif id == 'split_up' then
      window:perform_action(wezterm.action.SplitPane { direction = 'Up', size = { Percent = 50 } }, pane)
    elseif id == 'split_right' then
      window:perform_action(wezterm.action.SplitPane { direction = 'Right', size = { Percent = 50 } }, pane)
    elseif id == 'close_pane' then
      window:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, pane)
    elseif id == 'fullscreen' then
      window:perform_action(wezterm.action.ToggleFullScreen, pane)
    elseif id == 'font_zoom' then
      window:perform_action(wezterm.action.ResetFontSize, pane)
    elseif id == 'palette' then
      window:perform_action(wezterm.action.ActivateCommandPalette, pane)
    elseif id == 'reload' then
      window:perform_action(wezterm.action.ReloadConfiguration, pane)
    end
  end),
}

-- Fare ile kısayol rehberini açma (Ctrl + Sağ Tık) ve Font Büyütme/Küçültme (Cmd/Ctrl + Fare Tekerleği)
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'CTRL',
    action = show_cheatsheet,
  },
  -- Cmd + Fare Tekerleği ile Font Yakınlaştır / Uzaklaştır
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CMD',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CMD',
    action = wezterm.action.DecreaseFontSize,
  },
  -- Ctrl + Fare Tekerleği ile Font Yakınlaştır / Uzaklaştır
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
}

-- ============================================================================
-- Klavye Kısayolları (macOS Standartları + Vim Yön Tuşları)
-- ============================================================================
config.keys = {
  -- Rehber ve Komut Paleti
  { key = "F1", mods = "NONE", action = show_cheatsheet },
  { key = "?", mods = "CTRL|SHIFT", action = show_cheatsheet },
  { key = "p", mods = "CMD|SHIFT", action = wezterm.action.ActivateCommandPalette },
  { key = "p", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },
  { key = "r", mods = "CMD|SHIFT", action = wezterm.action.ReloadConfiguration },
  { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },

  -- Tab Yönetimi (macOS Cmd + t/w ve standart kısayollar)
  { key = "t", mods = "CMD", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "t", mods = "CTRL", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = "F2", mods = "NONE", action = rename_tab_action },
  { key = "e", mods = "CMD|SHIFT", action = rename_tab_action },
  { key = "e", mods = "CTRL|SHIFT", action = rename_tab_action },
  { key = "]", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
  { key = "[", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1), },

  -- Tab Sıralamasını Değiştirme (Tabları Sola / Sağa Taşıma)
  { key = "LeftArrow", mods = "CMD|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
  { key = "RightArrow", mods = "CMD|SHIFT", action = wezterm.action.MoveTabRelative(1) },
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) },
  { key = "PageUp", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
  { key = "PageDown", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) },

  -- QuickSelect Modu (URL, Hash, Dosya Yolu Hızlı Kopyalama)
  { key = "Space", mods = "CMD|SHIFT", action = wezterm.action.QuickSelect },
  { key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },

  -- Terminal Geçmişini (Scrollback) Neovim'de Açma
  { key = "F3", mods = "NONE", action = open_scrollback_in_nvim },
  { key = "s", mods = "CMD|SHIFT", action = open_scrollback_in_nvim },
  { key = "s", mods = "CTRL|SHIFT", action = open_scrollback_in_nvim },

  -- Sekmelere Doğrudan Rakamla Atlama (Cmd + 1..9 & Alt + 1..9)
  { key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "CMD", action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "CMD", action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "CMD", action = wezterm.action.ActivateTab(7) },
  { key = "9", mods = "CMD", action = wezterm.action.ActivateTab(8) },
  { key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
  { key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },

  -- Pane Zoom & Arama
  { key = "f", mods = "CMD", action = wezterm.action.Search "CurrentSelectionOrEmptyString" },
  { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search "CurrentSelectionOrEmptyString" },
  { key = "f", mods = "CTRL", action = wezterm.action.TogglePaneZoomState },
  { key = "z", mods = "CMD|SHIFT", action = wezterm.action.TogglePaneZoomState },
  { key = "z", mods = "CTRL|SHIFT", action = wezterm.action.TogglePaneZoomState },
  { key = "z", mods = "ALT", action = wezterm.action.TogglePaneZoomState },

  -- Pane Gezinme (Vim Style)
  { key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Left" },
  { key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Down" },
  { key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Up" },
  { key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Right" },

  -- Pane Boyutlandırma (Shift ile)
  { key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
  { key = "j", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
  { key = "k", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Right", 5 } },

  -- Pane Bölme (Split)
  { key = "h", mods = "CTRL|ALT", action = wezterm.action.SplitPane { direction = "Left", size = { Percent = 50 } } },
  { key = "j", mods = "CTRL|ALT", action = wezterm.action.SplitPane { direction = "Down", size = { Percent = 50 } } },
  { key = "k", mods = "CTRL|ALT", action = wezterm.action.SplitPane { direction = "Up", size = { Percent = 50 } } },
  { key = "l", mods = "CTRL|ALT", action = wezterm.action.SplitPane { direction = "Right", size = { Percent = 50 } } },

  -- Pane Kapatma
  { key = "x", mods = "CTRL|ALT", action = wezterm.action.CloseCurrentPane { confirm = false } },

  -- macOS Tam Ekran (Cmd + Ctrl + F veya F11)
  { key = "f", mods = "CMD|CTRL", action = wezterm.action.ToggleFullScreen },
  { key = "F11", mods = "NONE", action = wezterm.action.ToggleFullScreen },
}

return config
