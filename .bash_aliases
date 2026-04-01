alias cpf='xclip -selection clipboard <'
run() {
  (ulimit -v 4194304; ulimit -s 4194304; ./$1)
}

rub() {
    process_result() {
        local result="$1"
        if [ -f "$result" ]; then
            dir=$(realpath "$(dirname "$result")")
            printf "\033[1;32m%s\033[0m\n" "$dir"  # Green color for the directory
        elif [ -d "$result" ]; then
            dir=$(realpath "$result")
            printf "\033[1;32m%s\033[0m\n" "$dir"  # Green color for the directory
        fi
    }

    current_dir=$(pwd)

    while true; do
        printf "\033[1;34mSearching --> %s\033[0m\n" "$current_dir"  # Blue color for the searching message
        result=$(find "$current_dir" -wholename "*/$1" 2>/dev/null)
        echo $result
        if [ -n "$result" ]; then
            process_result "$result"
            return
        fi

        if [ "$(realpath "$current_dir")" = "$HOME" ]; then
            break
        fi

        current_dir=$(dirname "$current_dir")
    done

    echo "Error: $1 is neither a file nor a directory in the current or parent directories up to $HOME."
}

alias py="python3"
alias python="python3"
alias timestamp="date +%s"
export EDITOR=vim

dotToSVG() {
    # Set a monospaced font
    FONT_NAME="Courier New"
    if [ "$(uname)" == "Darwin" ]; then
        # On macOS, use Menlo
        FONT_NAME="Menlo"
    elif [ "$(uname)" == "Linux" ]; then
        # On Linux, DejaVu Sans Mono is a common choice
        FONT_NAME="DejaVu Sans Mono"
    fi

    # Temporary file to store modified DOT content
    TMP_DOT=$(mktemp)

    # Use awk to insert font settings right after the digraph line
    awk "/digraph/ {print; print \"  graph [fontname=\\\"$FONT_NAME\\\"]; node [fontname=\\\"$FONT_NAME\\\"]; edge [fontname=\\\"$FONT_NAME\\\"]\"; next}1" $1 > $TMP_DOT
    local ts=$(date +%s);
    # Convert to SVG
    dot -Tsvg -o $1-${ts}.svg $TMP_DOT

    # Remove temporary file
    rm $TMP_DOT
}

fetch-pr() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: fetch-pr <REMOTE> <MR_NUMBER>"
        echo "Example: fetch-pr origin 66"
        return 1
    fi

    local remote="$1"
    local mr_number="$2"
    git fetch "$remote" "pull/${mr_number}/head:pr-${mr_number}"
}


fetch-mr() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: fetch-mr <REMOTE> <MR_NUMBER>"
        echo "Example: fetch-mr origin 66"
        return 1
    fi

    local remote="$1"
    local mr_number="$2"
    git fetch "$remote" "merge-requests/${mr_number}/head:mr-${mr_number}"
}

addpath() {
    if [ -z "$1" ]; then
        echo "Usage: addpath <relative-path> [VARIABLE]"
        echo "  e.g. addpath ./lib LD_LIBRARY_PATH"
        return 1
    fi

    # Convert relative path to absolute
    local abs_path
    abs_path=$(realpath "$1" 2>/dev/null)

    if [ $? -ne 0 ] || [ ! -d "$abs_path" ]; then
        echo "Error: Directory '$1' does not exist"
        return 1
    fi

    # Target variable (default: PATH)
    local var_name="${2:-PATH}"
    local var_value="${!var_name}"

    # If already present, remove from current position
    if [[ ":$var_value:" == *":$abs_path:"* ]]; then
        var_value=$(echo ":$var_value:" | sed "s|:$abs_path:|:|g" | sed 's|^:||;s|:$||')
        export "$var_name=${abs_path}${var_value:+:$var_value}"
        echo "↑ Moved to front of $var_name: $abs_path"
        return 0
    fi

    # Add to front without confirmation
    export "$var_name=${abs_path}${var_value:+:$var_value}"
    echo "✔ Added to $var_name: $abs_path"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[0;32m\]\u@\h\[\033[0m\]:\[\033[0;34m\]\w\[\033[0m\]\$ '

    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+='$(username=$(whoami); i=0; for (( j=0; j<${#username}; j++ )); do c=$((31 + (i % 6))); printf "\[\033[0;%dm\]${username:$j:1}" $c; i=$((i+1)); done)'
    PS1+='\[\033[0;32m\]@\h\[\033[0m\]:\[\033[0;34m\]\w\[\033[0m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
