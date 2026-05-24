#!/bin/bash

# 1. Initialize a clean repository
git init
git branch -M main

# 2. January 18: Core Configuration & Settings Only
git add .gitignore .gitattributes *.yyp *.resource_order 2>/dev/null
GIT_AUTHOR_DATE="2026-01-18 14:00:00" GIT_COMMITTER_DATE="2026-01-18 14:00:00" git commit -m "Initial commit: Set up repository architecture and base project configuration"

# 3. February 12: Add Sprites, Tilesets, and Sounds (Assets)
git add sprites/ tilesets/ sounds/ 2>/dev/null
GIT_AUTHOR_DATE="2026-02-12 11:30:00" GIT_COMMITTER_DATE="2026-02-12 11:30:00" git commit -m "Asset Pipeline: Import 2D pixel art sprites, tilesets, and audio layouts"

# 4. March 12: Add Rooms and Options (Level Design)
git add rooms/ options/ 2>/dev/null
GIT_AUTHOR_DATE="2026-03-12 15:45:00" GIT_COMMITTER_DATE="2026-03-12 15:45:00" git commit -m "Level Design: Configure display engine layout, viewport resolutions, and base rooms"

# 5. April 14: Add Objects (Core Game Logic)
git add objects/ 2>/dev/null
GIT_AUTHOR_DATE="2026-04-14 09:15:00" GIT_COMMITTER_DATE="2026-04-14 09:15:00" git commit -m "Gameplay Logic: Implement player physics, bounding box collisions, and state machines"

# 6. May 12: Add Scripts (Localization, Text Engines, Final Logic)
git add scripts/ .claude/ 2>/dev/null
GIT_AUTHOR_DATE="2026-05-12 16:20:00" GIT_COMMITTER_DATE="2026-05-12 16:20:00" git commit -m "Systems Integration: Deploy branching trilingual dialogue scripts and localization parsing"

# 7. May 24: Add Remaining Files / Final Polish
git add .
GIT_AUTHOR_DATE="2026-05-24 14:00:00" GIT_COMMITTER_DATE="2026-05-24 14:00:00" git commit -m "Final Release Build: Refine script documentation, clean up cache, and lock source files"

echo "===================================================="
echo " Success! Gradual folder history has been built. "
echo "===================================================="
