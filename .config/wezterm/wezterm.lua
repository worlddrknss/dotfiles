local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Drknss: old-school black, greys, red and green (shared with .config/starship.toml)
local palette = {
    bg        = "#000000",
    bg1       = "#0d0d0d",
    surface   = "#1a1a1a",
    border    = "#2e2e2e",
    muted     = "#6b6b6b",
    subtle    = "#a3a3a3",
    fg        = "#d9d9d9",
    red       = "#e5332a",
    red_hi    = "#ff3b2f",
    green     = "#4dd44d",
    green_hi  = "#7cff7c",
    olive     = "#b8b84a", -- stands in for yellow
    olive_hi  = "#d7d76a",
    sea       = "#52b788", -- stands in for cyan
    sea_hi    = "#74d6a4",
}

config.color_schemes = {
    ["Drknss"] = {
        foreground    = palette.fg,
        background    = palette.bg,
        cursor_bg     = palette.green,
        cursor_fg     = palette.bg,
        cursor_border = palette.green,
        compose_cursor = palette.red,
        selection_bg  = "#333333",
        selection_fg  = palette.fg,
        scrollbar_thumb = palette.border,
        split         = palette.border,
        -- black, red, green, yellow, blue, magenta, cyan, white:
        -- blue and magenta are greys, yellow/cyan are green-family shades
        ansi = {
            palette.surface, palette.red, palette.green, palette.olive,
            "#8c8c8c", "#a6a6a6", palette.sea, "#c8c8c8",
        },
        brights = {
            "#4d4d4d", palette.red_hi, palette.green_hi, palette.olive_hi,
            "#b3b3b3", "#cccccc", palette.sea_hi, "#ffffff",
        },
        tab_bar = {
            background = palette.bg,
            active_tab = { bg_color = palette.surface, fg_color = palette.green, intensity = "Bold" },
            inactive_tab = { bg_color = palette.bg, fg_color = palette.muted },
            inactive_tab_hover = { bg_color = palette.bg1, fg_color = palette.subtle },
            new_tab = { bg_color = palette.bg, fg_color = palette.muted },
            new_tab_hover = { bg_color = palette.bg1, fg_color = palette.green },
        },
    },
}
config.color_scheme = "Drknss"

wezterm.on("gui-startup", function(cmd)
    local screen            = wezterm.gui.screens().active
    local ratio             = 0.7
    local width, height     = screen.width * ratio, screen.height * ratio
    -- Keep any program passed via `wezterm start -- <cmd>`
    local args = cmd or {}
    args.position = {
        x = (screen.width - width) / 2,
        y = (screen.height - height) / 2,
        origin = 'ActiveScreen' }
    local tab, pane, window = wezterm.mux.spawn_window(args)
    -- window:gui_window():maximize()
    window:gui_window():set_inner_size(width, height)
  end)

-- Font Configurations
config.font_size = 14
config.line_height = 1.2
-- DankMono is a paid font; fall back to the free JetBrainsMono Nerd Font
-- (brew install --cask font-jetbrains-mono-nerd-font) so icons still render.
config.font = wezterm.font_with_fallback({
    "DankMono Nerd Font",
    "JetBrainsMono Nerd Font",
})

-- Key Bindings
config.keys = {
    {
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentPane {
            confirm = false,
        },
    },
    {
        key = "d",
        mods = "CMD",
        action = wezterm.action.SplitHorizontal {
            domain = "CurrentPaneDomain"
        },
    },
    {
        key = "d",
        mods = "CMD|SHIFT",
        action = wezterm.action.SplitVertical {
            domain = "CurrentPaneDomain"
        },
    },
    {
        key = "x",
        mods = "CMD",
        -- Clear screen + scrollback without typing into the running program
        action = wezterm.action.Multiple {
            wezterm.action.ClearScrollback "ScrollbackAndViewport",
            wezterm.action.SendKey { key = "l", mods = "CTRL" },
        },
    },
    {
        key = "Enter",
        mods = "CMD|SHIFT",
        action = wezterm.action.TogglePaneZoomState,
    },
    -- Toggle k8s context in the Starship prompt (toggle_k8s_widget in .zshrc)
    {
        key = "k",
        mods = "CMD",
        action = wezterm.action.SendString("\x1b[1;P1"),
    },
    {
        key = "LeftArrow",
        mods = "OPT",
        action = wezterm.action.SendString("\x1bb")
    },
    {
        key = "RightArrow",
        mods = "OPT",
        action = wezterm.action.SendString("\x1bf")
    },
    -- Pane navigation
    {
        key = "LeftArrow",
        mods = "CMD|OPT",
        action = wezterm.action.ActivatePaneDirection "Left",
    },
    {
        key = "RightArrow",
        mods = "CMD|OPT",
        action = wezterm.action.ActivatePaneDirection "Right",
    },
    {
        key = "UpArrow",
        mods = "CMD|OPT",
        action = wezterm.action.ActivatePaneDirection "Up",
    },
    {
        key = "DownArrow",
        mods = "CMD|OPT",
        action = wezterm.action.ActivatePaneDirection "Down",
    },
}

-- Background: black at 70% opacity, blurred (color comes from the scheme's bg)
config.window_background_opacity = 0.70
config.macos_window_background_blur = 40

-- Window Frame (Border)
config.window_frame = {
    border_left_width = 2,
    border_right_width = 2,
    border_bottom_height = 2,
    border_top_height = 2,
    border_left_color = palette.border,
    border_right_color = palette.border,
    border_bottom_color = palette.border,
    border_top_color = palette.border,
    -- Tab bar strip (shown when more than one tab is open)
    active_titlebar_bg = palette.bg,
    inactive_titlebar_bg = palette.bg,
}

-- Misc Configurations
config.max_fps = 120
config.prefer_egl = true
config.hide_tab_bar_if_only_one_tab = true
-- config.window_decorations = "RESIZE"
config.scrollback_lines = 50000
config.adjust_window_size_when_changing_font_size = false

-- Padding
config.window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
}

-- Dim inactive panes
config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.6,
}

return config
