#-------------------------------------------------
# LOGIN
#-------------------------------------------------

if status --is-login
    for file in (status dirname)/login/*.fish
        source $file
    end
end

#-------------------------------------------------
# INTERACTIVE
#-------------------------------------------------

if status --is-interactive
    for file in (status dirname)/interactive/*.fish
        source $file
    end
end

#-------------------------------------------------
# LOCAL
#-------------------------------------------------

for file in (status dirname)/local/*.fish
    source $file
end

if test -e "$HOME/.config/fish/private.fish"
    source "$HOME/.config/fish/private.fish"
end

if test -e "$HOME/.gusto/init.sh"
    # Reuse Aliases from ~/.bash_profile
    egrep "^alias " ~/.bash_profile | while read e
        set var (echo $e | sed -E "s/^alias ([A-Za-z0-9_-]+)=(.*)\$/\1/")
        set value (echo $e | sed -E "s/^alias ([A-Za-z0-9_-]+)=(.*)\$/\2/")

        # remove surrounding quotes if existing
        set value (echo $value | sed -E "s/^\"(.*)\"\$/\1/")

        # evaluate variables. we can use eval because we most likely just used "$var"
        set value (eval echo $value)

        # set an alias
        alias $var="$value"
    end

    # Reuse environment variables from ~/.bash_profile
    egrep "^export " ~/.bash_profile | while read e
        set var (echo $e | sed -E "s/^export ([A-Za-z0-9_]+)=(.*)\$/\1/")
        set value (echo $e | sed -E "s/^export ([A-Za-z0-9_]+)=(.*)\$/\2/")

        # remove surrounding quotes if existing
        set value (echo $value | sed -E "s/^\"(.*)\"\$/\1/")

        if test $var = PATH
            # replace ":" by spaces. this is how PATH looks for Fish
            set value (echo $value | sed -E "s/:/ /g")

            # use eval because we need to expand the value
            eval set -xg $var $value

            continue
        end

        # evaluate variables. we can use eval because we most likely just used "$var"
        set value (eval echo $value)

        #echo "set -xg '$var' '$value' (via '$e')"

        switch $value
            case '`*`'
                # executable
                set NO_QUOTES (echo $value | sed -E "s/^\`(.*)\`\$/\1/")
                set -x $var (eval $NO_QUOTES)
            case '*'
                # default
                set -xg $var $value
        end
    end
end

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

mise activate fish | source
