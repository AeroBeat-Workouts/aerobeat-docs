# Hybrid Gastown Orchestration Plan

## Primary Goal

Create a hybrid local & cloud solution for running Gastown, the parallel agent orchestration model used in the AeroBeat rhythm workout platform for code generation.

Our end goal, is to develop a system that scales human engineering effort non-linearly while minimizing the costs of doing so.

## Known Limitations And Notes

*   Today, January 29, 2026, running parallel agents on a single GPU with 10GB VRAM is limited if we intend to run our agents solely within VRAM to prevent slowdown due to use of RAM for swaps.

*   To enable parallel orchestration, this plan utilizes a *burst* method for work. When Gastown sees a convoy of work come through its orchestration system that cannot be handled by our local hardware, it is passed onto Cloud hosted agents to perform the additional work. By controlling this burst system, we can control the costs associated with a purely Cloud solution.

*   We are using the Gastown orchestration method to allow us to use this hybrid strategy vs a pure cloud solution with many parallel agents. This allows us to save costs by running locally, or scale via Cloud agents.

* The AeroBeat platform is created with Godot 4.x .gdscript. So models chosen
will need to prevent hallucinations (Godot 3.x syntax for example).
The primary method to prevent this issue is proper agent role files and strict unit and end to end tests.

* In early 2026, our starting *Local* hardware is a single Alienware Aurara Desktop PC with an older GPU (10GB VRAM), a good CPU and *lots* of extra RAM (128GB). Our plan for the local agents will utilize this hardware while still allowing the terminal to be used by a human engineer. Around ~1.5GB VRAM will be reserved for the Zorin OS and a safety buffer. A typical daily workload is estimated to take ~1.1GB VRAM without any agents working in the background.

*   AeroBeat is open-source and uses public repositories on Github, we can take advantage of their generous open source pricing for CI/CD and hosting.

## AeroBeat Gastown Agentic Workflow

AeroBeat has specialized agents with unique roles compared to the standard ones included with Gastown, which automate the day-to-day tasks that *can* be automated, letting the human developers feed AeroBeat's town with change requests.

*   **Mayor**: Used to break down large feature ideas into plan documents, and then convert those plans into convoys of beads. Is aware of *Burst* mode and will orchestrate convoys accordingly.

*   **Crew**: Specialized with each rigs knowledge, used for communication with the other agent roles about rig specific questions. Specialized in answering questions about a rig without hallucinating. Created per rig when a convoy of beads is created that touches that rig, or when a question about a rig is asked by another agent.

*   **Defenders**: One `Defender` is created per rig a convoy touches. Writes the unit tests at the beginning of each convoy of beads for the `Polecats` and `Refineries` to fulfill with their work.

*   **Polecat**: Worker bees that create the classes, functions, etc to pass the tests written by the `Defender`. Adheres to coding style guidelines and Godot 4.x specifications.

*   **Refinery**: Created in a pair with each `Polecat`. Reviews the `Polecats` changes, double checks them and applies improvements (performance, anti-hallucination, style-guide adherence, etc.). Makes sure the rig has enough test coverage to meet our acceptance criteria.

*   Once all `Polecat` and `Refinery` agents are done, the next group of agents take over.

*   **Watchdog**: One `Watchdog` is created per rig a convoy touches. Reads through the an active rig in this convoy and searches for vulnerabilities, exploits, private Api keys, etc. Records potential issues and security health estimates for the convoy in our private `Watchdog` repository.

*   **Librarian**: One `Librarian` is created per rig a convoy touches. Summarizes the changes to the rig and updates the rig's `Readme.md` file.

*   **Gauger**: One `Gauger` is created per rig a convoy touches.Runs after the `Librarian` and `Watchdog` roles have finished. Communicates with the Godot CLI (local or cloud if in *burst* mode) to ensure unit tests pass. If tests pass they kick off one build per `Assembly` (build target) to be reviewed by the `Spotter`.

*   **Spotter**: One `Spotter` is created per `Assembly` that create a build. Runs after all the `Gauger` finish their tests. If tests pass, runs end-to-end tests using multi-modal input to verify 'truth' based on the verification criteria stored in the `.truth/` folder within each assembly. The test results are stored in the private `Spotter` repository.

