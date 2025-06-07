local wezterm = require("wezterm")

return {
	scrollback_lines = 10000,
	window_background_opacity = 0.75, -- Adjust this value (0.0 to 1.0) for desired transparency
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action({
				SpawnCommandInNewTab = {
					cwd = os.getenv("HOME"),
					args = { "bash", "-c", "~/.dotfiles/scripts/open_project.sh" },
				},
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
			action = wezterm.action({ SendString = "\x1b\x7f" }), -- Sends the correct escape sequence
		},
		{
			key = "q",
			mods = "CTRL",
			action = wezterm.action({
				SpawnCommandInNewTab = {
					args = { "bash", "-c", "source ~/.bashrc; ~/scripts/quick_question.sh" },
				},
				-- set_environment_variables = {
				-- 	DISPLAY = ":0",
				-- 	PATH = os.getenv("PATH"),
				-- },
			}),
		},
	},
	font_size = 16,
}
