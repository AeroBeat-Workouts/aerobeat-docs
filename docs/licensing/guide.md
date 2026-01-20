# Licensing Guide for Contributors

At AeroBeat, we believe in Open Source, but we also respect that the reality of Game Development involves proprietary hardware, third-party assets, and commercial partnerships.

We use a **Hybrid Licensing Strategy** to balance these needs. This page explains exactly what you can do, what you must share, and how to safely contribute.

---

## 👩‍💻 For Software Engineers

Our codebase is split into three categories. The license depends on which repository you are touching.

### 1. The Engine Hub (`aerobeat-core`)
* **License:** **Mozilla Public License 2.0 (MPL 2.0)**
* **The Rule:** If you modify these files, you **must** share your changes.
* **The Nuance:** This is "File-Level Copyleft." You can link proprietary modules to the Core (e.g., a closed-source Leaderboard SDK) as long as the Core files themselves remain open.

### 2. The Game Client (`aerobeat-assembly` & `aerobeat-feature-*`)
* **License:** **GNU GPLv3**
* **The Rule:** The "Product" is strictly Open Source. If you distribute a modified version of the AeroBeat Game Client, you must release the entire source code.
* **Why:** This prevents corporations from taking our community's work, closing the source, and selling it as a clone.

### 3. Hardware Drivers (`aerobeat-input-*`)
* **License:** **Mozilla Public License 2.0 (MPL 2.0)**
* **The Rule:** Input drivers are treated like the Engine Core.
* **Why:** We want hardware vendors (e.g., Smart Watch makers, VR Headset companies) to write official drivers for AeroBeat. MPL 2.0 allows them to link their proprietary SDKs (DLLs/Libs) to our Input System without violating the license.

---

## 🎨 For Artists & Audio Designers

Our creative content is protected differently than our code to prevent "Asset Flips."

### Content Packs (`aerobeat-asset-*`)
* **License:** **CC BY-NC 4.0 (Attribution-NonCommercial)**
* **Can I use these assets for fun?** Yes! You can remix them, mod them, and share them.
* **Can I use them in a commercial game?** **No.** You cannot take our 3D models, textures, or music and sell them in your own product.
* **Can I claim I made them?** **No.** You must give credit to AeroBeat-Fitness.

---

## 🏢 For Hardware Partners

If you are a hardware vendor looking to integrate your device (Smart Glove, Haptic Vest, XR Headset) with AeroBeat:

1.  **You are safe.** Our Input Tier (`aerobeat-input-*`) uses **MPL 2.0**.
2.  **No Viral Infection.** You can create a repository `aerobeat-input-yourbrand` that contains a mix of Open Source GDScript and your **Closed Source SDK/DLLs**.
3.  **Linking is Allowed.** As long as you do not modify the AeroBeat Core files themselves, your proprietary logic remains yours.

---

## 📚 For Documentation Writers

* **License:** **CC BY-SA 4.0 (Attribution-ShareAlike)**
* **The Rule:** Our Wiki, GDD, and Architecture docs are community-owned. If you improve them, you must share those improvements under the same license.

---

### Quick Reference Table

| Repository Prefix | License | Can I Close Source? |
| :--- | :--- | :--- |
| `aerobeat-core` | **MPL 2.0** | Only your new files. |
| `aerobeat-assembly` | **GPLv3** | **No.** |
| `aerobeat-feature-*`| **GPLv3** | **No.** |
| `aerobeat-input-*` | **MPL 2.0** | Only your new files/SDKs. |
| `aerobeat-asset-*` | **CC BY-NC 4.0** | **No** (and no commercial use). |
| `aerobeat-docs` | **CC BY-NC 4.0** | **No.** (and no commercial use). |
