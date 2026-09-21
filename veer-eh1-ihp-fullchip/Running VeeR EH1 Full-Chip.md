ชุดคำสั่งรัน VeeR EH1 Full-Chip สำหรับ Ubuntu 24.04/WSL2, LibreLane 3.x และ IHP SG13G2

## 1. แตกไฟล์และเข้าสู่โครงการ

```bash
mkdir -p ~/labs/Cores-VeeR-EH1
cd ~/labs/Cores-VeeR-EH1

tar -xzf ~/Downloads/VeeR-EH1-IHP-SG13G2-LibreLane3-ready.tar.gz
cd veer-eh1-ihp-fullchip
```

ตรวจโครงสร้าง:

```bash
find . -maxdepth 2 -type f | sort
```

ไฟล์สำคัญที่ควรพบ:

```text
Makefile
README_TH.md
librelane/config.yaml
librelane/chip_top.sdc
librelane/pdn_cfg.tcl
rtl/chip_top.sv
rtl/veer_core_harness.sv
config/veer_asic/common_defines.vh
config/veer_asic/veer_config.sv
```

## 2. เข้า LibreLane Nix environment

หากใช้ `flake.nix` ที่มากับโครงการ:

```bash
nix develop
```

หรือ:

```bash
nix-shell
```

ตรวจเครื่องมือ:

```bash
librelane --version
yosys -V
verilator --version
openroad -version
klayout -v
```

ควรใช้ LibreLane 3.x เช่น:

```text
LibreLane 3.0.9
```

## 3. กำหนด PDK

กรณี PDK อยู่ที่ `~/.ciel/ihp-sg13g2`:

```bash
export PDK=ihp-sg13g2
export PDK_ROOT="$HOME/.ciel"
```

ตรวจ:

```bash
test -d "$PDK_ROOT/$PDK" \
  && echo "PDK found: $PDK_ROOT/$PDK" \
  || echo "ERROR: PDK not found"
```

ตรวจ standard-cell, IO และ SRAM libraries:

```bash
find "$PDK_ROOT/$PDK" \
  -maxdepth 5 \
  \( -path '*sg13g2_stdcell*' \
  -o -path '*sg13g2_io*' \
  -o -path '*sg13g2_sram*' \) \
  | head -50
```

หากโครงสร้าง Ciel ของอาจารย์เป็น:

```text
$HOME/.ciel/ciel/ihp-sg13g2/versions/...
```

อาจต้องใช้:

```bash
export PDK_ROOT="$HOME/.ciel"
```

แล้วปล่อยให้ Ciel/LibreLane resolve version เอง ไม่ควรกำหนด path ไปยัง `versions/<hash>` โดยตรง เว้นแต่ทำ manual PDK flow

## 4. ตรวจ generated VeeR configuration

ตรวจว่าเลือก AHB-Lite:

```bash
grep -n 'RV_BUILD_AHB_LITE' \
  config/veer_asic/common_defines.vh
```

ตรวจว่า baseline ปิด memory blocks:

```bash
grep -nE \
  'RV_(DCCM|ICCM|ICACHE)_ENABLE' \
  config/veer_asic/common_defines.vh
```

ค่าที่คาดหวัง:

```text
RV_BUILD_AHB_LITE 1
RV_DCCM_ENABLE 0
RV_ICCM_ENABLE 0
RV_ICACHE_ENABLE 0
```

ตรวจ Slang compilation bridge:

```bash
cat config/veer_asic/veer_config.sv

grep -nE \
  'veer_config.sv|SLANG_ARGUMENTS|single-unit' \
  librelane/config.yaml
```

ค่าที่ต้องมี:

```systemverilog
`include "common_defines.vh"
```

และ:

```yaml
SLANG_ARGUMENTS: [--keep-hierarchy, --single-unit]
```

## 5. รัน preflight

```bash
make preflight
```

ผลที่คาดหวัง:

```text
PREFLIGHT OK: 47 configured HDL files;
AHB ASIC profile;
pad/clock invariants present
```

หากไม่ผ่าน ให้หยุดแก้ preflight ก่อน ไม่ควรเริ่ม full flow

## 6. รัน RTL lint

```bash
make lint
```

บันทึกผล:

```bash
mkdir -p logs
make lint 2>&1 | tee logs/01_verilator_lint.log
```

ตรวจ error:

```bash
grep -nE \
  '%Error|Error:|MODMISSING|UNSUPPORTED|syntax error' \
  logs/01_verilator_lint.log