*   **Bug Scout**: Reads through public bug reports coming in from players, categorizes them, and stores them in our private `Bug Scout` repository.

*   **Oracle**: Reads through public discussions on AeroBeat and records her findings in the private `Oracle` repository. Top feedback from players is to be considered for implementation.

*   **Assistant**: Every morning, sends an update to the AeroBeat team about what got done yesterday, bug reports, security issues, and the oracle's findings.

## Local Hardware Overview

*   **Operating System**: Zorin OS 18 Pro

*   **Firmware Version**: 1.20.0

*   **Kernel Version**: Linux 6.14.0-37 Generic

*   **Hardware**: Alienware Aurora R13

*   **Processor**: 12th Gen Intel i7-12700KF x 12 physical cores (8 Performance & 4 Effeciency Cores) & 20 threads

*   **Memory**: 128GB

*   **Disk Capacity**: 3.1TB

*   **Graphics**: NVIDIA GeForce RTX 3080 - 10240MiB (10GB) VRAM

## High End Strategy

• Use Gemini 3 Pro via the Google Studio Api for high-level architectural planning and epic decomposition with the Gastown Mayor working alongside rig expert crew members to validate plans.

• Use the Mayor to sling convoys of beads (git backed json tasks) to Polecats and the Refinery agents, which run on local hardware to save on costs.

• Make full used of our CPU + RAM + VRAM to run simultaneous agents while leaving enough resources to our Zorin 18 OS Pro for it to be used for work by the human engineer while the agents operate in the background.


## **Strategy**

### Local Model Requirements

*   We would prefer to run multiple polecat workers simultaneously if possible within our limited VRAM.

*   Use 4-bit Quantization for the sweet spot of performance vs resources

*   We estimate VRAM usage of about ~0.11 MiB per token for context

*   Gastown agents require ~2k tokens to recieve their role info

*   Local Rigs (repository) Readme.md file is usually about ~1-2k tokens.

*   Estimate each .gdscript file in a rig to take ~1-3k tokens. An average rig will have up to 10 .gdscript files, usually less. So `Crew Members` should be capable of up to 32k token windows to allow larger rigs to work.

### Cloud Model Requirements

*   Prioritize effeciency. We should not always choose the *smartest* model. It's easy to just through a thinking LLM Model at everything and call it a day. But that would be very costly. Pick and choose your cloud models according to what our requirments are likely to be.

*   Prioritize cloud providers that can share context between active models  without the context cost.

### **Mayor**: 

*Cloud* - Large Context, Deap Reasoning

*   Gemini 3 Pro Preview - Most expensive Gemini model with thinking capabilities. Effective for large contexts and breaking down features into convoys of beads.

### **Crew**:

*Local* - Intelligence - 1 Agent - Uses some VRAM with lots of CPU + RAM

*   GPT-OSS 20B : 4-bit (Q4_K_M). Uses 2 P-Cores. ~22GB RAM used with 32k tokens. ~2-5 tps with Medium reasoning effort. Initial cold start of ~45-70 seconds for the model to perform initial 'warm up' while it injests documentation. Cost is paid once per day on average on PC start using a script to keep the model warm.

*Cloud* - Burst Solutions

*   Gemini 3 Flash Preview : Holds onto rig documentation no problem. Very fast while being cost effective for rig questions.

### **Defenders**

*Local* - Unit Tests - 1 Agent - Fits In Local E-Cores + RAM

### **Polecats (Workers)**

*Local* - Speed - 2 Local Agents Solution - Fits in VRAM.

*   Qwen3-Coder-3B: ~100 tps 4-bit (Q4_K_M) GGUF. Use 2 simultaneous agents (up to 6k tokens). ~3-4GB VRAM Usage per agent. ~6-8GB VRAM for two agents.

*Local* - Speed - 1 Local Agent Solution - Fits in VRAM.

*   Qwen3-Coder-7B: ~100 tps 4-bit (Q4_K_M) GGUF. Use for higher intelligence with long context lengths (14k tokens) with 1 agent at a time. ~6.5GB VRAM Usage.

*   Qwen3-Coder-3B: ~100 tps 4-bit (Q4_K_M) GGUF. Use for very long context lengths (up to 32k tokens). ~6GB VRAM Usage.

