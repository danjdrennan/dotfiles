# neovim config files

<warning>Here is a warning</warning>

Here is a config based on the kickstart.nvim configuration. If you copy this
down into `~/.config/nvim` then it should "just work" (although that's rarely
the case). I think using this got me 95% of the way to working with neovim
regularly. The other 5% was a combination of learning to use `tmux` better and
adding a few modifications in the `nvim/lua` folder that made life easier.

I don't understand this layout very well, but I imagine the person who wrote
kickstart does. He has a video on it at

https://youtu.be/m8C0Cq9Uv9o?si=DDe8zZA4XR-iUpeI

A clean install of `kickstart.md` can be found from

https://github.com/nvim-lua/kickstart.nvim

If you are reinstalling from scratch, you may want to clear all previous neovim
configs using

```bash
rm .local/share/nvim -rf
```

Verify that this is only deleting neovim config by inspecting the directory, but
that should be a safe assumption.
