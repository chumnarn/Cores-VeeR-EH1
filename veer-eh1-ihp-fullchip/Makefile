PROJECT_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PDK ?= ihp-sg13g2
PDK_ROOT ?= $(HOME)/.ciel
CONFIG := librelane/config.yaml

.DEFAULT_GOAL := help
.PHONY: help preflight lint run run-nodrc openroad klayout clean

help:
	@echo "make preflight   ตรวจไฟล์และ configuration"
	@echo "make lint        รัน Verilator lint (ถ้ามี Verilator)"
	@echo "make run         รัน LibreLane 3.x Chip flow"
	@echo "make run-nodrc   รันโดยข้าม DRC ชั่วคราว"
	@echo "make openroad    เปิด run ล่าสุดใน OpenROAD"
	@echo "make klayout     เปิด run ล่าสุดใน KLayout"

preflight:
	python3 scripts/preflight.py

lint: preflight
	bash scripts/lint.sh

run: preflight
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --flow Chip $(CONFIG) --save-views-to final

run-nodrc: preflight
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --flow Chip $(CONFIG) --save-views-to final --skip KLayout.DRC --skip Magic.DRC

openroad:
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --last-run --flow OpenInOpenROAD $(CONFIG)

klayout:
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --last-run --flow OpenInKLayout $(CONFIG)

clean:
	@echo "Refusing automatic deletion. Remove librelane/runs manually after archiving results."
