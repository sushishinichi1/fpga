# FPGA Polyphonic Synthesizer (Verilog)

> RTLだけで実装したリアルタイム音源エンジン  
> Real-time polyphonic synthesizer implemented entirely in RTL

---

## Overview 概要

This project implements a real-time polyphonic audio synthesizer on FPGA using Verilog.  
本プロジェクトは、Verilogで設計したFPGA向けポリフォニック音源です。  
Hardware efficiency・timing accuracy・modular design を重視しています。

---

## Architecture 構成

The synthesizer is composed of independent RTL modules:

- DDS Oscillator（位相加算方式）
- Polyphonic Mixer（同時発音加算）
- ADSR Envelope Generator
- Fixed-point DSP pipeline（固定小数演算）

All modules are synchronous and parameterized.  
すべて同期設計かつ再利用可能な構成です。

---

## Specifications 仕様

Sample Rate : 48 kHz  
Voices : 8 voices 同時発音数  
Bit Width : 16-bit fixed-point  
Clock : 50 MHz

---

## Verification 検証

Simulation environment  
Verilator + C++ testbench

Tested points:

- phase increment accuracy 位相精度
- envelope timing エンベロープ時間精度
- overflow safety オーバーフロー安全性
- multi-voice stability 同時発音安定性

---

## Result 結果

Audio waveform successfully generated and verified.  
音声波形生成に成功し、すべてのテストを通過しました。

No timing violations  
No arithmetic overflow

---

## Design Highlights 強み

- Hardware-efficient DSP design
- Deterministic timing
- Scalable architecture
- Clean RTL hierarchy

---

## Repository Structure
