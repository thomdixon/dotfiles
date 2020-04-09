# Use antigen
source $HOME/.antigen.zsh

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  command-not-found
  git
  gitignore
  jsontools
  python
  sudo
  wd
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

# The tmux plugin is a little finnicky and doesn't like to be loaded at the
# same time as the others
ZSH_TMUX_AUTOSTART=true
antigen bundle tmux

antigen theme robbyrussell

# Set our PATH before applying
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

antigen apply

# unquote
alias unq="sed -e 's/^\"\(.*\)\"$/\1/g'"

# repaint by default
alias less="less -R"

# mkdir and cd into it
mkcd() {
    mkdir -p "$1"
    builtin cd "$1"
}

# improve tree
tree() {
    # fancy UTF8 codes, colors, don't clear screen, quit if output is short
    command tree --charset UTF8 -C "$@" | less -RXF
}

# Vagrant aliases
alias vu="vagrant up"
alias vd="vagrant destroy -f"
alias vst="vagrant status"
alias vgst="vagrant global-status"
alias vssh="vagrant ssh"

# use thefuck
eval "$(thefuck --alias)"

# make cd perform ls, with truncation for long output
cd() { autoenv_cd "$@" && _truncated_ls }
popd() { builtin popd "$@" && _truncated_ls }
pushd() { builtin pushd "$@" && _truncated_ls }

# use neovim instead of vim if installed
if hash nvim >/dev/null 2>&1; then
    _VIM_COMMAND=nvim
else
    _VIM_COMMAND=vim
fi

vim() { command $_VIM_COMMAND $@ }

# try to use gnu's version of ls, needed for --group-directories-first
# on OS X, you'll need to run `brew install coreutils`
if hash gls >/dev/null 2>&1; then
    # gls maps to gnu coreutil's ls on OS X
    _GLS_COMMAND=gls
else
    _GLS_COMMAND=ls
fi

# map ls to gls installed via coreutils in brew, and add some aliases
ls() {
  command $_GLS_COMMAND --group-directories-first \
                        --format=across \
                        --color=always \
                        --width=$COLUMNS $@
}

alias l="ls -A"
alias lf="ls -f"

# a pretty ls truncated to at most N lines; helper function for cd, popd, pushd
_truncated_ls() {
    local LS_LINES=8 # use no more than N lines for ls output
    local RESERVED_LINES=5 # reserve N lines of the term, for short windows
    # eg. if a window is only 8 lines high, we want to avoid filling up the
    # whole screen, so instead only 3 lines would be consumed.

    # if using all N lines makes us go over the reserved number of lines
    if [[ $(($LINES - $RESERVED_LINES)) -lt $LS_LINES ]]; then
        local LS_LINES=$(($LINES - $RESERVED_LINES))
    fi

    # compute and store the result of ls
    local RAW_LS_OUT="$(command $_GLS_COMMAND --group-directories-first \
                                              --format=across \
                                              --color=always \
                                              --width=$COLUMNS)"
    local RAW_LS_LINES="$(command wc -l <<< "$RAW_LS_OUT")"

    if [[ $RAW_LS_LINES -gt $LS_LINES ]]; then
        command head -n $(($LS_LINES - 1)) <<< "$RAW_LS_OUT"
        _right_align "... $(($RAW_LS_LINES - $LS_LINES + 1)) lines hidden"
    else
        builtin echo -E "$RAW_LS_OUT"
    fi
}

# right align text and echo it; helper function for _truncated_ls
_right_align() {
    local PADDING=$(($COLUMNS - ${#1}))
    [[ $PADDING -gt 0 ]] && builtin printf "%${PADDING}s"
    builtin echo "$1"
}

# RVM
export PATH="$PATH:$HOME/.rvm/bin"

# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# TeX
export PATH="$PATH:/usr/texbin"

