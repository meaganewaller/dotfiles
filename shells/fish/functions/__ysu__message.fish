function __ysu__message \
    --argument-names alias_type command alias
    # zero-width space delinates the end of a variable and the beginning of the message
    __ysu__write_buffer "\
$BOLD$YELLOW​Found existing $alias_type for \"$VIOLET$command$YELLOW\".
You should use: \"$alias\"\n"
end
