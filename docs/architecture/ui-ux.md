# UI Architecture (Atomic Design)

We utilize a **multi-kit ecosystem** so UI logic, presentation, and spatial interaction packaging can evolve independently. The audited repo split is now explicit: **UI contracts**, **visual kits**, and **spatial interaction providers** do not all live in the same repo.

## 1. UI Core (`aerobeat-ui-core`)

- **Role:** the shared UI contract and base-logic layer.
- **Content:** abstract GDScript classes, menu/view interfaces, reusable base behaviors, and UI-facing globals.
- **Does not own:** concrete spatial pointer extraction, provider-specific mouse/touch/XR glue, or skin-specific visuals.

## 2. Spatial UI Core (`aerobeat-spatial-ui-core`)

- **Role:** the shared helper layer for spatial UI interaction.
- **Content:** reusable helper-layer code under `src/helpers/...`, including spatial surface descriptors, rect-target resolution helpers, projection helpers, and hover/capture policy scaffolding.
- **Goal:** let concrete spatial provider packages share helper infrastructure without turning this repo into a second contract owner or native 2D bridge owner.

## 3. Spatial UI Providers (`aerobeat-spatial-ui-*`)

- **Role:** concrete packaged implementations for spatial interaction sources.
- **Current audited example:** `aerobeat-spatial-ui-mouse`.
- **Responsibility:** translate a concrete source into the existing `aerobeat-input-core` UI interaction contract while reusing helper-layer pieces from `aerobeat-spatial-ui-core` when useful.

Current policy:

- `aerobeat-spatial-ui-mouse` is the concrete desktop pointer lane we can describe today.
- future touch and XR variants should land as their **own provider packages**, not as hidden branches inside the mouse repo and not as undocumented shell glue.

## 4. UI Kits (`aerobeat-ui-kit-*`)

- **Role:** the visual component layer.
- **Current documented package:** `aerobeat-ui-kit-community`.
- **Content:** stateless widgets, scenes, and presentation assets that consume UI contracts.
- **Does not own:** input extraction or provider/runtime bridge logic.

Typical structure:

- **Atoms:** scenes inheriting core logic (for example a button scene extending a base button class)
- **Molecules:** functional groups such as cards or controls
- **Organisms:** larger composed interface sections

## 5. UI Shells (`aerobeat-ui-shell-*`)

- **Role:** the assembler/layout layer.
- **Variants:** `aerobeat-ui-shell-mobile-community`, `aerobeat-ui-shell-desktop-community`, `aerobeat-ui-shell-xr-community`.
- **License:** **GPLv3** because shells include application logic.
- **Responsibility:**
  1. compose the chosen UI kit
  2. arrange components into screens and layouts
  3. wire resolved interaction surfaces into app logic

## Packaged resolver flow

The audited package split implies this runtime flow:

1. the consumer shell installs packaged dependencies through GodotEnv
2. `aerobeat-input-core` supplies the canonical UI interaction contract and native 2D bridge lane
3. `aerobeat-spatial-ui-core` contributes the shared helper-layer pieces a provider can reuse
4. a concrete provider package such as `aerobeat-spatial-ui-mouse` plugs those helpers into real mouse-backed spatial behavior
5. `aerobeat-ui-kit-community` renders the widgets that receive the interaction output
6. the shell wires those widgets into the assembly/runtime

This is the durable architecture boundary to document. It is more precise than implying a monolithic “spatial UI repo” or a proof-host-only implementation.

## Ownership summary

| Concern | Owning repo family |
| :--- | :--- |
| normalized gameplay/provider contracts plus canonical UI interaction contract / native 2D bridge | `aerobeat-input-core` |
| shared menu/UI contracts and base logic | `aerobeat-ui-core` |
| shared spatial helper-layer code | `aerobeat-spatial-ui-core` |
| concrete packaged mouse spatial provider | `aerobeat-spatial-ui-mouse` |
| community visual widgets and scenes | `aerobeat-ui-kit-community` |

## UI dependency rules

To keep UI repositories lightweight and testable, keep these boundaries explicit:

| Dependency Type | Repository | Status | Logic |
| :--- | :--- | :--- | :--- |
| **UI Core** | `aerobeat-ui-core` | **Required** | Shared UI contracts and base behavior. |
| **Spatial UI Core** | `aerobeat-spatial-ui-core` | **Allowed when spatial interaction is needed** | Shared helper layer for world-space or pointer-style UI providers. |
| **Spatial UI Provider** | `aerobeat-spatial-ui-*` | **Optional** | Only install the concrete provider lane the shell/runtime actually needs. |
| **Asset Core** | `aerobeat-asset-core` | **Allowed** | Shared UI-facing asset definitions when a shell or kit needs them. |
| **Component Kit** | `aerobeat-ui-kit-*` | **Required** | Source of buttons, cards, sliders, and standard widgets. |
| **Shared Assets** | `aerobeat-asset-common` | **Allowed** | Fonts, logos, and global icons only. |
| **Vendor Tools** | `aerobeat-vendor-*` | **Dev-only** | Helpers or tooling, not the owner of AeroBeat UI contracts. |
| **Game Content** | `aerobeat-asset-*` | **Forbidden** | UI must not depend on specific level or environment packs. |

## Theming and reskinning strategy

To support white-label partners and distinct platform shells, AeroBeat separates **structure** from **style**.

1. **Multiple kits are allowed.** AeroBeat does not force one global visual identity.
2. **Shared interaction contracts stay shared.** Fixes in `aerobeat-ui-core`, `aerobeat-input-core`, or the helper layer in `aerobeat-spatial-ui-core` should benefit every consuming kit or shell.
3. **Shells choose the package set they need.** A desktop shell may consume the mouse spatial provider; a future touch or XR shell should consume its own provider lane instead of inheriting hidden desktop assumptions.

## UI licensing and assets

- **UI core, spatial UI core, spatial UI providers, and UI kits:** licensed as reusable library/package lanes under **MPL 2.0**.
- **UI shells:** licensed under **GPLv3** because they include application logic.
- **Assets:** visuals used by UI can live inside the owning UI repo when they are kit-specific, or come from shared asset lanes when intentionally shared.

## The UI tier strategy

AeroBeat still does not assume one universal default shell. The assembly defines the product/runtime composition, and the UI tier provides the package set that fits the target platform.

- **Desktop community shell:** may consume the mouse spatial provider for pointer-first menus.
- **Mobile shell:** should use an explicit touch-oriented provider lane when that package exists.
- **XR shell:** should use an explicit XR-oriented provider lane when that package exists.

## Scope note

The existence of spatial UI packages does **not** change the official v1 gameplay statement: camera remains the only official v1 gameplay input. Non-camera spatial packages are valuable for UI navigation, prototyping, and future platform lanes, but the docs should not overclaim gameplay parity for them.
