# Feature Development Guide

This guide is for gameplay engineers building AeroBeat features.

## Current product focus

The active product slice is centered on:

- **Boxing**
- **Flow**
- **camera-first gameplay**

The architecture may still support future features later, but feature-development docs should not imply Dance or Step are active product modes today.

## What a feature owns

A feature is a self-contained library that provides:

1. gameplay logic
2. stable runtime/view-facing scenes or resources
3. choreography parsing for that feature's authored charts

It does **not** provide main-menu UI, hardware input providers, or player-profile storage.

## Stability rule

Feature-facing contracts should stay stable enough that downstream visuals and tooling do not break when implementation details change.
