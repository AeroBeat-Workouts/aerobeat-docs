# Athlete Profile Hub

The Athlete Profile is the v1 home for **identity, continuity, and simple progress visibility**.

It should feel useful the first week without pretending AeroBeat already ships a full social platform or premium analytics suite.

See also:

- [V1 Account and Retention Behavior](../../architecture/v1-account-retention-behavior.md)
- [Gamification & Habit Building](../gamification/overview.md)
- [Athlete Preferences & Overrides](preferences.md)

## V1 role

The profile hub exists to answer three practical questions:

1. **Who am I in AeroBeat?**
2. **What have I done recently?**
3. **Am I on track this week?**

## V1 contents

### Identity card

V1 should show:

- display name
- join date
- current avatar / equipped official cosmetics
- current WP balance
- current streak

V1 does **not** need public bio fields, social follow counts, or searchable profile pages.

### Weekly progress card

V1 should show:

- current weekly goal target
- progress toward that goal
- whether this week is already complete
- current weekly-consistency streak

The progress state should be legible in plain language, such as:

- `2 / 3 workout days completed`
- `Weekly goal complete`
- `4-week streak`

### Lifetime stats card

V1 should keep the stat set narrow and trustworthy:

- lifetime completed workouts
- lifetime active minutes
- lifetime WP earned
- recent Boxing vs Flow mix if cheap to compute

Avoid trying to impress with a giant dashboard.

### Recent history

V1 should show a recent activity list with entries like:

- date/time
- workout name
- mode
- duration
- WP earned

A short recent list is enough for launch. The point is continuity, not forensic analytics.

### Preferences entry points

The profile hub can link to preferences and the locker room, but it should not become a dumping ground for every settings category.

## Explicit v1 exclusions

Do **not** treat these as launch requirements:

- supporter-only analytics panes
- health-platform sync
- CSV export
- public profile sharing
- coach heatmaps
- year/month trend graphs
- body metrics tracking

Those may become useful later, but they are not part of the retained v1 contract.

## UX notes

- The profile should be reachable from the main menu and other obvious non-gameplay surfaces.
- It should load quickly and degrade gracefully if cloud sync is delayed.
- If the athlete is still a guest, the profile should make the benefits of account conversion obvious without blocking basic free use.
