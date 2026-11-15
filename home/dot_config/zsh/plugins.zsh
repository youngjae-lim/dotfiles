#!/bin/zsh

##### Make sure "SHELL_PLUGIN_DIR" env var is set (set in env.zsh) #####

# Double check double check
function source_file() {
  [ -f ${SHELL_PLUGIN_DIR}/$1 ] && source ${SHELL_PLUGIN_DIR}/$1
}

# Function to source or load a plugin
function shell_plug() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [[ -d ${SHELL_PLUGIN_DIR}/${PLUGIN_NAME} ]]; then
    source_file ${PLUGIN_NAME}/${PLUGIN_NAME}.plugin.zsh || \
    source_file ${PLUGIN_NAME}/${PLUGIN_NAME}.zsh
  else
    git clone "https://github.com/${1}.git" ${SHELL_PLUGIN_DIR}/${PLUGIN_NAME}
  fi
}

function shell_upgrade() {
  for repo in ${SHELL_PLUGIN_DIR}/*
  do
    echo "refreshing ${repo}:"
    cd ${repo} && git pull && cd - > /dev/null
  done
}

shell_plug marlonrichert/zsh-autocomplete         # real-time completion menu
shell_plug zsh-users/zsh-autosuggestions          # history-based suggestions
shell_plug zsh-users/zsh-syntax-highlighting      # command highlighting
shell_plug hlissner/zsh-autopair                  # auto-pair brackets/quotes
shell_plug zsh-users/zsh-history-substring-search # substring history search
