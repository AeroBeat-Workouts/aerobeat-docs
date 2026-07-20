# Content Lane Implementation Phases

!!! warning "Superseded transition-era planning packet"
    This page is preserved only as a historical planning artifact. It should **not** be read as the current AeroBeat repo, package, or execution truth.

    Use these pages for current truth instead:

    - [Architecture Overview](overview.md)
    - [Content Repo Shapes](content-repo-shapes.md)
    - [Workout Package Storage and Discovery](workout-package-storage-and-discovery.md)
    - [BeatSaver Flow v1 Conversion](beatsaver-flow-v1-conversion.md)
    - [BeatSaver Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)

## Why this page was superseded

This packet came from an earlier architecture phase that assumed a broader six-core rollout sequence and older package/content boundaries than the current BeatSaver-powered imported-player direction.

The old version read too much like an active delivery plan:

- it treated the content lane rollout as a live current execution sequence
- it predated the later package simplification and imported-player cleanup work
- it was written before the current Flow and Boxing conversion contracts were documented in their own canonical pages

Derrick's current direction is to remove or strongly demote stale planning packets instead of letting them masquerade as live truth. This page now preserves only the durable historical takeaways.

## Historical takeaways still worth preserving

These planning principles were useful and still explain some repo-shape decisions, even though the original phase plan is no longer the active roadmap:

1. **Contracts before tooling and runtime**
   - durable content/data contracts should be stabilized before downstream tools or runtime consumers start forking their own versions

2. **Shared contract ownership matters**
   - cross-cutting content/package truth should live in the contract-owning lane rather than in feature repos or tool repos that merely consume it

3. **Structural validation and runtime semantics are different seams**
   - shared structural validation belongs near the contract layer
   - feature-specific semantic validation belongs with the consuming feature/runtime lane

4. **Do not let tooling become schema truth**
   - authoring/import tools should consume canonical contracts rather than redefine them locally

5. **Runtime presentation is not package-contract ownership**
   - gameplay/runtime visuals and interpretation belong in runtime-facing repos, not in the content contract just because they consume the same data

## What changed later

Later AeroBeat planning and docs work narrowed and clarified the real current direction:

- the imported-player path was simplified around BeatSaver-derived Flow and Boxing conversion
- old portal/coaching/environment-heavy package assumptions were removed from current default truth
- current Flow and Boxing behavior now live in dedicated canonical conversion docs instead of in this broad phase packet
- current repo/package expectations are documented in the architecture pages linked above

## Historical status

Keep this file only as a reference for how the earlier content-lane rollout was being staged. Do **not** use it as an execution checklist or architecture source of truth for new work.
