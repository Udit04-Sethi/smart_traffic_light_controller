# Smart Traffic Light Controller (Verilog HDL)

![Verilog](https://img.shields.io/badge/Language-Verilog_2001-blue.svg)
![Tool](https://img.shields.io/badge/Toolchain-Vivado_Simulator-orange.svg)
![Target](https://img.shields.io/badge/Target-FPGA%2FASIC-brightgreen.svg)

A fully synthesizable **Smart Traffic Light Controller** core designed in Verilog HDL. The system utilizes a multi-state **Finite State Machine (FSM)** combined with dynamic sensor inputs to optimize traffic flow across North-South (NS) and East-West (EW) intersections.

---

## Key Highlights & Architectural Features

- **Dynamic Traffic Priority Engine:** Evaluates vehicle density sensor inputs to extend GREEN signal duration for busy lanes while minimizing idle wait times on low-density lanes.
- **Pedestrian Safety & Emergency Override:** Dedicated hardware inputs to safely interrupt normal cyclic transitions for pedestrian crossings or priority emergency vehicles.
- **Synchronous FSM State Transitions:** Implements clean, glitch-free state transitions driven by a centralized system clock and timed counter logic.
- **Clean Modular Design:** Separates the core control FSM and timing logic for flexible synthesis across Xilinx/Altera FPGAs.

---

## 📁 Repository Structure

```text
smart_traffic_light_controller/
├── rtl/
│   └── traffic_light_controller.v  # Synthesizable Traffic Controller FSM
├── tb/
│   └── tb.v                        # Behavioral Testbench & Stimulus
└── README.md                       # Documentation & Project Overview
