# AeroBeat Dance Chart YAML Slice

**Date:** 2026-04-29  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the first-pass chart YAML contract for AeroBeat `feature: dance`, starting from the approved flattened Boxing/Flow chart shape and grounding the move taxonomy in researched dance-game move vocabularies.

---

## Overview

The chart envelope direction is already mostly locked from the prior chart-contract phase: charts declare a single `feature`, durable authored gameplay lives in a flat beat/event list, and the authored contract should stay human-readable rather than drifting back into nested runtime-shaped payloads. Boxing and Flow now provide the strongest current examples of that direction, so Dance should begin from the same contract philosophy unless research proves a real reason to diverge.

The main unresolved question for Dance is not the outer envelope but the move vocabulary. Unlike Boxing and Flow, Dance is closer to choreography authoring and pose windows than target hits. That means the first concrete step should be a research pass that extracts movement families from AeroBeat’s current Dance docs and from the inspiration-space Derrick called out. There is a small wording mismatch in the kickoff note — `Dance Central` vs `Just Dance` — so this slice should treat that as an explicit normalization task: compare the public movement language those games use, identify what is durable enough for AeroBeat authoring, and avoid copying any one title’s proprietary surface taxonomy too literally.

This slice stays definition-first. We should leave implementation edits, examples, validators, and cross-repo rollout for a follow-up execution phase after Derrick signs off on the proposed dance move list and the resulting first-pass YAML shape.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active chart-contract discussion plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-28-aerobeat-chart-contract-post-song-timing.md` |
| `REF-02` | Current approved Boxing chart example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml` |
| `REF-03` | Current approved Flow chart example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-flow-medium.yaml` |
| `REF-04` | Current Dance choreography guide | `projects/aerobeat/aerobeat-docs/docs/guides/choreography/dance.md` |
| `REF-05` | Current Dance gameplay GDD | `projects/aerobeat/aerobeat-docs/docs/gdd/gameplay/dance.md` |
| `REF-06` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |

---

## Tasks

### Task 1: Research dance-move vocabulary from internal docs and public inspiration games

**Bead ID:** `aerobeat-docs-so2`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Research the current AeroBeat Dance docs plus public movement vocabulary from both Dance Central and Just Dance. Compare them explicitly, then produce a normalized list of durable move families, stance/transition concepts, and special scoring moments that make sense for AeroBeat authoring. Claim bead `aerobeat-docs-so2` on start with `bd update aerobeat-docs-so2 --status in_progress --json` and close it on completion with `bd close aerobeat-docs-so2 --reason "Research complete" --json`.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- This plan file
- `docs/architecture/dance-move-vocabulary-crosswalk.md`

**Status:** ✅ Complete

**Results:** Completed internal-doc review plus public comparison against Dance Central and Just Dance. Key findings for the next bead:

- **Shared durable direction across AeroBeat + inspiration titles:** keep the outer chart contract flat and authored around readable move events, but normalize Dance move names around **movement function** rather than brand-specific move labels. AeroBeat’s current Dance docs already describe authored sections as highlighted timeline spans that become scoring windows, with coach performance, pictogram preview, pose matching, and optional Gold moments. That lines up with both inspiration games: Dance Central is strong on named, decomposed move units via flashcards; Just Dance is strong on fast-readable preview glyphs and spectacle moments.
- **Recommended durable authored move families for AeroBeat YAML:**
  - `pose` / `hold_pose` for static target-shape matching and sustained final shapes
  - `step` / `step_touch` / `travel` for directional footwork and location changes
  - `weight_shift` for prep/setup transfers that matter to learning but are not dramatic standalone tricks
  - `reach` / `push` / `pull` for linear arm-driven actions
  - `sweep` / `swing` for curved arm or whole-body arcs
  - `clap` / `hit` / `accent` for punctual musical accents
  - `isolation` for torso/hip/chest/shoulder emphasis without large travel
  - `turn` / `spin` / `pivot` for rotational changes, with `pivot` reserved for smaller reorientation and `spin` for larger committed turns
  - `bounce` / `hop` / `jump` for vertical energy with increasing intensity
  - `kick` / `knee_lift` / `leg_lift` for obvious single-leg accents
  - `groove` for low-specificity “keep moving in style” spans when exact limb geometry is intentionally looser than pose windows
- **Recommended stance / transition concepts:** keep a small set of explicit transition-ready terms rather than importing boxing-like stance overload or hundreds of named franchise moves.
  - `stance_open`, `stance_closed`, `stance_wide`, `stance_split`
  - `facing_front`, `facing_left_diag`, `facing_right_diag`, `facing_back` only if the next bead concludes facing is needed as authored data rather than derived animation metadata
  - `prep`, `reset`, `recover`, `transition`, and `weight_shift` are better authoring concepts than proprietary flashcard names for “get ready” motion
  - local docs strongly support **telegraphing** and “simple step before complex foot placement,” so transition/setup should stay a first-class authoring concern
- **Special scoring moments that belong in authored chart content:**
  - **Keep `gold` / Gold Move semantics.** AeroBeat already uses Gold Moves in local docs and Just Dance’s gold-move convention is a clear, player-readable authored highlight. Recommend this as a beat/segment attribute, not a separate proprietary move family.
  - **Pose-window holds** should remain authored through `start` + optional `end` rather than separate runtime-only scoring internals.
  - **Finisher moments** do not need a separate branded term yet; a final hit can usually be represented as `pose` or `hold_pose` + `gold: true`.
  - **Reject Dance Central `freestyle` as a first-pass core move term.** It is a mode/event section where the player is invited to improvise rather than match exact authored geometry. If AeroBeat ever supports it, it should likely be a later special event/span concept, not part of the baseline move vocabulary.
- **Preview / pictogram / cue ownership:**
  - **Chart content should own:** durable move identity, timing span (`start`, optional `end`), any required side/direction/facing qualifiers, and special authored emphasis such as Gold.
  - **Chart content should probably not own by default:** concrete pictogram art, coach-video choices, overlay-audio choices, or presentation-lane behavior. Those belong to move-library metadata, set/coaching config, or runtime UI.
  - **Optional exception worth considering later:** a lightweight `cue` / `previewVariant` / pictogram override only when the default move-library icon would be ambiguous. Do not make pictogram asset paths part of first-pass chart YAML.
  - Dance Central’s flashcards and Just Dance’s pictograms are both evidence that **preview language matters**, but they are presentation systems layered on top of authored move IDs rather than replacements for the authored move contract itself.
- **Reasons to keep or reject game-specific terms:**
  - **Keep / adapt:**
    - `gold move` → already present in AeroBeat docs; good authored emphasis marker
    - `pictogram` → useful as UI/documentation term, but better as preview-system vocabulary than as a chart-field default
    - `coach` → already canonical in AeroBeat and belongs to presentation/coaching domains
    - `pose matching` → accurately describes the scoring style for many Dance beats
  - **Reject as first-pass authored move vocabulary:**
    - Dance Central’s long tail of whimsical branded flashcard names (`Boggy Down`, `Boost`, etc.) because they are not durable cross-song authoring primitives
    - Just Dance routine-specific prop/icon semantics because they are presentation-layer and often song-specific
    - `freestyle` as a default chart move type, because it describes an open performance section rather than a normalized authored movement primitive
- **Most important cross-game comparison for AeroBeat authoring:**
  - **Dance Central contribution:** better model for decomposing choreography into teachable, reusable movement units and transitions; useful inspiration for normalized move families and prep/reset semantics.
  - **Just Dance contribution:** better model for player communication, readable preview glyphs, and high-value highlight moments like Gold Moves; useful inspiration for cueing and emphasis, but not for stuffing chart YAML with pictogram-asset details.
  - **AeroBeat recommendation:** use Dance Central’s technical decomposition discipline for the move taxonomy, then borrow Just Dance’s readability/emphasis philosophy for preview and highlight systems.
- **Net recommendation for the next bead:** first-pass Dance YAML should likely keep the approved flattened authored style (`feature` + flat timeline entries) and define a compact cross-song move vocabulary centered on families like `pose`, `step`, `reach`, `sweep`, `turn`, `jump`, `isolation`, and `groove`, with transition/setup concepts and a `gold` highlight flag, while leaving pictogram art and coaching media outside the chart contract unless a narrowly-scoped override proves necessary.

---

### Task 2: Research open-source dance-game equivalents and chart systems for Dance inspiration

**Bead ID:** `aerobeat-docs-rda`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Research open-source or source-available dance-game equivalents that can inform AeroBeat Dance authoring. Prioritize projects inspired by or comparable to Dance Central, Just Dance, rhythm dance games, motion-matching dance games, or choreography-focused rhythm tools. Identify any accessible chart / routine / move data formats we can examine for contract inspiration. Claim bead `aerobeat-docs-rda` on start with `bd update aerobeat-docs-rda --status in_progress --json` and close it on completion with `bd close aerobeat-docs-rda --reason "Open-source dance chart research complete" --json`.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- This plan file
- `docs/architecture/open-source-dance-chart-inspirations.md`

**Status:** ✅ Complete

**Results:** Completed a public open-source/source-available research pass focused on projects with **inspectable routine/chart data**, then separated strong inspirations from weaker/noisier ones.

- **Candidate projects found and assessed:**
  - **OpenDance** (`WodsonKun/OpenDance`) — **source-available / open GitHub repo**. This is the closest public `Just Dance`-style engine analogue found. Its README and loader code show it consumes multiple adjacent authored data families rather than one monolithic chart blob:
    - UbiArt-derived `songdesc`, `musictrack`, `*_tml_dance.dtape.ckd`, karaoke tapes, and optional `mainsequence`
    - Bluestar-derived JSON with `beats`, `lyrics`, `pictos`, and per-coach `*_moves0.json`
    - explicit clip classes such as `PictogramClip`, `MotionClip`, and `GoldEffectClip`
    - **Inspectable format?** **Partially yes.** The engine contract is inspectable and it clearly reveals the schema *shape*, but many concrete routine files are Ubisoft-derived reverse-engineered formats rather than a clean repo-native authoring contract.
    - **Usefulness to AeroBeat:** **Strong** for chart-adjacent timeline separation: move timing, pictograms, lyrics, coach media, and gold/highlight effects should be neighboring authored timelines rather than a single overloaded move record.
  - **Performous + StepMania-family `.sm` ecosystem** (`performous/performous`) — **fully open source**. Performous parses StepMania song/chart files directly; the parser exposes the durable structure clearly:
    - song-level metadata fields like `OFFSET`, `BPMS`, `STOPS`, `TITLE`, `ARTIST`, `MUSIC`, preview start, etc.
    - per-chart `#NOTES` blocks with note type, description, difficulty class, meter, and measure-separated note rows
    - explicit time reconstruction from beat-space and hold-start / hold-end semantics
    - **Inspectable format?** **Yes.** Very inspectable and battle-tested.
    - **Usefulness to AeroBeat:** **Strong** for timing-model lessons, chart-per-difficulty slicing, explicit span semantics, and keeping song timing truth separate from authored playable content.
    - **Caution:** modality mismatch. It is excellent for rhythm timing contract design, weak for full-body choreography semantics.
  - **Dance Dance Convolution** (`chrisdonahue/ddc`) — **open source research code** built on StepMania data. It parses `.sm` files and exports JSON with:
    - `offset`, `bpms`, `stops`
    - per-chart metadata: `type`, `desc_or_author`, `difficulty_coarse`, `difficulty_fine`
    - derived note arrays in beat/time space
    - **Inspectable format?** **Yes.** Not a shipping game format, but very useful as an extraction/normalization example.
    - **Usefulness to AeroBeat:** **Strong** as evidence that a dance/rhythm chart contract benefits from a normalized JSON/YAML layer with canonical timing segments and flattened per-chart metadata.
  - **Rhythm-Dance** (`reakain/Rhythm-Dance`) — **open source prototype** with a small JSON-authored song format:
    - `title`, `bpm`, `source`, `offset`, `player_instrument`
    - `keys[]` mapping instrument-note indices to `move`
    - `player_beats[]` with `note` and absolute `position` in seconds
    - **Inspectable format?** **Yes, fully**, but it is simplistic and still hard-coded to a small input set.
    - **Usefulness to AeroBeat:** **Moderate** for “flat list of timed authored events” simplicity, but **weak** as a full-body dance taxonomy model.
  - **pose-your-dance** (`hsed/pose-your-dance`) — **open source**, but the repo appears to be mostly a PoseNet/TensorFlow.js demo fork rather than a meaningful authored-routine system.
    - **Inspectable format?** **No meaningful chart/routine contract found.**
    - **Usefulness to AeroBeat:** **Weak/noisy**. Good proof that browser pose matching is feasible, not useful as a content-contract model.
  - **dance-with** (`bgb10/dance-with`) — **open source** pose-comparison project using OpenPose/OpenVINO.
    - **Inspectable format?** **No authored chart/routine format.** Focuses on comparing multiple detected skeletons and flagging mismatched limbs.
    - **Usefulness to AeroBeat:** **Weak/noisy** for authoring, potentially relevant later for scoring/feedback ideas.
  - **DanceForm** (`anjalis-ingh/DanceForm`) — **open source** choreography formation/planning tool.
    - **Inspectable format?** Not really in a rhythm-chart sense; it models 2D stage formations, slides, and transitions.
    - **Usefulness to AeroBeat:** **Weak for first-pass chart YAML**, though it may be relevant later for multi-dancer blocking or authoring UI concepts.

