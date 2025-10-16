local wezterm = require("wezterm")

local config = wezterm.config_builder()

--Wayland
config.enable_wayland = false

--Font Settings
config.font_size = 13
config.line_height = 1.0
config.font = wezterm.font("FiraCode Nerd Font")

-- Theme ------------------------------------------------------------------
-- Remove all padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_decorations = "RESIZE"

--config.color_scheme = "Atom One Dark"
config.color_scheme = "AtomOneDark"

config.colors = {
	foreground = "#abb2bf",
	background = "#282c34",

	cursor_bg = "#528bff",
	cursor_fg = "black",
	cursor_border = "#528bff",

	selection_fg = "#abb2bf",
	selection_bg = "#3e4451",

	ansi = {
		"#282c34", -- black
		"#e06c75", -- red
		"#98c379", -- green
		"#e5c07b", -- yellow
		"#61afef", -- blue
		"#c678dd", -- magenta
		"#56b6c2", -- cyan
		"#abb2bf", -- white
	},

	brights = {
		"#5c6370", -- bright black
		"#e06c75", -- bright red
		"#98c379", -- bright green
		"#e5c07b", -- bright yellow
		"#61afef", -- bright blue
		"#c678dd", -- bright magenta
		"#56b6c2", -- bright cyan
		"#ffffff", -- bright white
	},
}

-- Transparency (0 = fully transparent, 1 = fully opaque)
--config.window_background_opacity = 1.0

config.max_fps = 60

config.background = {
	{
		source = {
			--File = "/home/kalpesh/Pictures/wallpapers/4321.jpg",
			File = "/home/kalpesh/dotfiles/.config/wezterm/wallpapers/neoncityb.jpg",

		},
		opacity = 1.0, -- make wallpaper transparent
		hsb = {
			brightness = 0.10, -- tweak brightness
			saturation = 1.0,
			hue = 1.0,
		},
		-- Make it act like desktop wallpaper
		vertical_align = "Middle", -- center vertically
		horizontal_align = "Center", -- center horizontally
		width = "Cover", -- scale to cover whole terminal
		height = "Cover", -- keep aspect ratio
	},
}

-- Right-click menu ----------------------------------------------------------------
config.mouse_bindings = {
  -- Keep your right-click menu
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action.ShowLauncher,
  },
}

-- Misc ------------------------------------------------------------------------------
config.scrollback_lines = 10000 -- or 20000 if you want more

config.enable_scroll_bar= false

return config
