# For Commercial Partners

While our community releases are strictly GPLv3, **AeroBeat-Fitness retains the copyright** to the codebase. This allows us to offer **Dual Licensing** for commercial partners who need to bypass the restrictions of the GPL.

## Dual Licensing Strategy

### What is Dual Licensing?

Dual Licensing means the same code is available under two different licenses:

1.  **Open Source (GPLv3):** Free to use, but requires you to share your source code if you distribute it.
2.  **Commercial (Proprietary):** A paid license that allows you to keep your source code private, modify the engine freely, and deploy to closed platforms (like Consoles or Arcades).

### Why would I need a Commercial License?

*   **Closed Source Requirements:** You are building a proprietary game (e.g., "Linkin Park Arcade Edition") and cannot share the source code for your specific gameplay logic or UI Shell.
*   **Console NDAs:** Sony, Nintendo, and Microsoft SDKs are under NDA and cannot be mixed with GPL open-source code repositories.
*   **Legal Safety:** You want a traditional software license agreement with indemnification, rather than relying on a community license.

### How it Works

Because all contributors sign a **Contributor License Agreement (CLA)**, AeroBeat-Fitness has the legal right to re-license the codebase.

1.  **Contact Us:** Reach out to discuss your project scope.
2.  **License Grant:** We provide a specific license grant for the repositories you need (e.g., `aerobeat-assembly-*`, `aerobeat-ui-shell-*`).
3.  **Development:** You fork the repositories privately. You can pull updates from the Open Source upstream, but you are not required to push your changes back.
4.  **Funding:** The licensing fees go directly into funding the core development team and maintaining the Open Source version.

## Commercial FAQ

**Q: Can I sell a game built on AeroBeat?**

**A:** Yes. However, if you use the free Community Edition (GPLv3), you must release your game's source code to your players. If you wish to keep your source code private, you must purchase a Commercial License.

**Q: Can I release on Consoles (Switch, PS5, Xbox)?**

**A:** Not with the Community Edition. Console SDKs are protected by NDAs that are legally incompatible with the GPLv3 license. You need a Commercial License to legally deploy AeroBeat to consoles.

**Q: Can I use the default songs and skins in my commercial game?**

**A:** **No.** The content in `aerobeat-asset-*` is licensed under **CC BY-NC 4.0** (Non-Commercial). You must replace these assets with your own art and music, or contact us to license specific assets.

**Q: Does AeroBeat take a revenue cut?**

**A:** The Open Source version is free. Commercial Licenses are negotiated based on the project scope (Flat fee or Royalty).

**Q: I am a hardware vendor. Do I need a commercial license to write a driver?**

**A:** **No.** Input drivers use **MPL 2.0**, which allows linking to proprietary SDKs. You can write and distribute a driver for your hardware without paying us or opening your SDK source code.