- **Strong inspirations vs weak/noisy ones:**
  - **Strongest contract inspirations:**
    1. **OpenDance** for adjacent authored timeline separation (`beats` vs `pictos` vs coach motion vs gold/highlight effects)
    2. **StepMania / Performous / DDC** for a durable timing model, per-chart difficulty slices, and explicit span semantics
    3. **Rhythm-Dance** only as a reminder that very flat event authoring is understandable and easy to tool
  - **Weak / noisy inspirations:** `pose-your-dance`, `dance-with`, `DanceForm` — interesting adjacent tech, but none provide a strong inspectable gameplay chart contract for AeroBeat Dance.

- **Data-shape lessons AeroBeat should borrow:**
  - Keep **song timing truth** separate from **dance chart authored events**. StepMania-family contracts are very strong evidence for `offset` / `bpms` / pauses/stops living outside the per-move event list.
  - Keep **one chart per difficulty / compatibility slice**, not a multi-difficulty megafile.
  - Keep the playable authoring stream **flat and readable**: timed entries with `start`, optional `end`, required move identity, and a small set of qualifiers.
  - Treat **preview/cue systems as adjacent authored or derived data**, not as the core move identifier. OpenDance’s separation of pictograms from motion clips is the best evidence here.
  - Treat **gold/highlight moments as explicit authored markers** rather than runtime-only inference.
  - If AeroBeat later needs multiple authored tracks, the likely neighbors are: core move/pose timing, optional preview/cue timing, optional coaching/media overlays, and optional highlight/special-moment timing.

