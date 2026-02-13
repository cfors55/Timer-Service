# TimerService (Luau – Roblox)

A strict-typed, lightweight timer management service for Roblox, built with clean OOP structure and delta-time accuracy.

## ⚠️ Server Usage Only

This module does **not** include internal server/client checks.

It is designed to run on the **server**.

---

## Features

- Strict Luau type safety (`--!strict`)
- Service-based architecture
- Per-timer background thread handling
- Accurate time tracking using `os.clock()` delta
- Automatic hour / minute / second breakdown
- Named timer caching system
- `BindableEvent` fired when timer ends
- Safe cleanup with `Destroy()`

---

## Purpose

Using `task.wait(1)` for countdown systems introduces drift and timing inconsistencies.

This service uses delta-time calculations (`os.clock()`) to maintain stable and more precise timing, even under performance fluctuation.

It also keeps things structured:

- Centralized timer cache
- Retrieval by name
- Self-contained timer instances
- Clean object-oriented design

---

## Installation

Place the `TimerService` module inside `ReplicatedStorage` or `ServerScriptService`, then require it:

```lua
local TimerService = require(path.To.TimerService)
