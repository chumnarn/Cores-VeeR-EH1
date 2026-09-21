# VeeR EH1 IHP SG13G2 Full-Chip Baseline

Ready-to-run LibreLane 3.x `Chip` flow for a pad-wrapped VeeR EH1 physical-design harness. See [README_TH.md](README_TH.md) for the complete Thai step-by-step guide.

```bash
make preflight
make lint
make run PDK_ROOT="$HOME/.ciel" PDK=ihp-sg13g2
```

The baseline terminates the AHB interfaces internally and continuously supplies RISC-V NOP instructions. It is intended for core PPA and flow bring-up, not as a software-bootable SoC.
