# Repository Map (The Rigs)

Use this map to route work to the correct repository within the AeroBeat ecosystem.

## Core contract repos

- **[`aerobeat-input-core`](https://github.com/AeroBeat-Workouts/aerobeat-input-core)**: shared gameplay-facing input abstractions, normalized provider payloads, and provider contracts
- **[`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core)**: shared gameplay-mode/runtime-rule contracts
- **[`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core)**: canonical authored-content contracts
- **[`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core)**: shared account-level/avatar/cosmetics/environment asset-side contracts
- **[`aerobeat-ui-core`](https://github.com/AeroBeat-Workouts/aerobeat-ui-core)**: shared UI abstractions, menu-facing interfaces, and base interaction logic
- **[`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core)**: shared tool-side contracts

## Spatial UI ownership split

The audited spatial UI lane is a **small family of repos**, not one catch-all package.

- **`aerobeat-input-core`** owns normalized input/provider contracts that gameplay and UI can both consume.
- **`aerobeat-ui-core`** owns UI-facing contracts and reusable base behavior, but not concrete spatial pointer extraction.
- **`aerobeat-spatial-ui-core`** owns the shared spatial-UI runtime layer: packaged bridge components, resolver-facing glue, and reusable world-space/pointer interaction contracts.
- **`aerobeat-spatial-ui-mouse`** is the first concrete spatial provider lane for desktop pointer input. It packages the mouse-backed implementation that plugs into `aerobeat-spatial-ui-core`.
- **`aerobeat-ui-kit-community`** owns the presentational community widgets and scenes that consume the shared UI contracts; it is not the owner of input extraction or provider-specific pointer logic.

### Resolver flow

The intended packaged flow is:

1. consumer app or shell installs the required addon packages through GodotEnv
2. `aerobeat-ui-core` provides the UI contract surface
3. `aerobeat-spatial-ui-core` provides the resolver/bridge layer that looks up packaged spatial UI implementations
4. a concrete provider package such as `aerobeat-spatial-ui-mouse` supplies the actual pointer extraction/runtime behavior
5. `aerobeat-ui-kit-community` renders the widgets that receive those resolved interactions

This keeps the dependency graph honest: provider-specific extraction ships in explicit packages instead of being hidden in proof-host-only glue.

## Product and implementation repos

### Official current-focus repos

- `aerobeat-assembly-community`
- `aerobeat-docs`
- `aerobeat-feature-boxing`
- `aerobeat-feature-flow`
- `aerobeat-input-mediapipe-python`

### Future-input or future-platform repos still worth preserving

- `aerobeat-input-mediapipe-native`
- `aerobeat-input-gamepad`
- `aerobeat-input-joycon-hid`
- `aerobeat-input-keyboard`
- `aerobeat-input-mouse`
- `aerobeat-input-touch`
- `aerobeat-input-xr`
- `aerobeat-spatial-ui-core`
- `aerobeat-spatial-ui-mouse`
- `aerobeat-ui-shell-mobile-community`
- `aerobeat-ui-shell-web-community`
- `aerobeat-ui-shell-xr-community`

### Shared tool/UI repos

- `aerobeat-tool-api` (shared API-facing tool lane; keep AeroBeat-owned client/integration surfaces here rather than coupling product repos directly to vendor APIs)
- `aerobeat-tool-settings`
- `aerobeat-tool-*` authoring products
- `aerobeat-ui-kit-community`
- `aerobeat-ui-shell-desktop-community`

### Shared environment repos

- `aerobeat-environment-core` (internal environment package family baseline; reusable environment scenes/resources built on `aerobeat-asset-core` rather than a new seventh core lane)
- `aerobeat-environment-loader` (generic runtime environment loader/bridge for official package-facing environment kinds such as image, video, GLB, and controlled splat requests)
- `aerobeat-environment-gaussian-splat` (specialized Gaussian-splat fulfillment/runtime wrapper consumed by the loader or sibling repos that need the lower splat runtime directly)

### Planned UGC/API vendor lane

- `aerobeat-tool-api` remains the AeroBeat-facing Godot-imported API manager singleton lane
- `aerobeat-vendor-modio` is the preferred first provider adapter repo for the current outer-shell path
- product repos should consume `aerobeat-tool-api`, not provider SDK/REST code directly

## Scope note

A repo existing in the ecosystem does **not** mean the feature/input/platform is official v1 product scope. The active product slice is camera-first Boxing + Flow on PC first.

That applies to the spatial UI family too: the audited repo split is worth documenting now, but only the desktop mouse lane is described as a concrete packaged proof path today. Touch and XR stay future-provider lanes until their own repos package and validate those integrations.

This routing map stays focused on active and future-facing lanes. Legacy Dance/Step feature repos are intentionally omitted from the current live map rather than treated as active routing targets.