- **Data-shape lessons AeroBeat should avoid:**
  - Do **not** inherit proprietary Ubisoft file-family names or engine-specific packaging as AeroBeat’s public chart contract.
  - Do **not** overfit the contract to note-lane semantics like DDR arrows; the timing model is useful, but the move vocabulary should stay full-body and choreography-oriented.
  - Do **not** bind move identity to controller or instrument indices like Rhythm-Dance’s `note`/`move` mapping.
  - Do **not** make pictogram asset paths, coach-video file names, or presentation-layer specifics required first-pass chart fields.

- **Short ranked recommendation list:**
  1. **Borrow StepMania-family timing separation and chart-per-difficulty discipline.**
  2. **Borrow OpenDance’s “adjacent timelines” idea** for pictograms/cues, coach motion/media, and gold/special moments.
  3. **Keep AeroBeat’s first-pass Dance YAML flatter and cleaner than either**: one readable authored event list for durable move/pose truth, with optional neighboring metadata only when truly necessary.
  4. **Reserve scoring thresholds and presentation assets for runtime or supporting metadata**, not the durable chart slice itself.

- **Net recommendation for Task 3:** the research does **not** justify a radically different dance-specific container shape yet. The best public evidence still points toward the same flattened authored philosophy as Boxing/Flow, with Dance-specific fields layered in carefully and optional adjacent cue/highlight timelines considered only if one flat `beats:` list becomes too overloaded.

