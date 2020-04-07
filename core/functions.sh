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
  done 2> /dev/null &
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

symlink_from_to() {
  local FROM=$1
  local TO=$2

  if [ ! -e "$TO" ]; then
    ln -fs "$FROM" "$TO"
    print_success "Successfully symlinked"
  elif [ "$(readlink "$TO")" == "$FROM" ]; then
    print_success "Already symlinked"
  else
    ask_for_confirmation "$(basename $TO) already exists, overwrite it?"

    if answer_is_yes; then
      rm -rf "$TO"
      ln -fs "$FROM" "$TO"
      print_success "Successfully symlinked"
    else
      print_info "Skipping symlink $(basename $FROM)"
    fi
  fi
}

# symlink_dot() {
#   args=($@)

#   local i=''
#   local FROM=''
#   local TO=''

#   for i in "${args[@]}"; do
#     FROM="$(pwd)/$i"
#     TO="$HOME/.$(printf "%s" "$i" | cut -f 1 -d '.' | sed "s/.*\/\(.*\)/\1/g")"

#     symlink_from_to $FROM $TO
#   done

#   unset args
# }

modify_file() {
  if ! grep -q "$2" "$3"; then
    awk "/$1/{print;print \"$2\";next}1" \
      "$3" > "$3.tmp" && mv "$3.tmp" "$3"
  fi
}

modify_line() {
  awk "{gsub(\"$1\", \"$2\")}1" \
    "$3" > "$3.tmp" && mv "$3.tmp" "$3"
}

insert_to_file_after_line_number() {
  # $1 - var | $2 - line | $3 file
  awk -v insert="$1" "{ print } NR==$2 { print insert }" \
    "$3" > "$3.tmp" && mv "$3.tmp" $3
}

uncomment_line() {
  sed -i '' "/$1/s/^#//g" $2
}

prepend_string_to_file () {
  echo "$1" | cat - "$2" > "$2.tmp" && mv "$2.tmp" "$2"
}
