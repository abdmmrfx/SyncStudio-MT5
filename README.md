# SyncStudio-MT5

> A modern, open-source synchronization framework for **MetaTrader 5**.

SyncStudio is **not** just another MT5 indicator or Expert Advisor. Its
goal is to become a modular synchronization engine that allows multiple
charts to behave as a single coordinated workspace.

## Vision

> **Engine first. Features second.**

Build a clean, maintainable architecture before adding features.

## Roadmap

### Sprint 1 -- Foundation

-   Core state engine
-   Packet definition
-   Transport layer
-   Marker engine
-   Renderer
-   Controller

### Sprint 2

-   Smooth marker rendering
-   Adaptive update loop
-   Scroll synchronization
-   Zoom synchronization

### Sprint 3

-   Drawing synchronization
-   Trend lines
-   Rectangles
-   Fibonacci tools

### Future

-   Indicator synchronization
-   Symbol synchronization
-   Layout synchronization
-   Replay synchronization
-   Workspace management

## Project Structure

``` text
Source/
├── ChartSyncEA.mq5
├── Core/
├── Graphics/
├── Sync/
└── Utils/
```

## Design Principles

-   Engine first, features second.
-   One class, one responsibility.
-   Modular architecture.
-   Measure performance; don't guess.
-   Small, readable source files.

## Branch Strategy

``` text
main
└── develop
    ├── feature/state-engine
    ├── feature/transport
    ├── feature/marker
    ├── feature/renderer
    ├── feature/controller
    └── feature/logger
```

## Coding Standards

-   Conventional Commits.
-   Keep functions small.
-   Prefer composition over global state.
-   One Pull Request per feature branch.

## Long-Term Goal

Build the synchronization framework that MetaTrader 5 has always been
missing: - Marker sync - Scroll sync - Zoom sync - Drawing sync -
Indicator sync - Layout sync
