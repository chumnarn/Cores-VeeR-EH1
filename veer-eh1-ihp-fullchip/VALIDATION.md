# Validation record

Validated on 2026-09-20:

- Source revisions pinned in `SOURCE_REVISIONS.md`.
- Generated VeeR configuration completed successfully (`default_pd`, AHB-Lite, memories/assertions disabled).
- `make preflight` passed with 47 configured HDL files.
- All YAML-referenced HDL/include files exist.
- Required top, clock, pad, and configuration invariants passed.
- Shell scripts passed `bash -n`; Python preflight passed byte-code compilation.
- Archive integrity and SHA-256 were checked.
- `veer_config.sv` is compiled first and includes `common_defines.vh` while
  Slang runs with `--single-unit`. This makes the generated macros visible to
  every VeeR source file during `Yosys.JsonHeader` and synthesis.

The source repository's legacy `design/flist.questa` names three adapter files that are absent from the selected revision. They are deliberately omitted from the LibreLane list because the selected AHB implementation in `veer.sv` uses the present `axi4_to_ahb.sv` and `ahb_to_axi4.sv` modules.

Limit of this build environment: Verilator, Yosys and LibreLane binaries were not installed here, so HDL elaboration and the physical flow were not executed locally. The package supplies deterministic lint/run commands; run `make lint` and `make run` inside the LibreLane environment before treating the result as tapeout-capable.