Also added `docs/architecture/open-source-dance-chart-inspirations.md` as a concise reference note for the next planning step.

---

### Task 3: Inspect JustDanceTools for OpenDance-adjacent file families and authoring artifacts

**Bead ID:** `aerobeat-docs-2ab`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Inspect `WodsonKun/JustDanceTools` to understand the real file families, transforms, and authoring artifacts surrounding OpenDance-style content. Focus on which song/routine-related file types are manipulated, whether any example outputs or fixtures exist, and what that implies about the de facto chart/routine system OpenDance users likely rely on outside the engine repo. Claim bead `aerobeat-docs-2ab` on start with `bd update aerobeat-docs-2ab --status in_progress --json` and close it on completion with `bd close aerobeat-docs-2ab --reason "JustDanceTools inspection complete" --json`.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- This plan file
- `docs/architecture/justdancetools-open-dance-ecosystem.md`

**Status:** ✅ Complete

**Results:** Completed a grounded inspection of `WodsonKun/JustDanceTools` using the repo structure, tool READMEs, and the authoring/conversion scripts themselves. Key findings for Derrick:

- **The practical ecosystem around OpenDance-style content is a multi-file routine package, not a single chart blob.** The repo’s tools revolve around:
  - a **main song JSON** carrying metadata plus `beats`, `lyrics`, `pictos`, preview data, and timing offsets
  - **per-coach move JSONs** such as `*_moves0.json` through `*_moves3.json`
  - generated UbiArt runtime files: `songdesc.tpl.ckd`, `*_musictrack.tpl.ckd`, `*_tml_karaoke.ktape.ckd`, `*_tml_dance.dtape.ckd`, and `*_mainsequence.tape.ckd`
  - neighboring authored assets/folders for `timeline/moves/` (`.msm`, sometimes `.gesture`), `timeline/pictos/`, menu/coach phone art, and converted audio
