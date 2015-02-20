# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

# setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use pushd when changing dirs
setopt autopushd

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt \
    %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' \
    'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt \
    %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

alias apti='sudo aptitude install';
alias aptu='sudo aptitude update && sudo aptitude safe-upgrade';
alias apts='aptitude search'
aptr() { sudo aptitude remove "$*" && sudo apt-get autoremove; }

function rm () { /bin/rm $@ -I; }

alias ls='ls --color'

alias ccat='pygmentize -O bg=dark'

# Finally, create a session if tmux is present
if which tmux 2>&1 >/dev/null; then
    test -z "$TMUX" && tmux new-session
fi
