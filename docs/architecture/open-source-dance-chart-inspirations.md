# Open-Source Dance Chart Inspirations

This note captures the most useful publicly inspectable projects we found while researching AeroBeat Dance chart authoring.

## Strong inspirations

### 1. OpenDance (Just Dance engine recreation)
- **Open source / source-available?** Source-available GitHub repo.
- **Why it matters:** Closest public project to the `Just Dance` presentation/scoring stack we care about.
- **Inspectable routine format?** **Partially.** The repo clearly shows the engine consuming:
  - UbiArt `songdesc`, `musictrack`, `*_tml_dance.dtape.ckd`, karaoke tapes, and `mainsequence`
  - Bluestar JSON with `beats`, `lyrics`, `pictos`, and per-coach `*_moves0.json`
- **What to borrow:**
  - Separate timeline domains for beats, lyrics, pictograms, coach motion, and highlight effects
  - Gold/highlight moments as explicit authored events instead of implicit score-only logic
  - Preview/pictogram data as a neighboring timeline, not baked into the core move identifier itself
- **What to avoid:**
  - Depending on engine-specific reverse-engineered Ubisoft file families as AeroBeat's authored contract
  - Tying authored move semantics directly to proprietary runtime/media packaging

### 2. StepMania / Performous / Dance Dance Convolution ecosystem
- **Open source / source-available?** Yes.
- **Why it matters:** Best public example of a durable rhythm-chart timing contract.
- **Inspectable routine format?** **Yes.** The `.sm` ecosystem is fully parseable and DDC converts it into JSON with:
  - song metadata (`offset`, `bpms`, `stops`)
  - chart metadata (`type`, `difficulty_coarse`, `difficulty_fine`)
  - note events derived into beat/time annotations
- **What to borrow:**
  - Canonical separation between song timing truth and per-chart authored events
  - Explicit support for timing segments (`bpms`, `stops`)
  - Difficulty as chart metadata instead of inline megafile branching
- **What to avoid:**
  - Overfitting AeroBeat Dance to lane/note semantics; these systems are excellent for timing but weak for full-body pose vocabulary

### 3. Rhythm-Dance
- **Open source / source-available?** Yes.
- **Inspectable routine format?** **Yes, but primitive.** Song JSON contains:
  - `title`, `bpm`, `source`, `offset`, `player_instrument`
  - `keys[]` mapping `index` to `move`
  - `player_beats[]` with `note` + `position`
- **What to borrow:**
  - Extremely simple flat event authoring
  - Offset-aware second-based timing in a beginner-friendly format
- **What to avoid:**
  - Binding move identity to instrument-note indices
  - Treating dance as a small fixed button/input map instead of a reusable move taxonomy

## Weak or noisy inspirations

### pose-your-dance
- **Open source / source-available?** Yes.
- **Inspectable routine format?** **No meaningful routine contract found.** The repo is mainly a PoseNet/TensorFlow.js demo fork.
- **Usefulness:** Good proof that browser pose matching is feasible, weak as authored chart-contract inspiration.

### dance-with
- **Open source / source-available?** Yes.
- **Inspectable routine format?** **No real chart/routine format.** Focuses on multi-person pose comparison and error highlighting.
- **Usefulness:** Scoring/pose-analysis inspiration, not chart-authoring inspiration.

### DanceForm
- **Open source / source-available?** Yes.
- **Inspectable routine format?** Not really in rhythm-game terms. It is a formation/planning tool for stage blocking and transitions.
- **Usefulness:** Could inspire future choreography-blocking tools, but not the first-pass gameplay chart YAML.

## Ranked recommendation

1. **Borrow timing/model separation from StepMania-family formats**
2. **Borrow adjacent-timeline thinking from OpenDance** (beats vs pictos vs coach motion vs gold moments)
3. **Keep AeroBeat's move vocabulary higher-level than both**: authored `move` / `pose` semantics should stay human-readable and not collapse into proprietary file families or DDR note strings
4. **Treat preview/cue assets as optional neighboring metadata**, not mandatory core chart fields
5. **Model highlight moments explicitly** (`gold`, hold spans, maybe preview lead-in), but keep scoring thresholds/runtime interpretation outside the durable chart contract