```

ตรวจ warning:

```bash
grep -n '%Warning' \
  logs/01_verilator_lint.log \
  | sed -n '1,100p'
```

Warning จำนวนมากจาก upstream VeeR อาจยอมรับได้ในช่วงแรก แต่ต้องไม่มี fatal error, missing module หรือ syntax error

## 7. ตรวจค่า full-chip configuration

```bash
grep -nE \
  'DESIGN_NAME|CLOCK_PORT|CLOCK_NET|CLOCK_PERIOD|DIE_AREA|CORE_AREA|PL_TARGET_DENSITY|VDD_NETS|GND_NETS' \
  librelane/config.yaml
```

Baseline ปัจจุบัน:

```yaml
DESIGN_NAME: chip_top
CLOCK_PORT: clk_PAD
CLOCK_NET: clk_pad/p2c
CLOCK_PERIOD: 20.0

DIE_AREA: [0, 0, 3000, 3000]
CORE_AREA: [365, 365, 2635, 2635]
PL_TARGET_DENSITY_PCT: 42

VDD_NETS: [VDD]
GND_NETS: [VSS]
```

Clock period 20 ns เท่ากับ:

```text
50 MHz
```

## 8. รัน Full-Chip Flow รอบแรกโดยข้าม DRC

แนะนำให้รันรอบ bring-up ก่อน:

```bash
make run-nodrc \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT" \
  2>&1 | tee logs/02_fullchip_nodrc.log
```

คำสั่ง LibreLane โดยตรง:

```bash
librelane \
  --pdk ihp-sg13g2 \
  --pdk-root "$HOME/.ciel" \
  --flow Chip \
  librelane/config.yaml \
  --save-views-to final \
  --skip KLayout.DRC \
  --skip Magic.DRC
```

หมายเหตุ: รอบนี้ยังคงรัน synthesis, floorplan, pad ring, placement, CTS, routing และขั้นตรวจอื่น ๆ เพียงข้าม DRC สองตัวเพื่อประหยัดเวลา bring-up

## 9. ตรวจว่า Slang/Yosys ผ่านแล้ว

ตรวจ error เดิม:

```bash
grep -nE \
  'unknown macro|unknown compiler directive|unknown module|Compilation failed' \
  logs/02_fullchip_nodrc.log
```

หากแก้ถูกต้อง คำสั่งนี้ไม่ควรแสดง:

```text
RV_LSU_NUM_NBLOAD_WIDTH
RV_BTB_ADDR_HI
RV_BHT_GHR_RANGE
TEC_RV_ICG
unknown module 'clkhdr'
```

ตรวจว่า JSON Header ผ่าน:

```bash
grep -nE \
  'Generate JSON Header|Yosys.JsonHeader|Chip - Stage' \
  logs/02_fullchip_nodrc.log \
  | head -30
```

## 10. หา run directory ล่าสุด

```bash
export RUN_DIR="$(
  find librelane/runs \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -name 'RUN_*' \
    | sort \
    | tail -1
)"

echo "$RUN_DIR"
```

ตรวจ stage directories:

```bash
find "$RUN_DIR" \
  -mindepth 1 \
  -maxdepth 1 \
  -type d \
  | sort
```

## 11. ตรวจ error และ warning ทั้ง run

```bash
grep -RniE \
  '(^|[^A-Za-z])(ERROR|FATAL)([^A-Za-z]|$)' \
  "$RUN_DIR" \
  --include='*.log' \
  | tee logs/03_errors.txt
```

ตรวจ warning:

```bash
grep -Rni 'WARNING' \
  "$RUN_DIR" \
  --include='*.log' \
  | tee logs/04_warnings.txt
```

ค้นหาปัญหาสำคัญ:

```bash
grep -RniE \
  'DisconnectedPins|PAD-[0-9]+|RSZ-[0-9]+|GRT-[0-9]+|CTS-[0-9]+|unconstrained|violation' \
  "$RUN_DIR" \
  --include='*.log' \
  | tee logs/05_critical_checks.txt
