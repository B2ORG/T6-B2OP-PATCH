# Version 1.1

- Restricted trap fix to only apply on maps that it is needed on (to prevent issues with Frozen rounds on Origins)

# Version 1.2

- Permaperks
    * Fixed assignment logic for launchers using Irony compiler (Redacted & Ancient)
    * Autorestart is no longer forced on launchers using Irony and New Pluto solo
    * Added Cash Back & Teddy permaperks to assignment sequence
- Info messages are no longer affected by playernames containing color codes

# Version 1.3

- Permaperks
    * Added sniper points to award sequence
    * Added pistol points to award sequence
    * Added instakill to award sequence
    * Added double points to award sequence

# Version 1.4

- Watermarks refactor - watermarks now align horizontally. Introduced temporal watermarks that dissapear after X amount of time (to address users complaining about First Box watermark being permanent, it will now dissapear at the end of round 19)
- Fixed moving box locations with DVAR method

# Version 1.5

- Players can no longer move after safety from using conflicting patches triggered end game
- Patch now actively removes minijug after round 15 instead of only on connect
- Restored restart enforcement (at least for now) after permaperk award
- Added handle for splits plugin + created a template
