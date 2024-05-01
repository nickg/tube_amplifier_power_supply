#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

# ROOT
ROOT = Path(__file__).resolve().parent
VU = VUnit.from_argv()

tube_amp_power = VU.add_library("tube_amp_power")
tube_amp_power.add_source_files(ROOT / "testbenches/measurement_interface/measurement_interface_tb.vhd")

VU.main()