```

## 12. ตรวจผล synthesis

ค้นหา synthesis report:

```bash
find "$RUN_DIR" \
  -type f \
  \( -iname '*stat*' \
  -o -iname '*synth*.log' \
  -o -iname '*metrics*.csv' \
  -o -iname '*metrics*.json' \) \
  | sort
```

ตรวจ unresolved modules:

```bash
grep -RniE \
  'unknown module|unresolved|blackbox|module.*not found' \
  "$RUN_DIR" \
  --include='*.log'
```

ตรวจ latch:

```bash
grep -RniE \
  'inferred latch|latch inferred' \
  "$RUN_DIR" \
  --include='*.log'
```

ตรวจจำนวน cell:

```bash
grep -RniE \
  'Number of cells|Chip area|cell count|Design area' \
  "$RUN_DIR" \
  --include='*.log' \
  | tail -30
```

## 13. ตรวจ pad ring

```bash
grep -RniE \
  'PadRing|PAD-|pad instance|block terminal' \
  "$RUN_DIR" \
  --include='*.log'
```

ต้องไม่มี:

```text
PAD-0033 block terminal missing
pad instance ... not found
```

ตรวจจำนวน signal pads จาก RTL:

```bash
grep -nE \
  'sg13g2_IOPad(In|Out|IOVdd|IOVss|Vdd|Vss)' \
  rtl/chip_top.sv
```

## 14. ตรวจ PDN

```bash
grep -RniE \
  'PDN|VDD|VSS|global connection|add_global_connections' \
  "$RUN_DIR" \
  --include='*.log' \
  | tail -100
```

ต้องไม่มี:

```text
add_global_connections failed
net VDD not found
net VSS not found
```

ค้นหา PDN output:

```bash
find "$RUN_DIR" \
  -type f \
  \( -iname '*pdn*.def' \
  -o -iname '*pdn*.odb' \
  -o -iname '*pdn*.log' \) \
  | sort
```

## 15. ตรวจ placement และ utilization

```bash
grep -RniE \
  'utilization|density|Design area|Core area|overflow|congestion' \
  "$RUN_DIR" \
  --include='*.log' \
  | tail -100
```

หาก density สูงหรือ placement ล้ม ให้ลด:

```yaml
PL_TARGET_DENSITY_PCT: 35
```

หรือเพิ่มพื้นที่:

```yaml
DIE_AREA: [0, 0, 3400, 3400]
CORE_AREA: [365, 365, 3035, 3035]
```

แก้ทีละตัวแล้วสร้าง run ใหม่

## 16. ตรวจ CTS

```bash
grep -RniE \
  'CTS-|clock tree|clock skew|insertion delay|buffered clock' \
  "$RUN_DIR" \
  --include='*.log' \
  | tail -100
```

ตรวจว่า clock net ถูกต้อง:

```bash
grep -nE \
  'CLOCK_PORT|CLOCK_NET|CLOCK_PERIOD' \
  librelane/config.yaml
```

ต้องเป็น:

```text
CLOCK_PORT: clk_PAD
CLOCK_NET: clk_pad/p2c
CLOCK_PERIOD: 20.0
```

## 17. ตรวจ routing

```bash
grep -RniE \
  'GRT-|DRT-|routing violations|overflow|unrouted|congestion' \
  "$RUN_DIR" \
  --include='*.log' \
  | tail -150
```

ค้นหา routed DEF/GDS:

```bash
find "$RUN_DIR" \
  -type f \
  \( -name '*.def' -o -name '*.gds' \) \
  | sort \
  | tail -30
```

## 18. ตรวจ setup/hold timing

ค้นหา timing reports:

```bash
find "$RUN_DIR" \
  -type f \
  \( -iname '*timing*' \
  -o -iname '*setup*' \
  -o -iname '*hold*' \
  -o -iname '*wns*' \
  -o -iname '*tns*' \) \
  | sort
```

สรุป WNS/TNS:

```bash
grep -RniE \
  'WNS|TNS|worst slack|setup.*slack|hold.*slack' \
  "$RUN_DIR" \
  --include='*.log' \
  --include='*.rpt' \
  | tail -100