- **Most inspectable intermediate data shape in the repo:** `JSONCreationTool` and `JSONFixer` expose the clearest author-facing JSON families.
  - lyrics are authored as entries like `{time, duration, text, isLineEnding}`
  - pictos are authored as `{time, duration, name}`
  - moves are authored as `{name, time, duration}` with optional `goldMove`
  - the main JSON also carries fields like `MapName`, `Artist`, `Title`, `Credits`, `NumCoach`, `lyricsColor`, `videoOffset`, `beats`, `AudioPreview`, and `AudioPreviewFadeTime`
- **`Woody's JSON2DTAPE` confirms how the de facto routine gets assembled.** It reads the main JSON plus separate per-coach move JSONs and emits runtime clip families:
  - `KaraokeClip` from lyric timing/text
  - `MotionClip` from move lists, with `ClassifierPath`, `CoachId`, `MoveType`, and optional `GoldMove`
  - `PictogramClip` from picto timing/name
  - `GoldEffectClip` as a separate explicit authored highlight lane
  - `MusicTrack` data from beat/preview metadata
  This is strong evidence that the surrounding routine system is **split by adjacent timelines** rather than encoded as one overloaded choreography record.
- **Gestures are first-class in some conversion flows.** `Next2UAF` generates `.gesture` files alongside `.msm` move classifiers and writes them into per-platform gesture folders (`durango`, `x360`, `orbis`). That suggests the ecosystem distinguishes between normal moves and gesture-classified inputs, though exactly how OpenDance consumes those may still depend on engine/runtime details.
- **Pictograms and media are explicitly tooled, but mostly as neighboring assets rather than core move identity.** The tools extract/resize pictogram images, point DTAPE `PictogramClip` records at `timeline/pictos/*.tga`, and convert audio/menu-media assets separately. This reinforces the earlier recommendation that preview/cue assets should stay adjacent to core authored move truth.
- **Songdesc/musictrack/karaoke/dtape/mainsequence are all actively targeted.** This repo does not just mention these families in passing; it generates, fixes, deserializes, or converts them. So if OpenDance itself lacks friendly examples, these files are still the de facto package shape modders appear to prepare externally.
- **Example outputs / fixtures:** the repo does **not** ship a clean end-to-end sample routine package or lots of screenshots. However, it does contain enough schema-bearing artifacts to inspect shape directly:
  - `NextSongDB.json` and `PlusSongDB.json` expose real metadata fields used to fill `songdesc`/preview values
  - the conversion code shows exact output path conventions and clip field names
  - `MainsequenceDeserializer` and `DeserializerSuite` reveal additional clip classes present in older/adjacent UbiArt files
