function update-asdf --description 'Update various asdf settings and versions'
    echo "Updating plugins"
    asdf plugin update --all
    echo

    echo "Removing shims and re-shimming"
    rm -rf ~/.asdf/shims && asdf reshim
    echo
end
