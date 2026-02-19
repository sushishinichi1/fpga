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

## Additional Module: SPI Communication Core 追加モジュール

This repository also includes a custom-designed SPI communication core implemented in RTL.
本リポジトリには独自設計のSPI通信コアも含まれています。

---

## Features 機能

- SPI Master module
- SPI Slave module
- Mode0 operation
- 8-bit transfer
- MSB-first shifting
- Busy control logic
- Valid flag generation

---

## Verification 検証内容

The SPI modules were verified using simulation testbenches.  
SPIモジュールはシミュレーションテストベンチにより検証済み。

- byte transmission correctness
- clock synchronization
- reset recovery behavior
- master–slave integration communication

Integration test confirms successful communication.

---

## Design Notes 設計ポイント

- Fully synchronous design
- Deterministic timing behavior
- Edge-safe sampling
- Reset-safe startup sequence

---

## Debug Experience デバッグ実績

During development, an initial byte-loss issue was detected after reset.  
The root cause was timing instability immediately after reset release.  
This was resolved by inserting clock stabilization cycles before communication start.

- リセット直後に最初の1バイトが欠落する問題を確認
- 原因：リセット解除直後のタイミング不安定
- 対策：通信開始前にクロック待機を挿入し解決

---

## Engineering Value 技術的意義

This module demonstrates:

- RTL communication design capability
- verification-driven development
- timing-aware hardware implementation

## feat(spi-slave): implement verified SPI slave module with waveform validation

- correct edge sampling
- fixed valid pulse timing
- verified MSB-first transfer
- waveform confirmed in GTKWave
