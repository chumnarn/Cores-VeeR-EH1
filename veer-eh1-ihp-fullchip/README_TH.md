# คู่มือ Full-Chip Implementation: VeeR EH1 + LibreLane 3.x + IHP SG13G2

แพ็กเกจนี้เป็น baseline ที่ทำซ้ำได้สำหรับนำ **VeeR EH1 RISC-V Core** ผ่าน RTL-to-GDSII แบบ full-chip โดยใช้ LibreLane 3.x, flow `Chip` และ PDK `ihp-sg13g2` โครงสร้าง pad ring และ bondpad อ้างอิงจาก template ทางการของ IHP

> ขอบเขตสำคัญ: นี่คือ **core physical-design harness** ไม่ใช่ SoC สำหรับบูตซอฟต์แวร์ทั่วไป พอร์ต AHB instruction ตอบกลับคำสั่ง NOP อย่างต่อเนื่อง ส่วน LSU/debug bus ตอบกลับศูนย์ เพื่อให้ core ทั้งก้อนสามารถ elaborate, synthesize, place และ route ได้โดยไม่ผูกกับ SRAM macro เฉพาะเทคโนโลยี เหมาะสำหรับหา PPA baseline และพัฒนา flow ก่อนต่อยอดเป็น SoC

## 1. สถาปัตยกรรม baseline

ลำดับชั้นการออกแบบ:

1. `chip_top` — IHP IO pads, power pads และ pad ring
2. `veer_core_harness` — กำหนด reset vector, interrupt/JTAG และ AHB termination
3. `veer_wrapper` — VeeR EH1 RTL เดิม

การแม็ปขา:

| Pad | ทิศทาง | หน้าที่ |
|---|---:|---|
| `clk_PAD` | input | core clock, target 50 MHz |
| `rst_n_PAD` | input | asynchronous active-low reset |
| `input_PAD[0]` | input | JTAG TCK |
| `input_PAD[1]` | input | JTAG TMS |
| `input_PAD[2]` | input | JTAG TDI |
| `input_PAD[3]` | input | JTAG TRSTn |
| `input_PAD[7:4]` | input | external interrupt 3:0 |
| `output_PAD[0]` | output | JTAG TDO |
| `output_PAD[1]` | output | trace address bit 2 |
| `output_PAD[2]` | output | trace address bit 3 |
| `output_PAD[3]` | output | instruction valid |
| `output_PAD[4]` | output | interrupt indication |
| `output_PAD[5]` | output | exception indication |
| `output_PAD[6]` | output | CPU halted |
| `output_PAD[7]` | output | debug mode |

Configuration ถูกตรึงเป็น `default_pd + AHB-Lite` และปิด DCCM, ICCM, I-cache เพื่อไม่ให้ inferred RAM ขนาดใหญ่ครอบงำพื้นที่/เวลาใน baseline แรก Clock-gating สำหรับ ASIC ยังคงทำงาน (`fpga_optimize=0` จาก `default_pd`)

## 2. โครงสร้างไฟล์

```text
veer-eh1-ihp-fullchip/
├── config/veer_asic/       generated VeeR defines
├── ip/bondpad_70x70_novias bondpad LEF/GDS/model
├── librelane/
│   ├── config.yaml         LibreLane schema v3, Chip flow
│   ├── chip_top.sdc        timing constraints
│   └── pdn_cfg.tcl         core grid/ring
├── rtl/
│   ├── chip_top.sv
│   ├── veer_core_harness.sv
│   └── veer/               upstream VeeR RTL
├── scripts/                preflight, lint, config regeneration
├── Makefile
└── SOURCE_REVISIONS.md
```

## 3. สิ่งที่ต้องติดตั้ง

- Ubuntu 22.04/24.04 หรือ WSL2
- Nix environment ของ LibreLane หรือ LibreLane 3.x ที่เรียกด้วยคำสั่ง `librelane`
- Ciel และ IHP Open PDK (`ihp-sg13g2`)
- Verilator สำหรับ lint (แนะนำ แม้ไม่จำเป็นต่อ `preflight`)
- RAM อย่างน้อย 16 GB; แนะนำ 32 GB และพื้นที่ว่าง 30–50 GB

