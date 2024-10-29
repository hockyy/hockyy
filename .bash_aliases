# Python virtual environment management function
venv_auto() {
    # Check if 'env' directory exists
    if [ -d "env" ]; then
        echo "📦 Virtual environment exists, activating..."
        source env/bin/activate
    else
        echo "🛠️ Creating new virtual environment..."
        python -m venv env
        source env/bin/activate
        pip install --upgrade pip
        # Check if requirements.txt exists
        if [ -f "requirements.txt" ]; then
            echo "📥 Installing requirements..."
            pip install -r requirements.txt
        fi
    fi
}

# Add an alias for easier use
alias v='venv_auto'

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

alias curb="git rev-parse --symbolic-full-name --abbrev-ref HEAD"

function topfast(){
    top -u hocky -d 0.2
}
alias py="python3"
alias python="python3"
alias timestamp="date +%s"
function search(){
    grep -n -B 2 -r "$1" .
}
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
