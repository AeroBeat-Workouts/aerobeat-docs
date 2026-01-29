# Hybrid Gastown Orchestration Plan

## Primary Goal

Create a hybrid local & cloud solution for running Gastown, the parallel agent orchestration model used in the AeroBeat rhythm workout platform for code generation.

## Local Hardware Overview

*   **Operating System**: Zorin OS 18 Pro

*   **Firmware Version**: 1.20.0

*   **Kernel Version**: Linux 6.14.0-37 Generic

*   **Hardware**: Alienware Aurora R13

*   **Processor**: 12th Gen Intel i7-12700KF x 20

*   **Memory**: 128GB

*   **Disk Capacity**: 3.1TB

*   **Graphics**: NVIDIA GeForce RTX 3080

## High End Strategy

• Use Gemini 3 Pro via the Google Studio Api for high-level architectural planning and epic decomposition with the Gastown Mayor working alongside rig expert crew members to validate plans.

• Use the Mayor to sling convoys of beads (git backed json tasks) to Polecats and the Refinery agents, which run on local hardware to save on costs.

*   **Mayors**: gemini-3-pro-preview (Cloud)

*   **Polecats**: Qwen2.5-Coder-32B (Local)

*   **Refineries**: DeepSeek-R (Local)

## 1. Verify Plans

Send these plans to high end thinking models to verify the plans and improve on them.

- [ ] **Gemini Pro**

## 2. Infrastructure Preparation (Local)

- [ ] **OS Configuration**: Optimize Zorin OS 18 Pro and ensure NVIDIA drivers for the RTX 3080 are current.

- [ ] **Backend Setup**: Install Ollama or vLLM to provide OpenAI-compatible local endpoints.

- [ ] **Memory Management**: Configure a 32GB swap file to support the 128GB RAM during peak 70B model loads.

## 3. Worker Deployment (Local)

- [ ] **Polecats (Code Generation)**: Deploy Qwen2.5-Coder-32B. This model fits perfectly on the GPU for high-speed generation.

- [ ] **Refinery (Code Checks & Merging)**: Deploy DeepSeek-R1-70B. Utilize the 128GB system RAM to run this reasoning-heavy model.

## 4. Integration & Parallelization

- [ ] **Parallel Testing**: Benchmark concurrent inferences for Polecats to ensure the convoy finishes overnight.

- [ ] **Gastown Config**: Update Gastown agent definitions to point to local API providers.

- [ ] **Automated Handoff**: Verify the pipeline from Gemini's strategic plans to local execution and Refinery verification.
