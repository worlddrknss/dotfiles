local wezterm = require 'wezterm'
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
    local screen            = wezterm.gui.screens().active
    local ratio             = 0.7
    local width, height     = screen.width * ratio, screen.height * ratio
    local tab, pane, window = wezterm.mux.spawn_window {
      position = {
        x = (screen.width - width) / 2,
        y = (screen.height - height) / 2,
        origin = 'ActiveScreen' }
    }
    -- window:gui_window():maximize()
    window:gui_window():set_inner_size(width, height)
  end)

-- Font Configurations
config.font_size = 14
config.line_height = 1.2
config.font = wezterm.font("DankMono Nerd Font")

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
        action = wezterm.action.SendString "clear\n"
    },
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
}

-- Colors
-- config.colors = {
--     background = "#000000",
-- }

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
                path = wezterm.config_dir .. "/assets/background.gif",
            },
        },
        horizontal_align = "Center",
        vertical_align   = "Middle",
        opacity = 0.1,
    },
}

-- Blur Configuations
config.macos_window_background_blur = 30
config.window_background_opacity = 0.80

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

-- Misc Configuations
config.max_fps = 120
config.prefer_egl = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.color_scheme = 'Chalk'
return config
