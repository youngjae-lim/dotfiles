# Shell options and key bindings.

# Vim mode
bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

# Edit the current command line in $EDITOR: `v` in normal mode, or Ctrl-X Ctrl-E.
# Handy for writing long agent prompts.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey '^X^E' edit-command-line

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       # timestamps
setopt share_history          # share across sessions (implies inc_append_history)
setopt hist_ignore_space      # ` cmd` stays out of history (use for secrets)
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify

setopt interactive_comments   # allow `# comments` in pasted commands
setopt extendedglob
setopt nomatch
unsetopt beep
