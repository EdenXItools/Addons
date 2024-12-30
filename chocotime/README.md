# Chocotime Addon

**Chocotime** is an Ashita v3 addon that displays Vana'diel moon phase information on screen for Final Fantasy XI.

## Installation
1. Place `chocotime.lua`, `vanatime.lua`, and `moon_phases.lua` in `Ashita/addons/chocotime/`.
2. Load the addon in-game using `/addon load chocotime`.
   
## In-Game Commands
- `/chocotime visible` - Toggles the visibility of the display.
- `/chocotime blink` - Temporarily shows the display for 10 seconds.

## Notes
- The repository includes the `VDI_Get_Moons.ps1` PowerShell script. **This file is NOT required for the addon to run.**
- `VDI_Get_Moons.ps1` was created as a precursor to the Lua implementation since the author is more experienced in PowerShell.
- The logic, including the `$moonphases` powershell object and logic, was created by the author of this addon.
- The logic from `VDI_Get_Moons.ps1` was then converted into lua for `chocotime.lua`
- Chocotime calculates down to the Vana'diel minute, not the second.
  - This results in odd looking decriments to the new moon and next phase timers, decrimenting every 2-3 seconds by 2-3 instead of decrimenting by 1 second every second.
  - This is because one VD minute is 2.4 seconds earth time.
  - It is still 100% accurate based on the VD hh:mm.
  - A future version which calculates down to the VD second (hh:mm:ss) may be possible and would result in a more human friendly/expected timer countdown.
  - If there are a few requests for this, I can look into it.
- This addon was created to be very PC and server friendly.  It is server friendly because it does all the calculation locally, only getting the current VD date/time utilizing vanatime.lua.  It is PC friendly because it executes simple functions, only once per second.  A potato PC would be able to handle this addon easily.
- `VD 1468-07-07 00:00` (yyyy-mm-dd hh:mm Vana'diel time) was used as a basis for calculations.  A vana'diel lunar cycle is 84 days (see credits below for source).  I created a table with information for each of those days which considers day 1 of a lunar cycle to be `Full Moon (90%)`.  `VD 1468-07-07` was known by me to be day 1 (Full Moon 90%) of a cycle.

## Credits
- Chocotime Author: EdenXI Lover
- A huge thank you to atom0s for creating `vanatime.lua` which is utilized by Chocotime!
- https://www.bg-wiki.com/ffxi/Vana%27diel_Time
- https://www.bg-wiki.com/ffxi/Category:Moon_Phase

