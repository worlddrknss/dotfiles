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
}

-- Blur Configuations
config.macos_window_background_blur = 30
config.window_background_opacity = 0.80

-- Misc Configuations
config.max_fps = 120
config.prefer_egl = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

return config