- **Grounded implication for AeroBeat:** this research gives us **better adjacent-timeline clues than move-taxonomy clues**. It sharpens the case that dance authoring naturally separates into song timing, lyrics/karaoke, pictos/cues, per-coach move spans, and highlight/gold events. But it does **not** provide a friendly public high-level “dance chart schema” beyond those intermediate JSON fragments and generated tape/template outputs.
- **Net recommendation for Task 4:** keep AeroBeat’s first-pass Dance contract human-readable and flatter than the Just Dance/OpenDance toolchain, but preserve the same conceptual separation: core move/pose timing as the durable chart truth, with optional neighboring metadata/timelines for pictograms, lyrics/cues, coach presentation, and gold/highlight moments.

Also added `docs/architecture/justdancetools-open-dance-ecosystem.md` as a concise reference note for the next shape-proposal step.

---

### Task 4: Research external motion/classifier asset locations and data shapes in Just Dance/OpenDance tooling

**Bead ID:** `aerobeat-docs-cm3`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Research where the external motion/classifier assets actually live in the Just Dance/OpenDance-style ecosystem and what their data types/shapes look like. Focus on `.msm`, `.gesture`, motion clip references, coach move assets, and any inspectable paths/fields that show how named moves become runtime-interpretable assets. Claim bead `aerobeat-docs-cm3` on start with `bd update aerobeat-docs-cm3 --status in_progress --json` and close it on completion with `bd close aerobeat-docs-cm3 --reason "Motion/classifier asset research complete" --json`.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- This plan file
- `docs/architecture/dance-motion-classifier-asset-resolution.md`

**Status:** ✅ Complete

**Results:** Completed a targeted asset-resolution pass across public OpenDance and JustDanceTools code plus adjacent modding tools. The important answer is now clearer: **a named dance move usually resolves to an external classifier file under the song/map’s `timeline/moves/` folder, not to inline chart data.**

- **Most direct resolution path found (inspectable):**
  - In OpenDance’s Bluestar path, the runtime loads `*_moves0.json`, then when a move triggers it resolves `currentMove.name` to `opendance_data/mapdata/<Song>/timeline/moves/<move>.msm` via `read_msm_file(...)`.
  - In JustDanceTools DTAPE generation, each `MotionClip` is emitted with `ClassifierPath: "world/maps/<map>/timeline/moves/<move>.msm"`, `CoachId`, `MoveType: 0`, and optional `GoldMove`.
  - For gesture/camera-style entries, public tooling emits `MotionClip` with `MoveType: 1` and `ClassifierPath` ending in `.gesture` instead of `.msm`.
- **What `.msm` appears to be (directly inspectable):**
  - OpenDance ships a reverse-engineered `.msm` reader with named fields: `endianess`, `version`, `move_name`, `song_name`, `classifier_type`, `duration`, `low_threshold`, `high_threshold`, `autocorr_threshold`, `direction_impact`, `measures_bitfield`, `measure_value`, `measure_count`, `energy_measure_count`, `custom_flags`, plus a trailing float `measures[]` payload.
  - OpenDance’s scoring code uses that `measures[]` payload as reference classifier features and compares player accelerometer-derived features against it, mapping distance through `low_threshold` / `high_threshold` into a score. So `.msm` is not an animation clip; it is a motion-scoring classifier blob with metadata + numeric reference features.
- **What `.gesture` appears to be (partly inspectable, partly inferred):**
  - Public deserializer/conversion tools clearly treat `.gesture` as a sibling classifier asset referenced by `MotionClip.ClassifierPath` with `MoveType: 1`.
  - `Next2UAF` also creates per-platform gesture outputs under `gestures/durango`, `gestures/x360`, and `gestures/orbis`, sometimes by copying a generic placeholder gesture file. That is direct evidence that gesture assets are packaged separately from `.msm` files and may have platform-specific copies.
  - **What remains unverified:** the underlying binary payload/field structure of `.gesture` itself. In the public material inspected here, we can see how gesture references are listed inside timeline/container data, but we do not have an equivalent runtime parser like the `.msm` reader exposing the internal file schema.
