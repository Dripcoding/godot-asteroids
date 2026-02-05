# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a classic Asteroids arcade game clone built with **Godot 4.5** using **GDScript**.

## Running the Game

```bash
# Run from command line (Godot must be in PATH)
godot --path . --play

# Or open project.godot in Godot Editor and press F5
```

No build step required - Godot compiles GDScript at runtime.

## Architecture

**Scene-based structure with 4 core scripts:**

- `game.gd` - Main game manager. Controls game state, UI updates (score, health display), and connects player signals.
- `player.gd` - CharacterBody2D controller. Handles movement, rotation, shooting, screen wrapping, and damage. Emits `health_depleted` and `damage_taken` signals.
- `asteroid.gd` - Area2D enemy. Handles collision with player (deals damage) and lasers (takes damage).
- `laser.gd` - Area2D projectile. Moves forward, auto-destroys off-screen.

**Scene hierarchy:**
```
game.tscn (main scene)
├── UI (CanvasLayer) - Score label, health icons
├── Player (instance of player.tscn)
└── Asteroid (instance of asteroid.tscn)
```

**Input actions** (defined in project.godot):
- Movement: `up`, `down`, `left`, `right` (WASD or Arrow keys)
- Shoot: `shoot` (Space)

## Code Conventions

- Use `%NodeName` syntax for unique node references (e.g., `%Player`, `%ScoreLabel`)
- Signals connect in scene files or via `connect()` in `_ready()`
- Use `queue_free()` for cleanup
- CharacterBody2D for physics-based entities, Area2D for collision detection only
- snake_case for variables/signals, PascalCase for class names

## Current State

Implemented: player movement, shooting, asteroid collision, health system, score (time elapsed), screen wrapping.

Not yet implemented: asteroid spawning/waves, asteroid splitting, game over screen, audio, particle effects.
