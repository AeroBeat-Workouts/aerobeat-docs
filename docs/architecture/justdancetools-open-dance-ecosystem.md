# JustDanceTools and the OpenDance Authoring Ecosystem

This note captures what `WodsonKun/JustDanceTools` reveals about the chart-adjacent assets OpenDance-style content creators appear to prepare outside the engine repo.

## Grounded takeaways

- The surrounding ecosystem is **not one chart file**. The tools revolve around a **bundle of neighboring authoring artifacts**:
  - a main JSON with song metadata, `beats`, `lyrics`, `pictos`, preview info, and timing offsets
  - per-coach move JSONs such as `*_moves0.json` through `*_moves3.json`
  - generated UbiArt runtime files like `songdesc.tpl.ckd`, `*_musictrack.tpl.ckd`, `*_tml_karaoke.ktape.ckd`, `*_tml_dance.dtape.ckd`, and `*_mainsequence.tape.ckd`
  - motion classifiers/assets under `timeline/moves/` (`.msm` and sometimes `.gesture`)
  - pictogram images under `timeline/pictos/` (`.png` inputs transformed to `.tga` runtime paths)
  - song/media/menu assets such as cover/coach phone art and converted audio
- `JSONCreationTool` and `JSONFixer` expose the most inspectable intermediate schema in the repo:
  - lyric entries shaped like `{time, duration, text, isLineEnding}`
  - picto entries shaped like `{time, duration, name}`
  - move entries shaped like `{name, time, duration}` with optional `goldMove`
- `Woody's JSON2DTAPE` shows how those intermediate JSONs become runtime clip families: `MotionClip`, `PictogramClip`, `GoldEffectClip`, and `KaraokeClip`, with coach IDs and timing converted into UbiArt-style tape data.
- `Next2UAF` shows another adjacent route: a higher-level source package with `SongDesc`, `KaraokeData`, `DanceData`, and `MusicTrack` data gets exploded into the same de facto runtime families plus extracted `moves/`, `gestures/`, and `pictos/` folders.
- The repo contains **very little example output art** and no polished sample routine package, but it does contain **real schema-bearing artifacts** (`NextSongDB.json`, `PlusSongDB.json`, tool code, generated path conventions) that reveal the expected data shape.

## Implication for AeroBeat docs

If OpenDance itself does not ship friendly sample routines, JustDanceTools strongly suggests the de facto external authoring model is a **split-timeline routine package**: beats/lyrics/pictos in one song-level JSON, per-coach move lists in separate files, then conversion into engine/runtime-specific tape/template assets. That supports AeroBeat keeping its public chart contract human-readable and flat while treating pictograms, coach media, preview windows, and highlight moments as adjacent timelines rather than stuffing everything into a single move record.
