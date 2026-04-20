# Social Crews (Guilds)

Crews are the social backbone of AeroBeat. They allow athletes to form communities, compete on private leaderboards, and find workout partners.

## 1. Philosophy

*   **Community First:** Crews are about belonging, not just competition.
*   **Accountability:** Crews provide a structure for athletes to motivate each other, share workouts, and celebrate milestones together.
*   **Open Access:** While creating a Crew is a Supporter perk, *joining* one is free for everyone. This prevents the community from fracturing into "Paid vs Free" groups.

## 2. Structure & Roles

### A. Creation (The Founder)

*   **Requirement:** Must be an active **Supporter**.
*   **Cost:** None (included in Supporter perks).
*   **Limits:** One Crew ownership per account.

### B. Identity

*   **Name:** Unique string (e.g., "Neon Runners"). Max 24 chars.
*   **Tag:** Unique 3-4 character ticker (e.g., `[NEON]`). Displayed next to member names in lobbies.
*   **Banner:** Customizable background color/pattern for the Crew page.

### C. Roles
1.  **Captain (Owner):** Can manage settings, kick members, promote officers.
2.  **Officer:** Can invite/kick members, update the "Message of the Day".
3.  **Member:** Can view private leaderboards and chat.

## 3. Features

### A. Private Leaderboards

Every song in the game gets a "Crew Filter" on the leaderboard. This allows members to compete specifically against their friends rather than the global top 10.

### B. The Gym (Hub)

A dedicated UI page for the Crew.

*   **Message of the Day (MOTD):** Pinned announcement from the Captain. This is the primary way to **specify workouts** for the group to focus on for the week.
*   **Roster:** List of members and their online status.
*   **Activity Feed:** "UserX just set a new PB on SongY!" Members can click a **"Kudos"** button to congratulate each other, fostering accountability.

### C. Connectivity

Finding friends in a sea of players can be hard.

*   **Lobby Highlighting:** Crew members appear with a distinct visual flair in the Lobby Browser, making it easy to find and join their sessions.

### D. Capacity

*   **Level 1:** 50 Members.
*   **Expansion:** Crews can level up by earning collective WP (Workout Points), unlocking higher caps (up to 500).

## 4. Moderation & Safety

To prevent toxicity, strict rules apply to Crew metadata.

*   **Profanity Filter:** Names and Tags pass through a strict server-side filter.
*   **Reporting:** Players can report a Crew for offensive content.
*   **Sanctions:**
    *   *Strike 1:* Name reset + Warning.
    *   *Strike 2:* Disbandment + Captain Ban.

## 5. Technical Implementation

### Database Schema (Concept)

```sql
TABLE Crews (
    id UUID PRIMARY KEY,
    name VARCHAR(24) UNIQUE,
    tag VARCHAR(4) UNIQUE,
    owner_id UUID REFERENCES Users(id),
    level INT DEFAULT 1,
    xp BIGINT DEFAULT 0
);

TABLE CrewMembers (
    crew_id UUID REFERENCES Crews(id),
    user_id UUID REFERENCES Users(id),
    role ENUM('member', 'officer', 'captain'),
    joined_at TIMESTAMP
);
```

### Supporter Logic
*   **Creation:** API checks `user.is_supporter` before `INSERT INTO Crews`.
*   **Lapse:** If a Captain's Supporter status expires, the Crew **remains active**. They just cannot edit settings (Name/Tag) until they renew. They do *not* lose ownership.