# Version 2.4

- Removed Mob lighting fix
- Increased frequency of round splits
- Fixed split prints (again)

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
