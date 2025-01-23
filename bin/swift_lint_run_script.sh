export PATH="$PATH:/opt/homebrew/bin"

if which swiftlint >/dev/null; then
    echo "SWIFT LINTING"
  swiftlint
else
  echo "Warning: SwiftLint not installed, run 'brew bundle'"
fi
