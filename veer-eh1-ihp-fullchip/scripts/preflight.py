#!/usr/bin/env python3
from pathlib import Path
import re, sys

ROOT = Path(__file__).resolve().parents[1]
CFG = ROOT / "librelane/config.yaml"
text = CFG.read_text(encoding="utf-8")
paths = re.findall(r"^\s*-\s+dir::([^#\n]+\.(?:sv|v|vh))\s*$", text, re.M)
resolved = [(CFG.parent / p.strip()).resolve() for p in paths]

if "--print-verilog" in sys.argv:
    for p in resolved:
        if p.suffix in {".sv", ".v", ".vh"} and p.name not in {"chip_top.sv"}:
            print(p.relative_to(ROOT))
    raise SystemExit(0)

errors = []
for p in resolved:
    if not p.is_file():
        errors.append(f"missing: {p.relative_to(ROOT)}")

required = {
    "DESIGN_NAME": "chip_top",
    "CLOCK_PORT": "clk_PAD",
    "CLOCK_NET": "clk_pad/p2c",
    "flow": "Chip",
}
for key, value in required.items():
    if not re.search(rf"\b{re.escape(key)}\s*:\s*{re.escape(value)}\b", text):
        errors.append(f"config mismatch: {key}: {value}")

defs = (ROOT / "config/veer_asic/common_defines.vh").read_text(encoding="utf-8")
for macro in ("RV_BUILD_AHB_LITE", "RV_DCCM_ENABLE 0", "RV_ICCM_ENABLE 0", "RV_ICACHE_ENABLE 0"):
    if macro not in defs:
        errors.append(f"generated configuration lacks: {macro}")

top = (ROOT / "rtl/chip_top.sv").read_text(encoding="utf-8")
for inst in ("clk_pad", "rst_n_pad", "iovdd_pad", "iovss_pad", "vdd_pad", "vss_pad"):
    if not re.search(rf"\b{inst}\b", top):
        errors.append(f"chip_top lacks pad instance: {inst}")

if errors:
    print("PREFLIGHT FAILED")
    print("\n".join(f"- {e}" for e in errors))
    raise SystemExit(1)
print(f"PREFLIGHT OK: {len(resolved)} configured HDL files; AHB ASIC profile; pad/clock invariants present")
