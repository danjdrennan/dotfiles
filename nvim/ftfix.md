# ftfix

## Question

I use neovim (btw) with lazy as the package manager. The structure of the plugins config is located in ~/.config/nvim, with local file configs at ~/.config/nvim/ftplugin. For some reason lazy and neovim in general don't seem to recognize my config preferences from ftplugin in the current setup. What do I need to do to rectify this?

---

It sounds like you're having an issue with Neovim not recognizing your filetype-specific configurations in the `~/.config/nvim/ftplugin` directory. This is a common issue that could have a few different causes. Let's troubleshoot this systematically.

### Check Your Filetype Plugin Setting

First, make sure that filetype plugins are enabled in your Neovim configuration. In your `init.lua` or `init.vim`, you should have:

For Lua:
```lua
vim.cmd('filetype plugin on')
```

For Vimscript:
```vim
filetype plugin on
```

### Correct Naming Convention

Ensure your filetype plugin files follow the correct naming convention:
- For a specific filetype, the file should be named `{filetype}.lua` or `{filetype}.vim`
- For example, for Python files: `python.lua` or `python.vim`

### Check File Permissions

Make sure your ftplugin files have the correct permissions:

```bash
chmod 644 ~/.config/nvim/ftplugin/*
```

### Verify Filetype Detection

Check if Neovim is correctly detecting the filetype of your files:

1. Open a file you're having issues with
2. Run `:set filetype?` to see what filetype Neovim thinks it is
3. Make sure this matches the name of your ftplugin file

### Lazy.nvim Specific Issues

Since you're using lazy.nvim, there might be some specific issues:

1. Make sure your plugin configuration isn't overriding filetype settings
2. Check if any plugins you're using have their own ftplugin handling that might conflict

### Debug with Verbose Output

You can check what ftplugin files Neovim is trying to load with:

```vim
:verbose set filetype?
```

### Example of a Proper Setup

Here's how a minimal working setup might look:

```
~/.config/nvim/
├── init.lua           # Main config file
├── ftplugin/
│   ├── python.lua     # Python-specific settings
│   └── markdown.lua   # Markdown-specific settings
└── lua/
    └── plugins.lua    # Lazy.nvim plugin definitions
```

In your `init.lua`:

```lua
-- Enable filetype detection and plugins
vim.cmd('filetype plugin on')

-- Load lazy.nvim
require('plugins')
```

### Additional Troubleshooting

If the above doesn't work, you might want to try:

1. Temporarily move your ftplugin directory to a backup and create a new one with a single test file to see if that works
2. Check if there are any error messages when Neovim starts up with `nvim --startuptime startup.log`
3. Make sure your Neovim version is recent enough (check with `:version`)

Let me know if any of these suggestions help or if you need more specific guidance based on your configuration!