local wezterm = require 'wezterm'
local config = wezterm.config_builder()

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

-- Background Image
config.background = {
    {
        source = {
            Color = "#000000",
        },
        width = "100%",
        height = "100%",
        opacity = 0.8,
    },
    {
        source = {
            File = {
                path = wezterm.config_dir .. "/assets/background.jpg",
            },
        },
        horizontal_align = "Center",
        vertical_align   = "Middle",
        opacity = 0.3,
    },
}

-- Blur Configuations
-- Transparency comes from the background layers above; window_background_opacity
-- would add another implicit layer on top of them.
config.macos_window_background_blur = 30

-- Window Frame (Border)
config.window_frame = {
    border_left_width = 2,
    border_right_width = 2,
    border_bottom_height = 2,
    border_top_height = 2,
    border_left_color = "#333333",
    border_right_color = "#333333",
    border_bottom_color = "#333333",
    border_top_color = "#333333",
}

-- Misc Configurations
config.max_fps = 120
config.prefer_egl = true
config.hide_tab_bar_if_only_one_tab = true
-- config.window_decorations = "RESIZE"
config.color_scheme = 'OneDark (base16)'
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
