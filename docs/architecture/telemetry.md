# Telemetry & Data Privacy

AeroBeat is committed to a "Privacy-First" approach. However, to maintain the security of our UGC platform and prevent abuse, we collect specific data points from both Guest and Verified Athletes.

## 🕵️ Guest Athlete Telemetry

Guest access is designed to be low-friction (no email required), but high-security (anti-abuse).

### 1. Device Fingerprinting

To enforce bans and prevent quota evasion, we generate a unique hash based on the user's hardware.

*   **Data Point:** `device_id` (SHA-256 Hash).
*   **Source:** `OS.get_unique_id()` (or platform equivalent) + Salt.
*   **Purpose:**
    *   **Ban Evasion:** Prevents a banned user from simply reinstalling the game to reset their status.
    *   **Quota Enforcement:** Ensures the "20 downloads/day" limit applies to the physical machine, not just the session.
*   **Retention:** Stored permanently in the `BannedDevices` table if banned; otherwise stored in `GuestSessions` with a TTL (Time To Live).

### 2. Network Data

*   **Data Point:** IP Address.
*   **Purpose:**
    *   **DDoS Protection:** Used by our WAF (Web Application Firewall) to block botnets.
    *   **Geo-Locking:** Enforcing regional licensing restrictions for specific songs (if applicable).
*   **Retention:** 7-day rolling log for security auditing. Not linked to a persistent user profile.

### 3. Usage Metrics

*   **Data Point:** Download History.
*   **Purpose:**
    *   **Rate Limiting:** We track `downloads_last_24h` to enforce the Guest Quota.
    *   **Popularity Sorting:** Anonymous download counts contribute to the "Most Popular" sort order in the content browser.

## 👤 Verified Athlete Telemetry

When a user creates an account, we collect additional data to provide cloud services.

*   **Identity:** Email, Username, Password (Hashed).
*   **Library:** List of subscribed mods (for syncing across devices).
*   **Performance:** High scores, calories burned (optional), and workout history.

## ⚖️ GDPR & CCPA Compliance

*   **Right to be Forgotten:**
    *   **Guests:** Since guest data is not linked to PII (Personally Identifiable Information) like email, it naturally expires from our Redis cache when the session TTL ends, unless the device is banned for abuse.
    *   **Verified:** Users can request full account deletion via the settings menu.
*   **Data Minimization:** We do not collect microphone audio or camera feeds. All Computer Vision processing happens **locally** on the device; only the resulting "Input Events" (e.g., "Punch Detected") are processed by the game logic.

## 4. Data Retention Policies (Advanced Analytics)

To support the "Advanced Analytics" features for Supporters while managing storage costs, we enforce tiered retention policies.

### A. Workout History (Logs)
*   **Free Athletes:** We retain a rolling window of the last **50 sessions**. Older logs are soft-deleted.
    *   *Note:* The client UI only displays the last 10 sessions to free users. The extra 40 are kept to provide immediate value if the user upgrades to Supporter status.
*   **Supporters:** We retain **Unlimited** workout history while the Supporter status is active.
    *   *Lapse Policy:* If a Supporter status lapses, data is not immediately deleted. It enters a "Frozen" state for 1 year before reverting to the Free Tier retention policy.

### B. Granular Hit Data (Heatmaps)
To generate "Accuracy Heatmaps" (e.g., "You miss low-left targets"), we collect granular hit data `( view_type, lane_id, hit_offset_ms, hit_position_xy)`.

*   **Raw Data:** Stored transiently and deleted after **7 days**.
*   **Aggregates:** Raw data is processed into **Monthly Aggregates** (e.g., "Lane 1 Accuracy: 85%") nightly. These aggregates are retained indefinitely for Supporters to visualize long-term trends.

## 5. Client Implementation

Telemetry collection is handled by the **`aerobeat-tool-analytics`** service.

*   **Batching:** Events are queued locally and sent in batches (every 60s or on app exit) to reduce network overhead.
*   **Offline Support:** If the device is offline, events are persisted to disk and retried on the next session.
*   **Opt-Out:** The service checks `AeroUserPreferences` before initializing. If the user has opted out of analytics, the service enters a "No-Op" mode.