*   Qwen3-Coder-30B-A3B: ~12-20 tps 4-bit (Q4_K_M) GGUF. Mixture-Of-Experts Model (MOE). Requires offloading non-active expert layers and KV cache to RAM.

*   Llama 4 8B : ~82 tps 4-bit (Q4_K_M) GGUF for context lengths under 8k tokens. Can only run one agent at a time. ~6GB VRAM for 4k tokens. ~8GB for 16k tokens.

*   Gemma-3-4B-It: ~40-50 tps 5-bit (Q4_K_M) GGUF. ~6.5GB VRAM for 12k tokens.

*   DeepSeek-Coder-V3-Lite (8B): ~15-25 tps 4-bit (Q4_K_M) GGUF for context lengths under 6k tokens

*Cloud* - Speed - Burst Solutions

*   Qwen3-Coder-30B-A3B-Instruct (Qwen3-Coder-Flash): High performance, Mixture of Experts (MoE with 30.5B total parameters with only 3.3B active / 8 experts per forward pass), Much better performance to local (Q4_K_M) Qwen3-Coder-3B model our local PC would use. Open source and weights. Native 262k tokens input. Extendable to 1M tokens input using Yarn (RoPE scaling technique). Up to 65.5k tokens output. $0.18/1M tokens for Input. $0.18/1M tokens for Output.

*   Qwen3-Coder-480B-A35B-Instruct (Qwen3-Coder-Plus): Better at complex tasks, code reviews, and large generations compared to Flash variant. No optional reasoning mode. Closed source and weights. $1.00/1M tokens for Input. $5.00/1M tokens for Output.

*   Gemini 3 Flash: Known quantity and good overall performance. Up to 1M tokens input. Up to 65.5K tokens output. Multimodal. Has an optional reasoning mode. $0.50/1M tokens for input processing. $3.00/1M tokens for output processing.

*   Gemini 2.5 Flash-Lite: Inexpensive with performance that *might* be good enough for .gdscript code generation. $0.10/1M tokens for Input processing. $0.40/1M tokens for Output processing.

### **Refineries (Reviewers)**

*Local* - Intelligence - 1 Agent - Fits In CPU + RAM + VRAM

*   Llama 4 Scout: ~3-5 tps 4-bit (Q4_K_M) GGUF. 2.0GB (KV)	CPU + 128GB RAM. We will load entire model onto ~68GB RAM then offload KV Cache and first few layers to 2GB VRAM on our GPU.

*Local* - Intelligence - 1 Agent - Fits In CPU + RAM

*   DeepSeek-R1-Distill-Qwen-32B: ~3-5 tps 4-bit (Q4_K_M) GGUF. Uses chain of thought reasoning for code reviews. Takes roughly 20GB of RAM. Assigned 5 P-Cores from CPU.

*   Qwen3-7B-Instruct: ~3.5 tps 4-bit (Q4_K_M) GGUF. Performs documentation tasks. Assigned E-Cores 8-11 from CPU. Takes about 4.8GB RAM before token load, and ~7.2GB after using 32k tokens.

*Local* - Intelligence - 1 Agent - Fits In VRAM

*   Qwen3-Coder-7B: ~100 tps 4-bit (Q4_K_M) GGUF. Same as Polecat version. Use for higher intelligence with long context lengths (14k tokens) with 1 agent at a time. ~6.5GB VRAM Usage.

*   Qwen3-Coder-3B: ~100 tps 4-bit (Q4_K_M) GGUF. Use for very long context lengths (up to 32k tokens). ~6GB VRAM Usage.

*Cloud* - Intelligence - Burst Solutions

*   Qwen3 Coder 480B A35B : 262.1K token context window. Has a deap reasoning mode. Open source and weights. $0.22/M input and $0.95/M output.

*   Gemini 3 Flash: Known quantity and good overall performance. Up to 1M tokens input. Up to 65.5K tokens output. Multimodal. Has an optional reasoning mode. $0.50/1M tokens for input processing. $3.00/1M tokens for output processing.

### **Watchdog**:

