#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed"
fi

BREW_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
ZSHRC="$HOME/.zshrc"
SDKMAN_MARKER="#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!"

# Add brew shellenv line if not already present
if ! grep -Fxq "$BREW_LINE" "$ZSHRC"; then
  if grep -q "$SDKMAN_MARKER" "$ZSHRC"; then
    echo "🔧 Inserting Homebrew shellenv before SDKMAN section in $ZSHRC"
    # Use temporary file because macOS sed needs '' for in-place edit
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

# Apply to current shell
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "✅ Setup complete. Run 'source ~/.zshrc' or restart terminal."
