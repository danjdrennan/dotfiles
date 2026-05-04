export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# Many other configurations are available but removed from this config. Pull
# the default config or visit the omz repo to explore more options.
ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

if [[ -n $SSH_CONNECTION ]]; then
  export TERM='ghostty'
fi

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# use more features in less (e.g. for man pages)
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/home/danjd/.pixi/bin:$PATH"

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/danjd/.opam/opam-init/init.zsh' ]] || source '/home/danjd/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# bun completions
[ -s "/home/danjd/.bun/_bun" ] && source "/home/danjd/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# cuda
export PATH="/usr/local/cuda-12.8/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-12.8/lib64:$LD_LIBRARY_PATH"

# texlive
export PATH="$HOME/.texlive2026/bin/x86_64-linux:$PATH"
export MANPATH="$HOME/.texlive2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="$HOME/.texlive2026/texmf-dist/doc/info:$INFOPATH"

# rg completions
fpath=($HOME/.zsh-complete $fpath)
