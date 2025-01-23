export PATH="$PATH:/opt/homebrew/bin"

if which sentry-cli >/dev/null; then
export SENTRY_ORG=jenix-technologies
export SENTRY_PROJECT=rolld
export SENTRY_AUTH_TOKEN=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
ERROR=$(sentry-cli debug-files upload --include-sources "$DWARF_DSYM_FOLDER_PATH" 2>&1 >/dev/null)
if [ ! $? -eq 0 ]; then
echo "warning: sentry-cli - $ERROR"
fi
else
echo "warning: sentry-cli not installed, download from https://github.com/getsentry/sentry-cli/releases"
fi
