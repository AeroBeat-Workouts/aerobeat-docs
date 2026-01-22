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
    *   **Popularity Sorting:** Anonymous download counts contribute to the "Most Popular" sort order in the browser.

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