ตรวจเวอร์ชัน:

```bash
librelane --version
ciel --version
verilator --version
```

คู่มือนี้ออกแบบและตรวจ configuration กับแนวทาง LibreLane 3.x ห้ามใช้ option เก่า `--interactive` หรือ `--override`

## 4. เตรียม PDK

หากมี PDK อยู่แล้ว เช่น `~/.ciel/ihp-sg13g2` ให้ใช้โดยตรง:

```bash
export PDK_ROOT="$HOME/.ciel"
export PDK=ihp-sg13g2
test -d "$PDK_ROOT/$PDK"
```

ตรวจว่ามี standard cells และ IO library:

```bash
find "$PDK_ROOT/$PDK" -path '*sg13g2_stdcell*' -o -path '*sg13g2_io*' | head
```

## 5. Preflight

```bash
cd veer-eh1-ihp-fullchip
make preflight
```

ผลที่คาดหวัง:

```text
PREFLIGHT OK: ... configured HDL files; AHB ASIC profile; pad/clock invariants present
```

Preflight ตรวจว่า file list ใน `config.yaml` มีไฟล์จริง, top/clock ตรงกัน, generated defines เป็น AHB และปิด memory ทั้งสามชนิด รวมถึงตรวจชื่อ pad หลักที่ต้องตรงกับรายการ `PAD_*`

## 6. RTL lint

```bash
make lint
```

คำเตือนจาก upstream บางส่วนอาจยังมีได้ แต่ต้องไม่มี syntax error, missing module หรือ width error ที่เป็น fatal หากต้อง debug ให้พิมพ์คำสั่ง Verilator จาก `scripts/lint.sh` แล้วเพิ่ม `--debug` เฉพาะรอบวิเคราะห์

จุดสำคัญของ file order คือ `veer_types.sv` ต้องมาก่อนโมดูลที่ import package และ `common_defines.vh`/include directories ต้องมาจาก snapshot เดียวกัน ห้ามผสม generated files ต่าง configuration

## 7. ตรวจ LibreLane configuration

ค่าหลักใน `librelane/config.yaml`:

- `meta.version: 3`
- `flow: Chip`
- `DESIGN_NAME: chip_top`
- `USE_SLANG: true` สำหรับ SystemVerilog ของ VeeR
- `CLOCK_PORT: clk_PAD`, `CLOCK_NET: clk_pad/p2c`
- `CLOCK_PERIOD: 20.0 ns` หรือ 50 MHz
- `DIE_AREA: 3000 × 3000 µm`
- `CORE_AREA: (365,365)–(2635,2635) µm`
- placement density 42%

พื้นที่เริ่มต้นมี margin สูงโดยตั้งใจ เนื่องจากจำนวนเซลล์หลัง synthesis ขึ้นกับ revision ของ Yosys/Slang และการ map clock-gating หาก utilization ต่ำมากค่อยลด die ในรอบ characterization; หาก global routing congestion สูงให้เพิ่ม core หรือปรับ density ก่อนใช้การผ่อน DRC

## 8. รัน RTL-to-GDSII

รันเต็ม:

```bash
make run PDK_ROOT="$HOME/.ciel" PDK=ihp-sg13g2
```

คำสั่งเทียบเท่า:

```bash
librelane --pdk ihp-sg13g2 \
  --pdk-root "$HOME/.ciel" \
  --flow Chip librelane/config.yaml \
  --save-views-to final
```

สำหรับ bring-up ที่ต้องการข้าม DRC ชั่วคราว:

```bash
make run-nodrc PDK_ROOT="$HOME/.ciel"
```

การข้าม DRC ไม่ใช่ sign-off และห้ามใช้ GDS ที่ได้เป็น tapeout candidate

## 9. ตรวจผลราย stage

### 9.1 Synthesis

ตรวจ log/metrics ต่อไปนี้:

- ไม่มี latch ที่เกิดโดยไม่ตั้งใจ
- ไม่มี unresolved module
- จำนวน cell และพื้นที่ไม่เป็นศูนย์
- clock-gating cells ถูก map ตาม library/flow
- ไม่มี inferred memory ขนาดใหญ่จาก DCCM/ICCM/I-cache

