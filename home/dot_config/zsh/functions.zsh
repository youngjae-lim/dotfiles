# Small shell functions.

# Look and feel come from FZF_DEFAULT_OPTS (env.zsh); $2 caps the height
_fzf_pick() { fzf --height="~${2:-60%}" --header="$1" "${@:3}"; }
_tree_preview='eza --tree --level=2 --color=always --icons=always {}'

cdf() {
  local selected
  selected=$(find * -maxdepth 1 -type d 2>/dev/null |
    _fzf_pick 'Pick a directory to navigate to' 60% --preview="$_tree_preview")
  [[ -z $selected ]] && echo 'Nothing was selected :(' || cd "$selected"
}

fav() {
  local dirs=("$GOOGLE_DRIVE_DIR" "$DOTFILES_DIR" "$PROJECTS_DIR" "$NVIM_DIR" "$SHELL_TRASH_DIR")
  local selected
  selected=$(printf "%s\n" "${dirs[@]}" | _fzf_pick 'Pick a directory to navigate to' 60% --preview="$_tree_preview")
  [[ -z $selected ]] && echo 'Nothing was selected :(' || cd "$selected"
}

mkcd() { mkdir -p "$1" && cd "$1"; }
numfiles() { echo "$(ls -A "${1:-.}" | wc -l | tr -d ' ') files in ${1:-.}"; }
tarmake() { tar -czvf "${1%/}.tar.gz" "$1"; }
tarunmake() { tar -zxvf "$1"; }

# fzf over Host entries in ~/.ssh/config, then ssh to the alias.
sshf() {
  [[ -e ~/.ssh/config ]] || { echo 'There is no SSH config file!'; return 1; }
  local hosts selected
  hosts=$(awk '/^Host / { for (i = 2; i <= NF; i++) if ($i !~ /[*?]/) print $i }' ~/.ssh/config)
  [[ -n $hosts ]] || { echo 'There are no hosts in SSH config file'; return 1; }
  selected=$(printf "%s\n" "$hosts" | _fzf_pick 'Pick a host' 30%)
  [[ -n $selected ]] || { echo 'Nothing was selected :('; return; }
  echo "SSH to ${selected}..." && ssh "$selected"
}

# Jump to a zoxide directory as a herdr workspace (replaces the old tmux `tt`).
tt() {
  local dir
  dir=$(zoxide query -l | _fzf_pick 'Pick a project to open in herdr')
  [[ -n $dir ]] || return
  if [[ $HERDR_ENV == 1 ]]; then
    herdr workspace create --cwd "$dir" --label "${dir:t}" --focus >/dev/null
  else
    cd "$dir" && herdr
  fi
}

# tmux fallback helpers (herdr is the default multiplexer).
tmuxf() {
  local selected
  selected=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | _fzf_pick 'Pick a tmux session' 30%)
  [[ -n $selected ]] || { echo 'Nothing was selected :('; return; }
  if [[ -n $TMUX ]]; then tmux switch-client -t "$selected"; else tmux attach-session -t "$selected"; fi
}

tmuxkill() {
  local selected confirmation
  selected=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | _fzf_pick 'Select a tmux session to kill' 30%)
  [[ -n $selected ]] || { echo "No tmux session selected."; return; }
  read -r "confirmation?Kill tmux session '${selected}'? [y/N] "
  [[ $confirmation =~ ^[Yy]$ ]] && tmux kill-session -t "$selected" && echo "Killed '${selected}'."
}

# Update everything from one fzf menu. Loops until nothing is selected.
updater() {
  local stuff=('dotfiles (chezmoi update)' 'zsh plugins' 'homebrew' 'mise runtimes' 'agent CLIs' 'herdr')
  local selected
  while true; do
    selected=$(printf "%s\n" "${stuff[@]}" | _fzf_pick '[Updater] What are you going to update?' 30%)
    [[ -n $selected ]] || { echo '[Updater] Done'; return; }
    echo "[Updater] Updating ${selected}\n-----"
    case "$selected" in
      dotfiles*)      chezmoi update ;;
      'zsh plugins')  shell_upgrade ;;
      homebrew)       brew update && brew upgrade && brew cleanup; zathura-link-plugins ;;
      'mise runtimes') mise upgrade ;;
      'agent CLIs')   claude update; brew upgrade copilot-cli gemini-cli ;;
      herdr)          brew upgrade herdr ;;
    esac
    echo "-----"
  done
}
