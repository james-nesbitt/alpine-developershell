

# Load from ~/.zshrc.d
if [ -d "${HOME}/.zshrc.d" ]; then
        for zshfile in ${HOME}/.zshrc.d/*; do
                source "${zshfile}"
        done
        unset zshfile
fi

