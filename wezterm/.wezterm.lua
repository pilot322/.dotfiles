local wezterm = require 'wezterm'



return {
  scrollback_lines = 10000,
  window_background_opacity = 0.75, -- Adjust this value (0.0 to 1.0) for desired transparency
  keys = {
    {
      key = 'f',
      mods = 'CTRL',
      action = wezterm.action { SpawnCommandInNewTab = { cwd = os.getenv('HOME'), args = { 'bash', '-c', '~/scripts/open_project.sh' } } }
    },
    {
      key = 'Backspace',
      mods = 'CTRL',
      action = wezterm.action { SendString = '\x1b\x7f' },  -- Sends the correct escape sequence
    },
  },
  font_size = 22.0,
}

