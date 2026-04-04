-- Disable mouse
vim.o.mouse = ""

-- Sync clipboard between OS and Neovim
vim.o.clipboard = "unnamedplus"

-- Split right by default
vim.o.splitright = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.swapfile = false
vim.o.backup = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 200
vim.o.timeoutlen = 300

-- Completion experience
vim.o.completeopt = "menuone,noselect,popup,fuzzy"

-- True color
vim.o.termguicolors = true

-- Enable local configs
vim.o.exrc = true
vim.o.secure = true

-- Line numbers: current + relative
vim.o.number = true
vim.o.relativenumber = true

-- Tab defaults
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- No wrap
vim.o.wrap = false

-- Search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Scroll offset
vim.o.scrolloff = 12

-- Include @ in filenames
vim.opt.isfname:append("@-@")

-- Color column
vim.o.colorcolumn = "80"

-- Unix line endings
vim.o.fileformat = "unix"
