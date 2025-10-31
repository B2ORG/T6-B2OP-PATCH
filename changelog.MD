# Version 4.2

- Added print with current key setting at the beginning of the game
- Network frame fix now isn't applied on Pluto versions >2905
- Restore change from 3.7 with `ai_corpseCount`, it's now again set to 5
    * For a bit of context, the DVAR game definition does set it to 8, but in another place the game adjusts it to 5 (specifically during the first launch process), so effectively all record games are historically played on 5. This setting will not apply after Plutonium update R5140 as they'll adjust their DVAR logic to this discovery and GSC adjustment won't be necessary.

# Version 4.1

- **[PLUTONIUM ONLY]** Added `key` dvar/chat command for overriding key position
- Moved Origins tank depatch to the main patch file (standalone fix can still be used, check README for more details)
- Fixed a crash related to box tracking on Farm & Depot

# Version 4.0

- Added system for tracking trades on survival maps
- Added UTC timestamp to split print for versions that don't have game identifier
- Added link to WaW communtiy patch to the readme
- Fixed first box module race condition that could cause incorrect behavior
- Fixed first box queue breaking when one of the codes isn't correct
- Deprecated Redacted and Ancient versions
- Changed structure of welcome prints and added bunch of info about game state
- Locked client FPS (it's set to 332, as in-game limiter is highly inaccurate, this allows people to go up to 250 via their own locker, which is currently max fps allowed)
- Anticheat now triggers Plutos cheat state (star) as well as the watermark
- Removed all remaining hooks for B2 extensions
- Added option to define custom splits via text file
- Added viewmodel customization (independend from setting characters, it only changes character hands but allows for use mid game and has no conflicts in coop games)

# Version 3.8

- Add enabling `cg_drawIdentifier` dvar for future Pluto update

# Version 3.7

- Restore correct default value for `ai_corpseCount` dvar

# Version 3.6

- Additional fix to 3.5 change regarding `lb` command adding fire sale to Origins dig spots drop cycle

# Version 3.5

- Changed implementation of the character system (after old one was found to cause issues with some in-game elements, such as Origins challenge crates) and re-enabled it
- Fixed `lb` command adding fire sale to Origins dig spots drop cycle
- Added `kill_hud` dvar to allow for complete removal of all B2 hud for the entire game (details in readme)
- Fixed accuracy of splits (will now show exact time of red round number at any round)

# Version 3.4

- Fixed `fridge` dvar
- Adjusted patch logic to make dvar management comaptibile with Plutonium R4542

# Version 3.3

- Reduced frequency and simplified logic for flashing patch checksums
- Temporarily disabled character system
- Fixed potential logic error when players input incorrect box location for `lb`

# Version 3.2

- Fixed perma jug protection taking the health away alongside the permaperk itself

# Version 3.1

- Fixed various issues related to new character system
- Fixed patch misbehaving after a fast restart (player related functionalities failed to initialize)
- Fixed fridge thread not terminating properly
- Fixed crash on Ancient that happened in coop after permaperks were awarded
- Decreased rate of displaying GSC checksums during early rounds
- Removed the hook for Fridge plugin (it has become the standard for players to just use binds for the `fridge` command)
- Changed fridge logic in DVAR method, it now supports both `fridge` and `fridge all` commands and works same way as chat method
- Added `whoami` chat message listener to show player current preset

# Version 3.0

- Preprocessor directives refactor (not affecting the gameplay directly)
- Improvements to compilation script (not affecting the gameplay directly)
- Patch now shows currently detected Plutonium version on load (may be inaccurate in older Plutonium versions)
- On Plutonium R4516+, the patch no longer applies the trap fix, instead enabling Plutonium fix. For older versions (R2905) the fix is still enabled.
- On Plutonium 4522+, the patch manages automatic display of patch and memory checksums (beginning of the game and end of every even round 20+)
- Added tank prepatch GSC file to the repository `b2op_tomb.gsc`
- Added some optimizations to variable and thread allocations
- Enabled live DVAR protection (similar to B2FR)
- Added new system for setting playable character (check readme for details)

# Version 2.9

- Fixed death machine shortcode `dm`

# Version 2.8

- Fixed patch not working on Redacted

# Version 2.7

- Patch will now attempt to detect usage of the wrong file and inform players about it
- Bank now only fills up at the beginning of the game
- Added explicit removal of RayGun permaperk
- Added platform identifiers to welcome prints
- Various changes to the compilation script and the patch itself for easier development process

# Version 2.6

## Distribution

- [Ancient] Version for Ancient is now compiled with new compiler which *should* remove most of the issues with it.
- [Redacted] Version for Redacted is now distributed as uncompiled code (which simplifies development process). That being said, it is still required to use file from releases.
- [Development] gsc-tool version requirement went up to 1.4.0 + improvements to the compilation script

# Version 2.5

- [Pluto only] Added `scr_skip_devblock` dvar to mitigate dev prints problem in Pluto R3904

# Version 2.4

- Removed Mob lighting fix
- Increased frequency of round splits
- Fixed split prints (again)
- Adjusted weapon verification for first box module in coop
- Added queueing to first box module, multiple guns can be queued now via a single message
- Added separate dvar for toggling splits on and off (`splits` 0/1)
- Changed round timer to appear on screen when lobby timer does (similar to b2fr)

# Version 2.3

- Fixed delayed split prints
- Updated repository url in welcome print

# Version 2.2

- Removed Velocity Meter
- Disabled DOF (visual)

# Version 2.1

- Hud scaling based on Aspect Ratio is now solo only
- It's now possible to turn off backspeed fix by setting dvar `steam_backspeed` to 1 and restarting the match
- Network frame hud used for debugging can now be used in released patch via getting `b2_plugin_network.gsc` plugin
- Added feature from First Room Fix that allows for debugging drops glitching out using console prints via plugin `b2_powerup_tracking.gsc`

# Version 2.0

Major version update

## Changes

- Added mob lighting fix (by [JezuzLizard](https://github.com/JezuzLizard/))
- Fixed an issue that'd cause box location override to not work properly [#5](https://github.com/B2ORG/T6-B2OP-PATCH/issues/5)
- Info about First Box is now displayed alongside splits (watermark remains as it was)
- Prevented infinite restarting on Tranzit if players kill zombie before permaperk function initialize
- Prevented inifnite restarting caused by launching maps in offline mode
- Fixed conflict that caused First Box to misbehave on maps that have permaperks
- Added handling for HUD element alignment on Ultra Wide monitors

## Distribution

- Versions from all launchers will now be available in the release as oppose to having to download code directly from code section, furthermore using uncompiled patch is no longer possible (unless future versions of plutonium add certain features to it's compiler)
- Added back support for Ancient Plutonium (with huge aesterix)

# Version 1.8

- Fixed an error that prevented the patch from being usable on Irony based launchers (Redacted)

# Version 1.7

- Fixed Buildable tracker zeroing after one of the players disconnected from the game
- Removed redundant includes
- Network frame fix - Now network frame fix will create prints about it's presents if used without B2OP

# Version 1.6

- Fixed HUD being cut off on aspect ratios 4:3 5:4 and 16:10
- Fixed HUD plugin causing timer and round timers to overlap
- Fixed patch safety functions not ending the game properly

# Version 1.5

- Players can no longer move after safety from using conflicting patches triggered end game
- Patch now actively removes minijug after round 15 instead of only on connect
- Restored restart enforcement (at least for now) after permaperk award
- Network frame evaluation no longer generates watermark on failure. Instead it checks again next round (effectively if game is on wrong network frame, at the beginning of each round there will be a print about bad network frame)
- Added handle for splits plugin + created a template

# Version 1.4

- Watermarks refactor - watermarks now align horizontally. Introduced temporal watermarks that dissapear after X amount of time (to address users complaining about First Box watermark being permanent, it will now dissapear at the end of round 19)
- Fixed moving box locations with DVAR method

# Version 1.3

- Permaperks
    * Added sniper points to award sequence
    * Added pistol points to award sequence
    * Added instakill to award sequence
    * Added double points to award sequence

# Version 1.2

- Permaperks
    * Fixed assignment logic for launchers using Irony compiler (Redacted & Ancient)
    * Autorestart is no longer forced on launchers using Irony and New Pluto solo
    * Added Cash Back & Teddy permaperks to assignment sequence
- Info messages are no longer affected by playernames containing color codes

# Version 1.1

- Restricted trap fix to only apply on maps that it is needed on (to prevent issues with Frozen rounds on Origins)
