#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/Cores-VeeR-EH1" >&2
  exit 2
fi
src="$(cd "$1" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"
export RV_ROOT="$src"
perl "$RV_ROOT/configs/veer.config" -target=default_pd -ahb_lite \
  -set=dccm_enable=0 -set=iccm_enable=0 -set=icache_enable=0 \
  -unset=assert_on
cp -a snapshots/default_pd/. "$OLDPWD/config/veer_asic/"
echo "Updated config/veer_asic"
