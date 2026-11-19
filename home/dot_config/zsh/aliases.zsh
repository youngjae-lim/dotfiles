# Aliases. Functions live in functions.zsh; agent helpers in agents.zsh.

alias cl='clear'
alias histgrep='echo "[Tip] Use !number to execute the command" && history -i | grep'
alias l='eza -lah'
alias weather="curl 'https://wttr.in?m'"

# Notes (see ~/.local/bin/notes)
alias nt='notes today'     # daily note in nvim
alias note='notes new'     # create/open a markdown note
alias omn='notes open'     # pick an existing markdown note
alias ns='notes pdfs'      # pick a PDF note to open in zathura
alias on='notes recent'    # open the most recent PDF note
alias bs='notes books'     # pick a book to open in zathura
alias apps='launcher'      # fzf app launcher

# Directories
alias dot='cd "$DOTFILES_DIR"'
alias pro='cd "$PROJECTS_DIR"'
alias gdrm='cd "$GOOGLE_DRIVE_DIR/Markdown"'

# chezmoi
alias cz='chezmoi'
alias czd='chezmoi diff'
alias cza='chezmoi apply'
alias cze='chezmoi edit --apply'

