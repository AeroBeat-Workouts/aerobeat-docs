# Community Creations

AeroBeat still aims to support community-created workout content, but the current docs slice is more focused about what that means in v1.

## Durable content hierarchy

- **Song** → reusable audio and timing source
- **Chart** → one concrete playable difficulty / compatibility slice
- **Set** → package-local composition record that links one Song, one Chart, one Environment, and optional coaching overlay choices
- **Workout** → ordered training session that assembles exact set selections

## Community content types kept in this slice

- **Songs**
- **Charts / Sets** for Boxing and Flow
- **Environments**
- **Coaching** inside the package's single `coaches/coach-config.yaml`

## What changed

Older docs taught package-local gameplay assets as a first-class workout authoring concept. That is being removed from the official v1 package story.

Future customization direction should instead point toward:

- controlled avatar customization
- cosmetics unlocks
- profile-driven progression using workout points

## Building a workout

Creators assemble workouts by choosing:

- gameplay feature: Boxing or Flow
- chart difficulty intent
- exact songs, charts, and sets
- one environment per set
- optional coaching overlays through the package's single coach config

## Athlete overrides

Athletes may still want profile-level preferences such as:

- avatar identity
- preferred environment style
- coaching on/off
- accessibility and comfort settings

Those account-level choices are different from the old package-local gameplay asset swap model.
