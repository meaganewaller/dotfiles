# load custom executable functions
for function in ~/.zsh/functions/*; do
    source $functions
done

_load_configs() {
    _dir="$1"
    if [ -d "$_dir" ]; then
        if [ -d "$_dir/pre" ]; then
            for config in "$_dir"/pre/**/*~*.zwc(N-.); do
                . $config
            done
        fi

        for config in "$_dir"/**/*(N-.); do
            case "$config" in
                "$_dir"/(pre|post)/*|*.zwc)
                :
                ;;
            *)
                . $config
                ;;
            esac
        done

        if [ -d "$_dir/post" ]; then
            for config in "$_dir"/post/**/*~*.zwc(N-.); do
                . $config
            done
        fi
    fi
}
_load_configs "$HOME/.zsh/configs"

# Local Config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.aliases ]] && source ~/.aliases