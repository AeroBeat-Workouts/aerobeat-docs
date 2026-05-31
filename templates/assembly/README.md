# Assembly Template

This folder is now documentation-only. The canonical assembly template lives here:

- <https://github.com/AeroBeat-Workouts/aerobeat-template-assembly>

## What to do

1. Open the canonical GitHub template repo above.
2. Use GitHub's **Use this template** flow (or clone the repo directly if you are doing template maintenance in the owning repo).
3. Immediately rename placeholder files, classes, autoloads, and stale identifiers before treating the clone as real runtime code.
4. Keep future runnable code changes in the owning template repo, not in `aerobeat-docs`.

## License lane

- **Expected license:** GPLv3

## Notes

- Assembly/game repository starting point.
- If you find stale placeholder names after clone, remove them first. The known example is `AeroToolManager`, which must never survive as the final shipped manager identity in a real tool repo.
