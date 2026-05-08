# Modding Quickstart Guide

Welcome to the AeroBeat creator community.

## Before you start

Read the [Demo Workout Package Guide](demo_workout_package.md) first. It walks through the current package contract built around:

- `workout.yaml`
- `songs/`
- `charts/`
- `sets/`
- `coaches/coach-config.yaml`
- `environments/`
- example SQL schemas

Then read the [Workout Submission Checklist](workout-submission-checklist.md) before preparing anything for public release.

## Creator lanes in this slice

- musicians create songs
- choreographers create Boxing and Flow charts
- workout authors compose sets and workouts
- coaches create optional coaching content
- environment authors create atmosphere for workouts

## V1 submission checklist

Before public submission in v1, make sure that:

- the package represents **one difficulty only**
- every set has an environment
- the package includes a **thumbnail / cover-art asset**
- coaching is either fully disabled or fully complete
- the package is ready for **public review before release**

If the workout is premium, also make sure that:

- runtime is declared truthfully
- coaching runtime is included when coaching is enabled
- the listed price matches **$1 per 10 minutes, rounded up to the nearest whole dollar**

## Customization note

Older docs talked more heavily about package-local gameplay skins/assets. That is no longer the main package story in this slice. Future customization is more likely to live in controlled avatar/cosmetics systems tied to progression.