*   Qwen3-Coder-7B: ~100 tps 4-bit (Q4_K_M) GGUF. Same as Polecat version. Use for higher intelligence with long context lengths (14k tokens) with 1 agent at a time. ~6.5GB VRAM Usage.

*Cloud* - Intelligence - Burst Solutions

*   Qwen3 Coder 480B A35B : 262.1K token context window. Has a deap reasoning mode. Open source and weights. $0.22/M input and $0.95/M output.

### **Librarian**:

*Local* - Documentation - 1 Agent - Fits In Local E-Cores + RAM

*   Qwen3-Coder-1.5B : ~20-25 tps 4-bit (Q4_K_M) GGUF. ~2GB RAM for model. With 32k tokens, ~7-10GB RAM usage.

*   SmolLM2-1.7B-Instruct : 150+ tps on E-Cores only. ~2GB RAM.

*Cloud* - Intelligence - Burst Solutions

*   Qwen3 Coder 480B A35B : 262.1K token context window. Has a deap reasoning mode. Open source and weights. $0.22/M input and $0.95/M output.

### **Gauger**:

*Local* - Documentation - 1 Agent - Fits In Local E-Cores + RAM

*   Qwen3-Coder-1.5B: 1 gauger agent running locally on CPU & RAM using 4-Effeciency cores for this agent. ~20-25 tps is good enough for the gauger to perform CLI operations and catalog responses.

*Cloud* - Intelligence - Burst Solutions

*   Qwen3 Coder 480B A35B : Very large context window (1/4 size of Gemini models, but more than large enough for Gauger). Has a deep reasoning mode. Very inexpensive compared to closed models.

### **Gauger & Spotter**:

*Cloud* - Intelligence - Burst Solutions

*   Kimi K2.5 : Newest open-source & open-weight multi-modal model. Would work great for performing `.truth` checks. $0.60 per Million tokens.

*   Gemini 3 Flash : Used for the multi-modal attributes to run CLI, watch responses, and create builds and compare them to `.truth` documentation using multi-modal capabilities.

## 1. Answer Remaining Questions

- [x] **Decide Mayor Model**: 

*   Gemini 3 Pro Thinking: Extremely high context window, great for breaking down epics into convoys of beads across a large variety of rigs while relying on Crew Models for rig specific documentation.

- [x] **Decide Crew Model**: 

*   GPT-OSS 20B : Write at a fast human speed of ~2-5 tps with Medium reasoning effort. Good enough for the occasional question about a rig. Uses 2 P-Cores and ~22GB RAM

*   When multiple crew members are needed, burst to the *Cloud* Agents below

*   Gemini 3 Flash: High context window without the cost of deep thinking. Perfect for answering questions about rigs. Spawned per rig when a convoy of beads is created that touches that rig.

- [x] **Decide Defender Model**: 

*   DeepSeek-R1-Distill-Qwen-32B: 1 `Defender` agent running locally on CPU & RAM using 6 performance cores for deep thinking. We will leave 2 performance cores for Zorin OS 18 Pro and engineering work. ~12-15 tps is good enough for the `Defender` agent.

*   When multiple Defenders are needed, burst to the *Cloud* Agents below

*   Qwen3 Coder 480B A35B : Very large context window (1/4 size of Gemini models, but more than large enough for Defender). Has a deep reasoning mode. Very inexpensive compared to closed models.

- [x] **Decide Polecat Model**: 

*   1x Qwen3-Coder-7B: Stay under <= 14k tokens to avoid spilling into CPU + RAM, Best in weight class for Godot 4.x .gdscript generation.

*   When multiple Polecats are needed, burst to the *Cloud* Agents below

