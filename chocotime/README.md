# Chocotime Addon

**Chocotime** is an Ashita v3 addon that displays Vana'diel moon phase information on screen for Final Fantasy XI.

## Installation
1. Place `chocotime.lua`, `vanatime.lua`, and `moon_phases.lua` in `Ashita/addons/chocotime/`.
2. Load the addon in-game using `/addon load chocotime`.
   
## In-Game Commands
- `/chocotime visible` - Toggles the visibility of the display.
- `/chocotime blink` - Temporarily shows the display for 10 seconds.

## Notes
- The repository includes the `VDI_Get_Moons.ps1` PowerShell script. **This file is not required for the addon to run.**
- `VDI_Get_Moons.ps1` was created as a precursor to the Lua implementation since the author is more experienced in PowerShell.
- The logic, including the `$moonphases` powershell object and logic, was created by the author of this addon.
- The logic from `VDI_Get_Moons.ps1` was then converted into lua for `chocotime.lua`
- The `Vanatime.lua` library was not created by the author of chocotime.  

## Credits
- Chocotime Author: EdenXI Lover
- Version: 1.1
- Thank you to whoever created `vanatime.lua`.  It made this addon much easier to create.
