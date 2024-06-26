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
- Prefill savegame dialog with current level number if blank slot or different level than existing slot

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

You can also edit the `.Descent3Registry` file in a text editor. The below table describes some of the relevant values and how to modify them.

|Key|Description|
|---|---|
|RS_gamma|The gamma value, defaults to 1.5. Increasing it will increase brightness.|
|SND_mastervol|Sound effect volume.|
|MUS_mastervol|Music volume.|
|RS_pixelerror|Terrain pixel error. Lowering it can increase performance.|
|RS_terraindist|Render distance. Should usually be 200.000000.|
|Dynamic_Lighting|Boolean value. Turns dynamic lighting on or off.|
|Lighting_on|Boolean value. Turns mine lighting on or off.|
|TerrLeveling|Use 0 for off, 1 for medium, 2 for high.|
|RoomLeveling|Use 0 for off, 1 for medium, 2 for high.|
|Specmapping|Boolean value. Turns specular mapping on or off.|
|FastHeadlight|Boolean value. Turns fast headlight on or off.|
|MirrorSurfaces|Boolean value. Turns mirrored surfaces on or off.|
|MissileView|Boolean value. Turns guided missile view on or off.|
|RS_vsync|Boolean value. Turns vsync on or off.|
|DetailScorchMarks|Boolean value. Turns scorch marks on or off.|
|DetailWeaponCoronas|Boolean value. Turns weapon coronas on or off.|
|DetailFog|Boolean value. Turns fog on or off.|
|DetailCoronas|Boolean value. Turns coronas on or off.|
|DetailProcedurals|Boolean value. Turns procedural textures on or off.|
|DetailObjectComp|0 for low, 1 for medium, 2 for high.|
|DetailPowerupHalos|Boolean value. Turns powerup halos on or off.|
|RS_resolution|Leave this at 1, the scaling depends on it.|
|RS_bitdepth|Can be 10 for 16-bit, or 20 for 32-bit color depth.|
|RS_bilear|Boolean value. Turns bilinear filtering on or off.|
|RS_mipping|Boolean value. Turns mipmapping on or off.|
|RS_color_model|Do lighting based on none (0), intensity (1) or RGB (2).|
|RS_light|Can be 0 for off, 1 for basic shading, 2 for smooth shading.|
|RS_texture_quality|0 for low, 1 for medium, 2 for high.|
|VoicePowerup|Boolean value, can be 0 or 1.|
|VoiceAll|Boolean value, can be 0 or 1.|
|EnableJoystickFF|Boolean value. Turns force feedback on or off.|
|ForceFeedbackAutoCenter|Boolean value. Turns force feedback auto center on or off.|
|ForceFeedbackGain|Adjust as needed.|
|SoundQuality|0 for low, 2 for medium, 3 for high.|
|SoundQuantity|The max quantity of sfx allowed to play at once. Ranges from 20-40. If modified, convert decimal number to dword.|

## Default Gameplay Controls
You can use the `D-PAD` buttons in menus to select items and scroll pages.

| Button | Action |
|--|--| 
|A|Primary Fire|
|B|Use Inventory Item|
|X|Secondary Fire|
|Y|Fire Flare|
|L1|Reverse|
|R1|Accelerate|
|L2|Scroll Primary Weapon|
|R2|Scroll Secondary Weapon|
|L3|Options Menu (Requires a mouse and Debug build)|
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
|SELECT + B|Guidebot Menu|
|SELECT + X|Use Afterburner|
|SELECT + L1|Open Telcom (Briefing and Objectives)|
|SELECT + L2|Load Game|
|SELECT + R1|Toggle Headlight|
|SELECT + R2|Save Game|

## Thanks
fpasteau  
InsanityBringer  
Descent Developers Team  
Testers and Devs from the PortMaster Discord  
Outrage Entertainment  