```

เป้าหมาย:

```text
Setup WNS >= 0
Setup TNS  = 0
Hold WNS  >= 0
Hold TNS   = 0
```

ตรวจ unconstrained paths:

```bash
grep -RniE \
  'unconstrained|no clock|not constrained' \
  "$RUN_DIR" \
  --include='*.log' \
  --include='*.rpt'
```

## 19. เปิดผลใน OpenROAD

```bash
make openroad \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT"
```

หรือ:

```bash
librelane \
  --pdk ihp-sg13g2 \
  --pdk-root "$PDK_ROOT" \
  --last-run \
  --flow OpenInOpenROAD \
  librelane/config.yaml
```

ใน OpenROAD ให้ตรวจ:

* pad-ring orientation
* standard-cell placement
* clock tree
* high-fanout nets
* routing congestion
* PDN continuity
* unplaced/unrouted instances

## 20. เปิดผลใน KLayout

```bash
make klayout \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT"
```

หรือ:

```bash
librelane \
  --pdk ihp-sg13g2 \
  --pdk-root "$PDK_ROOT" \
  --last-run \
  --flow OpenInKLayout \
  librelane/config.yaml
```

Warning ว่า `CORE_AREA`, `FP_SIZING` หรือ `GRT_ALLOW_CONGESTION` ไม่ได้ใช้ใน `OpenInKLayout` สามารถละได้ เพราะเป็น viewer flow

## 21. รัน Full Sign-off พร้อม DRC

เมื่อรอบ `run-nodrc` ผ่านแล้ว:

```bash
make run \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT" \
  2>&1 | tee logs/06_fullchip_signoff.log
```

หรือ:

```bash
librelane \
  --pdk ihp-sg13g2 \
  --pdk-root "$PDK_ROOT" \
  --flow Chip \
  librelane/config.yaml \
  --save-views-to final
```

รอบนี้ไม่ข้าม:

* KLayout DRC
* Magic DRC
* Antenna
* LVS
* Disconnected-pins checks
* Timing checks

## 22. ตรวจ final views

```bash
find final -type f | sort
```

ควรมีอย่างน้อย:

```text
GDS
DEF
LEF
gate-level netlist
SDF
SDC
SPEF
OpenROAD database
reports/metrics
```

ตรวจ GDS:

```bash
find final -type f -name '*.gds' -exec ls -lh {} \;
```

ตรวจ netlist:

```bash
find final -type f \
  \( -name '*.v' -o -name '*.sv' \) \
  -exec ls -lh {} \;
```

## 23. สร้างสรุป run

```bash
{
  echo "Date: $(date -Iseconds)"
  echo "LibreLane: $(librelane --version 2>&1 | head -1)"
  echo "Yosys: $(yosys -V)"
  echo "Verilator: $(verilator --version)"
  echo "PDK: $PDK"
  echo "PDK_ROOT: $PDK_ROOT"
  echo "Run: $RUN_DIR"
  sha256sum \
    librelane/config.yaml \
    librelane/chip_top.sdc \
    config/veer_asic/common_defines.vh \
    config/veer_asic/veer_config.sv
} | tee logs/07_run_manifest.txt
```

## ชุดคำสั่งแบบรวบรัด

หลังจาก environment และ PDK พร้อมแล้ว สามารถรันต่อเนื่องดังนี้:

```bash
cd ~/labs/Cores-VeeR-EH1/veer-eh1-ihp-fullchip

nix develop

export PDK=ihp-sg13g2
export PDK_ROOT="$HOME/.ciel"

mkdir -p logs

make preflight

make lint \
  2>&1 | tee logs/01_verilator_lint.log

make run-nodrc \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT" \
  2>&1 | tee logs/02_fullchip_nodrc.log

make openroad \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT"

make klayout \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT"

make run \
  PDK="$PDK" \
  PDK_ROOT="$PDK_ROOT" \
  2>&1 | tee logs/06_fullchip_signoff.log
```

ลำดับที่แนะนำคือ `preflight → lint → run-nodrc → inspect → run full sign-off` เพื่อไม่เสียเวลารัน DRC ก่อน synthesis, pad ring, PDN, CTS และ routing ผ่านครบครับ
