แพ็กเกจ Full-Chip Implementation สำหรับ VeeR EH1 

[ดาวน์โหลด ](VeeR-EH1-IHP-SG13G2-LibreLane3-ready.tar.gz)

ภายในประกอบด้วย:

* คู่มือภาษาไทยแบบ step-by-step
* VeeR EH1 RTL จาก revision ที่ตรึงไว้
* `config.yaml` สำหรับ LibreLane 3.x `Chip` flow
* `chip_top.sv` พร้อม IHP SG13G2 IO/power pads
* `veer_core_harness.sv` สำหรับ physical-design baseline
* AHB-Lite ASIC configuration
* SDC ที่ 50 MHz พร้อม input/output delay และ clock uncertainty
* pad-ring configuration และ PDN core ring
* bondpad LEF/GDS
* preflight, Verilator lint และ run scripts
* Makefile สำหรับรัน flow และเปิด OpenROAD/KLayout
* validation report, source revisions และ checksums

คำสั่งเริ่มต้น:

```bash
tar -xzf VeeR-EH1-IHP-SG13G2-LibreLane3-ready.tar.gz
cd veer-eh1-ihp-fullchip

make preflight
make lint

make run \
  PDK_ROOT="$HOME/.ciel" \
  PDK=ihp-sg13g2
```

ผลตรวจที่ดำเนินการแล้ว:

```text
PREFLIGHT OK: 47 configured HDL files;
AHB ASIC profile;
pad/clock invariants present
```

SHA-256 ของแพ็กเกจ:

```text
8de3b7f70013355702fae7c8515e7eee66230597218f21543d4b50bc97bf4bc8
```
