answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1
}

ask() {
    print_question "$1"
    read
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -n 1
    printf "\n"
}

ask_for_sudo() {
    # Ask for the administrator password upfront
    sudo -v

    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

cmd_exists() {
    [ -x "$(command -v "$1")" ] \
        && printf 0 \
        || printf 1
}

execute() {
    $1 &> /dev/null
    print_result $? "${2:-$1}"
}

get_answer() {
    printf "$REPLY"
}

get_os() {
    declare -r OS_NAME="$(uname -s)"
    local os=""

    if [ "$OS_NAME" == "Darwin" ]; then
        os="osx"
    elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os="ubuntu"
    fi

    printf "%s" "$os"
}

is_git_repository() {
    [ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ] \
        && return 0 \
        || return 1
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_info() {
    # Print output in blue
    printf "\n\e[0;34m 👊  $1\e[0m\n"
}

print_question() {
    # Print output in yellow
    printf "\e[0;33m 🤔  $1\e[0m\n"
}

print_success() {
    printf "\e[0;32m 👍  $1\e[0m\n"
}

print_error() {
    # Print output in red
    printf "\e[0;31m 😡  $1 $2\e[0m\n"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

symlinkFromTo() {
    local FROM=$1
    local TO=$2

    if [ ! -e "$TO" ]; then
        execute "ln -fs $FROM $TO" "$FROM → $TO"
    elif [ "$(readlink "$TO")" == "$FROM" ]; then
        print_success "Already linked... $FROM → $TO"
    else
        ask_for_confirmation "$TO already exists, do you want to overwrite it?"

        if answer_is_yes; then
            rm -rf "$TO"
            execute "ln -fs $FROM $TO" "$FROM → $TO"
        else
            print_error "Skipping... $FROM → $TO"
        fi
    fi
}

symlinkDot() {
    args=($@)

    local i=''
    local FROM=''
    local TO=''

    for i in "${args[@]}"; do
        FROM="$(pwd)/$i"
        TO="$HOME/.$(printf "%s" "$i" | cut -f 1 -d '.' | sed "s/.*\/\(.*\)/\1/g")"

        symlinkFromTo $FROM $TO
    done

    unset args
}

modify_file() {
    if ! grep -q "$2" "$3"; then
        awk "/$1/{print;print \"$2\";next}1" \
            "$3" > "$3.tmp" &&
        mv "$3.tmp" "$3"
    fi
}

modify_line() {
    awk "{gsub(\"$1\", \"$2\")}1" \
        "$3" > "$3.tmp" &&
    mv "$3.tmp" "$3"
}

uncomment_line() {
    sed -i '' "/$1/s/^#//g" $2
}
