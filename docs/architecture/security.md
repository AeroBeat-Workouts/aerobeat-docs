# Security Strategy

AeroBeat employs a **Defense in Depth** strategy to protect our infrastructure, our athletes' data, and the integrity of the competitive leaderboard.

## 🛡️ Network Defense (Layer 3/4/7)

We utilize a Web Application Firewall (WAF) as our first line of defense.

*   **DDoS Protection:** The WAF absorbs volumetric attacks before they reach our API servers.
*   **Bot Mitigation:** Known botnet signatures and scraping tools are blocked at the edge.
*   **Geo-Blocking:** Traffic from sanctioned regions is dropped before processing.

## 🚦 API Security (Quotas & Throttling)

To prevent resource exhaustion, we enforce strict limits based on the user's trust tier.

### 1. Rate Limiting
*   **Guest Athletes:** Highly restricted (e.g., 60 requests/hour). Sufficient for browsing, but prevents scraping.
*   **Verified Athletes:** Standard limits (e.g., 1000 requests/hour).
*   **Mechanism:** Token bucket algorithm keyed by `user_id` (Verified) or `device_id` (Guest).

### 2. Bandwidth Offloading
We never accept binary uploads directly to our API servers.
*   **Strategy:** We use **Pre-Signed URLs** (S3/Cloud Storage).
*   **Benefit:** This offloads the heavy bandwidth of file uploads to the cloud provider's infrastructure, preventing our API from being overwhelmed by large payloads.

## 📦 Content Security (Sandboxing)

User Generated Content (UGC) is the primary vector for Remote Code Execution (RCE) attacks. We treat all uploads as hostile until proven otherwise.

### 1. The "Air Gap" Validator
When a file is uploaded, it is not immediately published.
*   **Isolation:** Validation runs in an ephemeral, network-isolated container (e.g., AWS Fargate / Firecracker VM).
*   **Resource Caps:** The container has strict RAM and CPU limits to mitigate "Zip Bomb" attacks.
*   **Lifecycle:** The container is destroyed immediately after the validation job completes.

### 2. Static Analysis
Before the file is even mounted by Godot, we scan the raw bytes.
*   **Script Ban:** We grep for `extends Node` or `script/source` inside text resources (`.tres`, `.tscn`).
*   **Extension Whitelist:** Only specific file types (`.pck`, `.png`, `.ogg`, `.webm`) are allowed. Executables (`.dll`, `.so`) are rejected.

## 🕵️ Client Integrity (Anti-Cheat)

Since AeroBeat uses a "Client Authority" model for rhythm scoring (to eliminate latency), we must trust the client—but verify.

*   **Sanity Checks:** The server validates that a submitted score is mathematically possible given the song's note count.
*   **Device Fingerprinting:** We generate a unique hardware hash (`device_id`) to enforce bans. If a user is banned for cheating, reinstalling the game will not reset their status.
*   **Replay Analysis:** (Future Roadmap) For high-stakes leaderboards, the client uploads a lightweight input replay. The server re-simulates the session to verify the score matches the inputs.

---

> **Note:** Security is an ongoing process. Vulnerabilities should be reported privately to `security@aerobeat.fitness`.