### 9.2 Floorplan และ pad ring

ตรวจว่า pad ทุกตัวใน `PAD_SOUTH/EAST/NORTH/WEST` ถูกพบ และไม่มี `PAD-0033 block terminal missing` ชื่อ instance ที่มี generate index ต้อง escape เป็น `inputs\\[n\\].input_pad` ใน YAML

### 9.3 PDN

ตรวจ special nets `VDD/VSS`, core ring, stripe continuity และการเชื่อมถึง pad อย่าปิด `Checker.DisconnectedPins` เพื่อซ่อน power connectivity error

### 9.4 Placement/CTS

เป้าหมายเบื้องต้น:

- placement utilization ต่ำกว่า 60–65%
- ไม่มี severe overlap
- CTS สร้าง clock tree จาก `clk_pad/p2c`
- insertion delay/skew สมเหตุผลและไม่มี unconstrained sequential endpoints

### 9.5 Routing/sign-off

ตรวจ antenna, Magic/KLayout DRC, LVS, max transition/capacitance/fanout และ setup/hold ในทุกมุมที่ PDK/flow กำหนด การผ่าน routing ไม่เท่ากับ sign-off

## 10. Timing constraints

SDC ใช้ clock 20 ns, uncertainty 0.25 ns, input delay 2 ns, output delay 4 ns และ output load 0.033442 pF Reset และ JTAG TCK/TRSTn ถูกจัดเป็น asynchronous/control paths ใน baseline

หลัง CTS ให้ตรวจอย่างน้อย:

```text
report_checks -path_delay max -group_count 20
report_checks -path_delay min -group_count 20
report_clock_skew
report_worst_slack -max
report_worst_slack -min
```

ถ้า WNS ติดลบ ให้จำแนก logic-dominated, net-dominated, clock-dominated หรือ constraint error ก่อนแก้ หลีกเลี่ยงเพิ่ม buffer/upsizing จำนวนมากในครั้งเดียว

## 11. เปิดผลใน GUI

```bash
make openroad PDK_ROOT="$HOME/.ciel"
make klayout  PDK_ROOT="$HOME/.ciel"
```

warning ว่า key เช่น `CORE_AREA` หรือ `FP_SIZING` unused ใน `OpenInKLayout` เป็นเรื่องปกติ เพราะ flow สำหรับเปิด viewer ไม่ได้ใช้ key ของ implementation

## 12. Debugging ที่พบบ่อย

### Slang/Yosys หา package หรือ include ไม่พบ

ตรวจ file order และ `VERILOG_INCLUDE_DIRS`; อย่าชี้ไปยัง snapshot จาก working directoryอื่น รัน `make preflight` ก่อนเสมอ สำหรับ VeeR generated macros แพ็กเกจนี้ใช้ `config/veer_asic/veer_config.sv` เป็น source แรก และกำหนด `SLANG_ARGUMENTS: [--keep-hierarchy, --single-unit]` ห้ามนำ `common_defines.vh` ไปใส่เป็น source `.vh` เดี่ยว เพราะ macro จะไม่ข้าม compilation unit ใน Slang

### มี AXI port ทั้งที่ต้องการ AHB

`common_defines.vh` ไม่ใช่ snapshot ของแพ็กเกจนี้ ตรวจ `RV_BUILD_AHB_LITE` และ regenerate ด้วย `scripts/regenerate_veer_config.sh`

### Pad instance not found

ตรวจชื่อ generate hierarchy หลัง synthesis และ escape brackets ใน `PAD_*` ให้ครบ ชื่อใน YAML ต้องตรงกับ instance ใน `chip_top.sv`

### add_global_connections หา IOVDD/VDD ไม่พบ

ตรวจว่าใช้ IO Verilog model จาก PDK revision เดียวกันกับ LEF/GDS และอย่าเพิ่ม supply port ที่ไม่มีใน model ด้วยการเดา หาก model เปลี่ยน ให้ตรวจ declaration ของ `sg13g2_IOPad*` แล้วปรับ wrapper อย่างสอดคล้องทั้ง RTL, blackbox และ netlist

