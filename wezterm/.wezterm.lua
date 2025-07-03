local wezterm = require("wezterm")

return {
    scrollback_lines = 10000,
    window_background_opacity = 0.75,
    window_decorations = "RESIZE",
    window_frame = {
    -- Sets the title bar to black with 75% opacity
        active_titlebar_bg = 'rgba(0, 0, 0, 0.75)',
        inactive_titlebar_bg = 'rgba(0, 0, 0, 0.75)',
    },

    use_fancy_tab_bar = false,
    tab_max_width = 70,
    colors = {
        tab_bar = {
            background = 'rgba(0, 0, 0, 0.75)',
        },
    },
    font_size = 16,
    keys = {
        -- Your other keybindings (CTRL+t, CTRL+9, etc.) can remain the same
        {
            key = "t",
            mods = "CTRL",
            action = wezterm.action({
                SpawnCommandInNewTab = ({ cwd = os.getenv("HOME") }),
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

        -- =======================================================
        -- MODIFIED KEYBINDING FOR PROJECT SWITCHING
        -- =======================================================
        {
            key = "f",
            mods = "CTRL",
            -- SendString "types" the command into the current pane and hits Enter.
            -- The shell will expand `~` correctly. The `\r` is the carriage return (Enter key).
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
            action = wezterm.action({ SendString = "\x1b\x7f" }), -- Sends the correct escape sequence
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
    },
}
