# Chocotime Addon

**Chocotime** is an Ashita v3 addon that displays the Vana'diel moon phase information on screen for Final Fantasy XI.

## Installation
1. Place `chocotime.lua`, `vanatime.lua`, and `moon_phases.lua` in `Ashita/addons/chocotime/`.
2. Load the addon in-game using `/addon load chocotime`.
   
## Commands
- `/chocotime visible` - Toggles the visibility of the display.
- `/chocotime blink` - Temporarily shows the display for 10 seconds.

## Note
- The repository includes a `VDI_Get_Moons.ps1` PowerShell script. **This file is not required for the addon to run.**
- `VDI_Get_Moons.ps1` was created as a precursor to the Lua implementation since the author is more experienced in PowerShell.
- The logic from `VDI_Get_Moons.ps1` was then converted into lua for `chocotime.lua`
- The logic, including the `$moonphases` powershell object and logic, was created by the author of this addon.

## Credits
- Author: EdenXI Lover
- Version: 1.1
