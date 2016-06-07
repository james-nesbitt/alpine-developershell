####
# ZSH configuration
#

# Load any rc files inside ~/.zshrc.d
if [ -d "${HOME}/.zshrc.d" ]; then
  for zshfile in ${HOME}/.zshrc.d/*; do
    source ${zshfile}
  done
fi

