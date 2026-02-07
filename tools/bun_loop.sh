#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGDIR="$ROOT/logs/bun"
mkdir -p "$LOGDIR"

TS="$(date +"%Y%m%d-%H%M%S")"
LOG="$LOGDIR/build-$TS.log"
SUMMARY="$LOGDIR/summary-$TS.txt"

(
  cd "$ROOT"
  # Clear stale bun lock if no brew process is running (avoid clobbering active brew)
  if ! pgrep -f "[b]rew" >/dev/null 2>&1; then
    rm -f /opt/homebrew/var/homebrew/locks/bun.formula.lock || true
  fi

  # Ensure we actually rebuild each iteration (avoid "already installed" short-circuit)
  brew uninstall --formula bun >/dev/null 2>&1 || true
  brew uninstall --formula --zap bun >/dev/null 2>&1 || true
  HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source ./Formula/b/bun.rb -v
) 2>&1 | tee "$LOG"
STATUS=${PIPESTATUS[0]}

# Guardrail: detect network/download activity in logs (execution, not variable definitions)
NETWORK_RE='Downloading zig|DownloadZig\.cmake|GitClone\.cmake|register_repository\(|file\(DOWNLOAD|curl |wget |git clone|git fetch|FetchContent|ExternalProject_Add|bun install( |$)|WEBKIT.*download|Fetching|Cloning repository'

if rg -n "$NETWORK_RE" "$LOG" >/dev/null 2>&1; then
  {
    echo "NETWORK_ACTIVITY_DETECTED"
    echo "PATTERN: $NETWORK_RE"
    rg -n "$NETWORK_RE" "$LOG" | head -n 80
  } > "$SUMMARY"
  exit 2
fi

if [[ $STATUS -eq 0 ]]; then
  echo "SUCCESS" > "$SUMMARY"
  exit 0
fi

# Extract first fatal error block (up to 30 lines) to summary
awk '
  /^FAILED: / { if (!p) { p=1; c=0; print; next } }
  /^ninja: build stopped/ { if (!p) { p=1; c=0; print } }
  /^Error: / { if (!p) { p=1; c=0; print; next } }
  /error: / { if (!p) { p=1; c=0; print; next } }
  { if (p && c < 30) { print; c++ } if (p && c >= 30) { exit } }
' "$LOG" > "$SUMMARY" || true

exit 1
