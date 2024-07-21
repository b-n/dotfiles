#!/bin/zsh

LOG_PREFIX="[\x1b[;1mSETUP\x1b[;0m"
LOG_SUFFIX="\x1b[;0m]"
LOG_INFO="$LOG_PREFIX::\x1b[34mINFO\x1b[;0m$LOG_SUFFIX"
LOG_ERROR="$LOG_PREFIX::\x1b[31mERROR\x1b[;0m$LOG_SUFFIX"

function log_i {
  echo "$LOG_INFO: $1"
}

function log_err {
  >&2 echo "$LOG_ERROR: $1"
  exit 1
}

function setup_oh_my_zsh {
  log_i "Setting up oh-my-zsh"
  if [ command -v omz &> /dev/null ]; then
    log_i "omz already exists, skipping..."
    return 0
  fi  
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
  log_i "DONE"
}

function setup_rust {
  log_i "Setting up rust"
  export RUSTUP_HOME="$HOME/.rustup"
  export CARGO_HOME="$HOME/.cargo"
  if [ -d $RUSTUP_HOME ]; then
    log_i "$RUSTUP_HOME already exists, skipping..."
    return 0
  fi
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | RUSTUP_HOME=$RUSTUP_HOME CARGO_HOME=$CARGO_HOME sh
  if [ $? != 0 ]; then
    log_err "Failed setting up node"
  fi
  log_i "DONE"
}

function setup_node {
  log_i "Setting up node"
  export N_PREFIX="$HOME/.n"
  if [ -d $N_PREFIX ]; then
    log_i "$N_PREFIX already exists, skipping..."
    return 0
  fi
  curl -L https://bit.ly/n-install | N_PREFIX=$N_PREFIX bash
  if [ $? != 0 ]; then
    log_err "Failed setting up node"
  fi
  [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
  log_i "DONE"
}

function setup_vim {
  log_i "Setting up vim"
  mkdir -p ~/.vim/undo ~/.vim/swap ~/.vim/backup
  ln -sf $PWD/.vimrc ~/.vimrc
  ln -sfT $PWD/.vim/plugin/ ~/.vim/plugin/
  ln -sfT $PWD/.vim/colors/ ~/.vim/colors/
  if [ ! -d ~/.vim/bundle ]; then
    log_i "Running PlugInstall"
    vim +PlugInstall
  fi
  log_i "DONE"
}

function setup {
  setup_rust
  setup_node
  setup_vim
  log_i "Starting a new shell is advised"
}

setup
