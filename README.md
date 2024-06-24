# Descent 3 for PortMaster

## Notes
This fork of Descent 3 is tailored to retro handhelds via gl4es and PortMaster. Build instructions can be found at the [fork repository](https://github.com/JeodC/Descent3).

The following patches have been applied to this release:

- Revert the framebuffer object render code (deviate from upstream), which was necessary to make the game render with gl4es
- Load GL functions after context creation, which allows the custom libGL library to be loaded
- Adjust viewport and scissor to automatically scale properly among various resolutions and aspect ratios
- Add PortMaster branding to title screen to differentiate between upstream and other forked builds
- Make mouse cursor invisible in menus in Release builds (still visible and usable in Debug builds)
- Change level select menu to a listbox with pretty names for core levels
- Add pregenerated `.Descent3Registry` and `Pilot.plt` files with default controls using analog joysticks if available and gptokeyb to emulate keyboard presses for buttons

## Installation
Unzip to ports folder e.g. `/roms/ports/`. Purchase the full game from GOG or Steam, or use CD game data patched to v1.4. Then, add the following files to `descent3/gamedata`:

Filelist for full versions:  
├── descent3/gamedata  
│   ├── missions/  
│   │ └── any mission files (`.mn3`) and `d3voice1.hog` and `d3voice2.hog` if they came with your game  
│   ├── movies/  
│   │ └── any movie files (`.mve`) that came with your game. If you have the Linux Steam version, use steamcmd to get the windows movie files  
│   └── d3.hog  
│   └── extra.hog (this may be `merc.hog` depending on the platform you used to purchase the game)  
│   └── extra1.hog
│   └── extra13.hog
│   └── ppics.hog

## Configuration
The included pilot file is tailored to retro handhelds with a combination of joystick and gptokeyb controls, since the port does not use `gamecontrollerdb.txt`. The launchscript selects this pilot file by default, 
but you can modify the name by opening the file in a text editor.

## Default Gameplay Controls
You can use the `D-PAD` buttons in menus to select items and scroll pages.

| Button | Action |
|--|--| 
|A|Primary Fire|
|B|Use Inventory Item|
|X|Secondary Fire|
|Y|Fire Flare|
|L1|Reverse|
|L2|Scroll Primary Weapon|
|L3|Options Menu (Requires a mouse)|
|R1|Accelerate|
|R2|Scroll Secondary Weapon|
|R3|Not Set|
|D-PAD UP|Look Up|
|D-PAD DOWN|Look Down|
|D-PAD LEFT|Turn Left|
|D-PAD RIGHT|Turn Right|
|LEFT ANALOG|Look Around|
|RIGHT ANALOG|Slide Up/Down & Bank Left/Right|
|START|Start / Accept / Enter|
|SELECT|Back / Escape|
|SELECT + Y|Previous Inventory Item|
|SELECT + A|Next Inventory Item|
|SELECT + B|Order Guidebot|
|SELECT + L1|Open Telcom (Briefing and Objectives)|
|SELECT + R1|Save Game|

## Thanks
fpasteau  
InsanityBringer  
Descent Developers Team  
Testers and Devs from the PortMaster Discord  
Outrage Entertainment  
