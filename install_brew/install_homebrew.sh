#!/bin/bash

BREW_PATH="/opt/homebrew/bin/brew"
BREW_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
ZSHRC="$HOME/.zshrc"
SDKMAN_MARKER="#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!"

# Check if Homebrew is available in PATH
if command -v brew >/dev/null 2>&1; then
  echo "✅ Homebrew already available in PATH"
elif [ -x "$BREW_PATH" ]; then
  echo "🛠️ Homebrew binary found at $BREW_PATH, but not in PATH"
else
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure Homebrew shellenv is set in .zshrc
if ! grep -Fxq "$BREW_LINE" "$ZSHRC"; then
  if grep -q "$SDKMAN_MARKER" "$ZSHRC"; then
    echo "🔧 Inserting Homebrew shellenv before SDKMAN section in $ZSHRC"
    sed -i '' "/^$SDKMAN_MARKER/i\\
$BREW_LINE
" "$ZSHRC"
  else
    echo "📎 SDKMAN marker not found. Appending Homebrew shellenv to $ZSHRC"
    echo "$BREW_LINE" >> "$ZSHRC"
  fi
else
  echo "✅ Homebrew shellenv already configured in $ZSHRC"
fi

# Apply to current shell if brew is usable
if [ -x "$BREW_PATH" ]; then
  eval "$($BREW_PATH shellenv)"
elif command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

echo "✅ Setup complete. Run 'source ~/.zshrc' or restart terminal."