- **Folder/path conventions (direct evidence):**
  - Modern OpenDance/UbiArt-style references converge on `world/maps/<map>/timeline/moves/<name>.(msm|gesture)`.
  - OpenDance’s current included-files manifest lists `.msm` assets under `datafiles/opendance_data/mapdata/<Song>/timeline/moves/`.
  - An older OpenDance alpha used a flatter `datafiles/<Song>/classifiers/` folder, so `timeline/moves/` appears to be the later, closer-to-UbiArt convention.
- **How coach-specific moves are represented:**
  - Coach ownership is carried on the timeline entry (`CoachId`) and on separate per-coach JSON move lists such as `*_moves0.json` through `*_moves3.json`.
  - The classifier files themselves still live in the shared song `timeline/moves/` area rather than obviously separate per-coach classifier directories in the public examples we inspected.
- **So if a chart says “play move X,” what does X resolve to?**
  - In the closest public analogue, `X` resolves first to a timed move entry (`name`, `time`, `duration`, optional `goldMove`, plus coach assignment), then to an external classifier asset path—usually `<song>/timeline/moves/X.msm`, or `.gesture` for gesture/camera scoring. The scoring/runtime layer reads that classifier blob to know what motion pattern to judge.
- **Net guidance for AeroBeat docs:**
  - Treat named moves as identifiers that resolve to **external motion-classifier assets**, not as self-contained chart definitions.
  - Keep cue art/pictograms/media separate from the move identifier.
  - Be explicit that public evidence is strong for `.msm` structure and pathing, but weaker for the internal `.gesture` binary schema.

Also added `docs/architecture/dance-motion-classifier-asset-resolution.md` as a concise reference note for the upcoming shape proposal bead.

---

### Task 5: Propose the first-pass Dance chart authored shape

**Bead ID:** `aerobeat-docs-org`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Using the approved Boxing/Flow contract style plus the researched dance move vocabulary, the open-source dance-game inspiration pass, the JustDanceTools inspection, and the motion/classifier asset research, propose the first-pass authored YAML shape for `feature: dance`. Pressure-test whether Dance should stay on the same flattened `beats:` model or needs a different naming shape such as `moves:`. Recommend required/optional fields, span semantics, special scoring markers such as gold moves, and any validation rules that belong in the authored contract rather than runtime scoring code. Claim bead `aerobeat-docs-org` on start with `bd update aerobeat-docs-org --status in_progress --json` and close it on completion with `bd close aerobeat-docs-org --reason "Shape proposal complete" --json`.

**Folders Created/Deleted/Modified:**
- `.plans/`
- research notes only if needed

**Files Created/Deleted/Modified:**
- This plan file unless separate notes are justified

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 6: Turn the approved Dance contract into docs/examples, then QA and audit

**Bead ID:** `aerobeat-docs-67z`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** After Derrick approves the Dance move taxonomy and the first-pass YAML shape, update the docs/examples accordingly and run the standard coder → QA → auditor loop. Claim bead `aerobeat-docs-67z` on start with `bd update aerobeat-docs-67z --status in_progress --json` and close it when the owning role is complete.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⚠️ Partial / Research slice complete, contract shape deferred to next session

**What We Built:** Completed the research groundwork for the Dance chart YAML slice without locking the authored contract yet. This session produced: (1) a Dance Central ↔ Just Dance move-vocabulary normalization pass, (2) an open-source dance-chart inspiration pass centered on OpenDance plus StepMania-family timing discipline, (3) a JustDanceTools ecosystem inspection showing that the surrounding authoring model is a split routine package rather than one friendly chart file, and (4) a focused motion/classifier asset pass showing that named moves resolve to external `.msm` / `.gesture` classifier assets under shared song-map `timeline/moves/` paths rather than embedding full choreography semantics directly in the chart row.

**Reference Check:** Research phase only; no implementation examples or cross-repo contract/code changes landed yet.

**Commits:**
- Pending

**Lessons Learned:** Dance likely still wants the same flattened outer contract direction as Boxing/Flow, but the deciding design question is now very crisp: whether AeroBeat should store only timed named move spans plus lightweight qualifiers and let a separate move library / classifier layer carry interpretation, or whether it should author a somewhat richer explicit movement-semantic layer than the Just Dance/OpenDance ecosystem does. The external research strongly argues for keeping cue/picto/media/highlight systems adjacent to core move timing rather than stuffing them into the base move row.

---

*Completed on 2026-04-29 (draft for discussion)*
