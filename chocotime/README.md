# Chocotime Addon

**Chocotime** is an Ashita v3 addon that displays the Vana'diel time, date, and moon phase information on screen for Final Fantasy XI.

## Features
- Displays Vana'diel time, date, and moon phase.
- Visibility toggle with `/chocotime visible`.
- Blink mode to temporarily show the display with `/chocotime blink`.

## Requirements
- Ashita v4.
- `vanatime.lua` library.
- `moon_phases.lua` data.

## Commands
- `/chocotime visible` - Toggles the visibility of the display.
- `/chocotime blink` - Temporarily shows the display for 10 seconds.

## Installation
1. Place `chocotime.lua`,`vanatime.lua`, and `moon_phases.lua` in `addons/chocotime/`.
2. Load the addon in-game using `!load chocotime`.

## Note
- The repository includes a `VDI_Get_Moons.ps1` PowerShell script. **This file is not required for the addon to run.**
It was created as a precursor to the Lua implementation since the author is more experienced in PowerShell.
The logic, including the $moonphases object, was created by the author of this addon.

## Credits
- Author: EdenXI Lover
- Version: 1.1
