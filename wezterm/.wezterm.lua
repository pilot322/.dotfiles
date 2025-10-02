local wezterm = require("wezterm")

-- Create a config table that we can build up
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is the list of colors that will be cycled through for the active tab.
local tab_colors = {
	"#e61259",
	"#FFFFFF",
	"#FFFFFF",
	"#FF9933",
}

local tab_foregrounds = {
	"#fcc556",
	"#000000",
	"#00ba8e",
	"#26ff00",
}

local inactive_tab_foregrounds = {
	"#e61259",
	"#FFFFFF",
	"#FFFFFF",
	"#FF9933",
}

-- Custom title and icon functions from your script
local process_icons = {
	["bash"] = wezterm.nerdfonts.cod_terminal_bash,
	["zsh"] = wezterm.nerdfonts.dev_terminal,
	["nvim"] = wezterm.nerdfonts.custom_vim,
	["git"] = wezterm.nerdfonts.fa_git,
	-- Add any other process icons you use here
}

local function remove_abs_path(path)
	return path:gsub("(.*[/\\])(.*)", "%2")
end

local function get_display_cwd(tab)
	local current_dir = tab.active_pane.current_working_dir.file_path or ""
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
	return current_dir == HOME_DIR and "~/" or remove_abs_path(current_dir)
end

local function get_process(tab)
	if not tab.active_pane or tab.active_pane.foreground_process_name == "" then
		return "[?]"
	end
	local process_name = remove_abs_path(tab.active_pane.foreground_process_name)
	return process_icons[process_name] or string.format("[%s]", process_name)
end

local function format_title(tab)
	local cwd = get_display_cwd(tab)
	local process = get_process(tab)
	local active_title = tab.active_pane.title
	local description = (not active_title or active_title == cwd) and "" or active_title
	return string.format(" %s %s %s ", process, cwd, description)
end

local function has_unseen_output(tab)
	if not tab.is_active then
		for _, pane in ipairs(tab.panes) do
			if pane.has_unseen_output then
				return true
			end
		end
	end
	return false
end

local function get_tab_title(tab)
	local title = tab.tab_title
	if title and #title > 0 then
		return title
	end
	return format_title(tab)
end

-- =======================================================
-- Tab Title Formatting Event
-- =======================================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = get_tab_title(tab)

	local color = tab_colors[(tab.tab_index % #tab_colors) + 1]
	local foreground = tab_foregrounds[(tab.tab_index % #tab_colors) + 1]
	local inactive_foreground = inactive_tab_foregrounds[(tab.tab_index % #tab_colors) + 1]
	if tab.is_active then
		-- Select a color from our list using the tab's index

		return {
			{ Attribute = { Intensity = "Bold" } },
			{ Background = { Color = color } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
		}
	end

	if has_unseen_output(tab) then
		return {

			{ Background = { Color = "rgba(0, 0, 0, 0.75)" } },
			{ Foreground = { Color = "#FF0000" } },
			{ Text = " " .. wezterm.nerdfonts.cod_bell_dot .. " " .. title },
		}
	else
		return {
			{ Background = { Color = "rgba(0, 0, 0, 0.75)" } },
			{ Foreground = { Color = inactive_foreground } },
			{ Text = title },
		}
	end

	return title
end)

-- =======================================================
-- Your Original Configuration Settings
-- =======================================================
config.scrollback_lines = 10000
config.window_background_opacity = 0.75
config.window_decorations = "RESIZE"
config.window_frame = {
	active_titlebar_bg = "rgba(0, 0, 0, 0.75)",
	inactive_titlebar_bg = "rgba(0, 0, 0, 0.75)",
}

config.use_fancy_tab_bar = false
config.tab_max_width = 70
config.colors = {
	tab_bar = {
		-- This sets the background of the entire tab bar, including the empty space
		background = "rgba(0, 0, 0, 0.75)",
        -- This section styles the new tab button (+)
        new_tab = {
            bg_color = "rgba(0, 0, 0, 0.75)",
            fg_color = "#CCCCCC", -- A light gray for the '+' symbol
        },
	},
}

config.font_size = 16
config.keys = {
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action({
			SpawnCommandInNewTab = { cwd = os.getenv("HOME") },
		}),
	},
	{
		key = "9",
		mods = "CTRL",
		action = wezterm.action({
			ActivateTabRelative = -1,
		}),
	},
	{
		key = "0",
		mods = "CTRL",
		action = wezterm.action({
			ActivateTabRelative = 1,
		}),
	},
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action({
			SendString = "\x01d\x08\x08\x08\r~/.dotfiles/scripts/open_project.sh\r",
		}),
	},
	{
		key = "v",
		mods = "CTRL|ALT",
		action = wezterm.action({
			SpawnCommandInNewTab = {
				cwd = os.getenv("HOME"),
				args = { "bash", "-c", "~/.dotfiles/scripts/open_vaults.sh" },
			},
		}),
	},
	{
		key = "Backspace",
		mods = "CTRL",
		action = wezterm.action({ SendString = "\x1b\x7f" }),
	},
	{
		key = "q",
		mods = "CTRL",
		action = wezterm.action({
			SpawnCommandInNewTab = {
				args = { "bash", "-c", "source ~/.bashrc; ~/scripts/quick_question.sh" },
			},
		}),
	},
}

-- Finally, return the config table
return config