*   Qwen3-Coder-30B-A3B-Instruct (Qwen3-Coder-Flash): High performance, very large context window (1/4 the size of Gemini's latest offerings, but way more than enough for a Polecat). And very inexpensive compared to closed models.

- [x] **Decide Refinery Model**: 

*   DeepSeek-R1-Distill-Qwen-32B: 1 refinery agent running locally on CPU & RAM using 6 performance cores for deep thinking. We will leave 2 performance cores for Zorin OS 18 Pro and engineering work. ~12-15 tps is good enough for the refinery agent.

*   When multiple Refineries are needed, burst to the *Cloud* Agents below

*   Qwen3 Coder 480B A35B : Very large context window (1/4 size of Gemini models, but more than large enough for refinery). Has a deep reasoning mode. Very inexpensive compared to closed models.

- [x] **Decide Watchdog Model**: 

*   Qwen3-Coder-7B: Same local agent model used by the `Polecat`.

*   When multiple Watchdogs are needed, burst to the *Cloud* Agents below.

*   Qwen3 Coder 480B A35B : Same burst agent model used by the `Polecat`.

- [x] **Decide Librarian Model**: 

*   Qwen3-Coder-1.5B: 1 library agent running locally on CPU & RAM using 4 effeciency cores for documentation writing. We will use all effeciency cores for this agent. ~20-25 tps is good enough for the librarian.

*   When multiple Librarians are needed, burst to the *Cloud* Agents below

*   Qwen3 Coder 480B A35B : Very large context window (1/4 size of Gemini, but good enough for the librarian). Has a deep reasoning mode for documentation and summaries. Less expensive than comparable close source models.

- [x] **Decide Gauger Model**: 

*   Qwen3-Coder-1.5B: 1 gauger agent running locally on CPU & RAM using 4-Effeciency cores for this agent. ~20-25 tps is good enough for the gauger to perform CLI operations and catalog responses.

*   When multiple Gaugers are needed, burst to the *Cloud* Agents below

*   Qwen3 Coder 480B A35B : Very large context window (1/4 size of Gemini models, but more than large enough for Gauger). Has a deep reasoning mode. Very inexpensive compared to closed models.

- [x] **Decide Spotter Model**: 

*   We automatically burst to the *Cloud* Agents below, there isn't a good multi-modal solution that will work on our local PC.

*   Kimi K2.5 : Latest open source multi-modal model. Agent swarm compatible. Higher scores than current Gemini models for vision work that's exactly what we need for the `Spotter` role.

- [x] **Decide Local Runner**: 

*   llama.cpp server: Low level, high performance. Runs any GGUF model on local hardware. Steep learning curve and CLI operation. Estimated ~70% faster than Ollama as of January 2026 due to better handling of the "FlashAttention-3" and "GQA" (Grouped Query Attention) implementations for the Qwen3 and Llama 4 architectures. We will set the `--ctk q8_0` (Key cache) and `--ctv q4_0` (Value cache) flags for the `Refinery` to prevent crashing.

## 2. Infrastructure Preparation

- [x] **OS Configuration**: Optimize Zorin OS 18 Pro and ensure NVIDIA drivers for the RTX 3080 are current.

- [ ] **Local Runner Setup**: Install local runner to provide OpenAI-compatible local endpoints.

- [ ] **Download LLM Models**: Download the specific models we will be using.

- [ ] **Create Gastown Guide**: Create a setup guide to install Gastown and connect it to our local runner and cloud providers.

- [ ] **Follow Gastown Guide**: Perform all the steps in the Gastown guide to prepare our local work environment. Modify the guide as we discover missing content to help future engineers get setup.

## 3. Testing Workflow

- [ ] **Test Crew Members** Provide models the `Crew Member` role, provide them access to a rig, and have the `Mayor` ask them questions when requiring info about a rig, rather than bloating their context directly.

- [ ] **Test Polecats**: Provide models the 'Polecat' and 'Refinery' roles, point them at our AGENTS.MD file in a rig, and give them a task written as if a mayor sent it to them and see how they perform.

- [ ] **Test Refinery**: Provide models the 'Refinery' role, point them at our AGENTS.MD file in the same rig as the Polecats, and give them a code evaluation task written as if a mayor sent it to them and see how they perform.

- [ ] **Test Librarian**: Provide models the 'Librarian' role and test a librarian task bead to update documentation rig and provide a daily summary of work performed.

## 4. Integration & Parallelization

- [ ] **Gastown Config**: Update Gastown agent definitions to point to local API providers.

- [ ] **Local Models**: Verify the pipeline works by creating a convoy with the mayor and slinging it to our local agents.

- [ ] **Burst Mode**: Create and verify that burst mode logic works as intended with additional roles being created by Cloud agents instead of pausing convoys and beads, and that we return to using local agents first when they are freed up.