### DisconnectedPins

เปิดรายงานหา pin/instance จริง ห้ามปิด checker เป็นวิธีแก้ หากเป็น output ที่ตั้งใจไม่ใช้ ให้ terminate ใน RTL อย่างชัดเจน; หากเป็น power pin ให้แก้ global connection/PDN

### Routing congestion

เพิ่ม die/core area ทีละ 10–15%, ลด target density หรือสร้าง macro-based memory architecture อย่าใช้ `GRT_ALLOW_CONGESTION` เป็นหลักฐานว่าการออกแบบ route ได้

### RSZ-0060 หรือ resizer หา buffer ไม่ได้

ตรวจ max transition/fanout, cell exclusions และ available buffer/inverter ใน corner นั้น หากเกิดหลัง CTS ให้ดู clock tree และ high-fanout resets ก่อน

## 13. เปลี่ยนเป็น SRAM-macro implementation

Baseline นี้ปิด local memories เพื่อให้ flow เริ่มได้แน่นอน การทำ implementation ที่มีสมรรถนะจริงควรดำเนินเป็นรอบถัดไป:

1. เลือกขนาด DCCM/ICCM ที่หารด้วย macro 1K×32 ได้
2. สร้าง wrapper ที่ map byte-write/ECC/banking ของ VeeR ไปยัง IHP SRAM
3. เพิ่ม macro `gds/lef/vh/lib` ใน `MACROS`
4. ตรึง instance names และ locations
5. เพิ่ม `PDN_MACRO_CONNECTIONS` และ macro grid
6. รัน RTL equivalence ของ memory wrapper
7. ตรวจ macro halo/channel, congestion และ IR drop

ห้ามแทน behavioral SRAM ด้วย macro เพียงอาศัยความกว้างข้อมูลใกล้เคียง เพราะ VeeR ใช้ banking, ECC/parity และ read/write semantics ที่ต้องตรงครบ

## 14. เปลี่ยนเป็น SoC ที่บูตโปรแกรมได้

core-only harness ไม่ควรนำไปใช้เป็นผลิตภัณฑ์ ขั้นต่อยอดขั้นต่ำคือ:

1. AHB interconnect/arbitration สำหรับ IFU, LSU และ debug system bus
2. boot ROM และ SRAM
3. UART/GPIO/timer และ address decoder
4. firmware/linker script ที่ตรง memory map
5. reset synchronizer และ clock/reset strategy
6. simulation ที่ตรวจ signature หรือ UART output
7. CDC/RDC, formal checks และ gate-level simulation

หลัง SoC ผ่าน functional verification จึงเปลี่ยน `veer_core_harness` เป็น SoC wrapper โดยคง `chip_top`, pad strategy และ flow configuration เป็นฐาน

## 15. Acceptance criteria

Baseline ถือว่าผ่านเมื่อ:

- `make preflight` ผ่าน
- RTL lint/elaboration ไม่มี fatal error
- synthesis ไม่มี unresolved/blackbox logic ที่ไม่ตั้งใจ
- pad ring, floorplan และ PDN สร้างได้ครบ
- placement, CTS และ routing จบโดยไม่มี fatal error
- setup/hold, electrical checks, antenna, DRC และ LVS ผ่านตาม policy ของโครงการ
- ไม่มี critical disconnected pin
- final GDS, DEF, netlist, SPEF/SDF, reports และ metrics ถูก archive พร้อม revision ของ RTL/PDK/LibreLane

## 16. Reproducibility record

บันทึกทุก run:

```bash
git rev-parse HEAD 2>/dev/null || true
librelane --version
ciel --version
sha256sum librelane/config.yaml config/veer_asic/common_defines.vh
```

revision ต้นทางที่ใช้สร้างแพ็กเกจอยู่ใน `SOURCE_REVISIONS.md` การเปลี่ยน upstream RTL หรือ PDK ต้องเริ่ม run tag ใหม่และเปรียบเทียบ cell count, WNS/TNS, area, congestion, DRC และ LVS กับ baseline เดิม
