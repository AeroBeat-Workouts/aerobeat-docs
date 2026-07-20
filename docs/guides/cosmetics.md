# Cosmetics

This page is intentionally narrow.

AeroBeat cosmetics are currently documented as a **controlled customization lane**, not as a public mod-pack system.

## Current truth

Use cosmetics wording that stays inside these boundaries:

- cosmetics are presentation-only
- cosmetics do not alter gameplay rules or judged motion
- cosmetics are separate from workout-package authoring
- cosmetics are separate from any old manifest-era mod-pack story

For adjacent current-truth context, see:

- [Account, Identity, and Entitlements](../architecture/account-identity-and-entitlements.md)
- [UGC & Modding Architecture](../architecture/ugc_modding.md)
- [Content Model](../architecture/content-model.md)
- [Avatar Creation](avatar_creation.md)

## What counts as a cosmetic

Typical examples:

- hats
- glasses
- masks
- backpacks
- small wearable accessories
- other non-gameplay avatar presentation items

## Non-negotiable rule

**Cosmetics stay cosmetic.**

A cosmetic should never:

- change hit logic
- change chart semantics
- change input validation
- change authored workout compatibility
- require arbitrary runtime scripting or code injection
- hide or block critical workout readability

## Product-direction wording

If another page mentions cosmetics, describe them as one or more of:

- profile-driven customization
- curated or official unlocks
- progression or entitlement-linked presentation items
- controlled avatar-expression features

Do **not** describe them as:

- freeform public manifest-based cosmetic packs
- equal-status public mod SDK surfaces
- package-local gameplay asset swaps as the main creator workflow

## Prototype-safe authoring guidance

Even before the final public contract exists, these constraints are still sensible:

### Geometry

- keep meshes lightweight
- keep silhouettes readable
- use stable pivots/origins for attachment
- author at sane real-world scale

### Materials

- prefer simple performant materials
- keep texture sizes modest
- minimize material count and draw-call overhead

### Attachment behavior

- target stable avatar attachment points
- expect per-avatar fit adjustments
- avoid designs that depend on custom gameplay logic

## What this page intentionally does not define

This page is **not** the place for final public-contract details such as:

- exact package shape
- exact resource class names
- exact socket or bone naming
- uploader/validator UI requirements
- store/economy metadata schema

Those should only be documented when the owning runtime and package contracts are current enough to be trustworthy.

## Bottom line

Cosmetics are a controlled presentation system.

They are **not** the public workout-package contract, and they are **not** evidence that AeroBeat currently ships a broad public mod-loader.
