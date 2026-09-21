#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v verilator >/dev/null 2>&1; then
  echo "ERROR: verilator not found. Enter the LibreLane/Nix environment first." >&2
  exit 2
fi
mapfile -t rtl < <(python3 scripts/preflight.py --print-verilog)
verilator --lint-only --timing -Wall -Wno-fatal \
  -DFUNCTIONAL \
  -Iconfig/veer_asic -Irtl/veer/include -Irtl/veer/lib -Irtl/veer/dmi \
  --top-module veer_core_harness "${rtl[@]}"
