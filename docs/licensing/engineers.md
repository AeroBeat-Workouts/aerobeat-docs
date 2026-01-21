# For Software Engineers

Our codebase is split into three categories. The license depends on which repository you are touching.

### 1. The Engine Hub (`aerobeat-core`)
* **License:** **Mozilla Public License 2.0 (MPL 2.0)**
* **The Rule:** If you modify these files, you **must** share your changes.
* **The Nuance:** This is "File-Level Copyleft." You can link proprietary modules to the Core (e.g., a closed-source Leaderboard SDK) as long as the Core files themselves remain open.

### 2. The Game Client (`aerobeat-assembly-*` & `aerobeat-feature-*`)
* **License:** **GNU GPLv3**
* **The Rule:** The "Product" is strictly Open Source. If you distribute a modified version of the AeroBeat Game Client, you must release the entire source code.
* **Why:** This prevents corporations from taking our community's work, closing the source, and selling it as a clone.

### 3. Hardware Drivers (`aerobeat-input-*`)
* **License:** **Mozilla Public License 2.0 (MPL 2.0)**
* **The Rule:** Input drivers are treated like the Engine Core.
* **Why:** We want hardware vendors (e.g., Smart Watch makers, VR Headset companies) to write official drivers for AeroBeat. MPL 2.0 allows them to link their proprietary SDKs (DLLs/Libs) to our Input System without violating the license.

### 4. The UI Stack (`aerobeat-ui-*`)
* **UI Core & Kits (`aerobeat-ui-core`, `aerobeat-ui-kit-*`):** **Mozilla Public License 2.0 (MPL 2.0)**
    * **The Rule:** These are treated as standard libraries. You can link them to proprietary shells if needed, but changes to the files themselves must be shared.
* **UI Shells (`aerobeat-ui-shell-*`):** **GNU GPLv3**
    * **The Rule:** The Shell contains the specific application flow and wiring. It is treated as part of the Game Client and must be open source.
    * **Why:** This prevents bad actors from taking the community-built interface, rebranding it as their own, and closing the source.