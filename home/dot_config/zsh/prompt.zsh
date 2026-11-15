#!/bin/zsh

## Git
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%b%u%c'
zstyle ':vcs_info:git:*' actionformats '[%b | %a%u%c]'

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

## Vi mode
setopt PROMPT_SUBST

ins_mode_indicator='%F{green}[I]%f'
norm_mode_indicator='%F{red}[N]%f'
vi_mode_indicator=$ins_mode_indicator

# Function to change cursor shape and mode indicator based on Vim keymap
zle-keymap-select() {
    if [[ "$KEYMAP" == 'vicmd' ]]; then
        vi_mode_indicator=$norm_mode_indicator
        echo -ne "\e[1 q"  # Block shape cursor
    else
        vi_mode_indicator=$ins_mode_indicator
        echo -ne "\e[5 q"  # Beam shape cursor
    fi
    zle reset-prompt
}
zle -N zle-keymap-select

zle-line-finish() {
    vi_mode_indicator=$ins_mode_indicator
}
zle -N zle-line-finish

TRAPINT() {
    vi_mode_indicator=$ins_mode_indicator
    return $(( 128 + $1 ))
}

# Function to initialize line with vi insert mode and cursor shape
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q" # Beam shape cursor
}
zle -N zle-line-init

_fix_cursor() {
    echo -ne "\e[5 q" # Beam shape cursor
}
precmd_functions+=(_fix_cursor)

## Setting Prompt
PROMPT="\$vi_mode_indicator ➜  %F{cyan}%(5~|%-1~/.../%3~|%4~)%f %F{blue}\$vcs_info_msg_0_%f | %(?|%F{green}|%F{red})%? ❱ %f"


