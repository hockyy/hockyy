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

gg() {
  (ulimit -v 4194304; ulimit -s 4194304; ./$1)
}
