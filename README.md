# T6-B2OP-PATCH

Patch for playing world record games in Black Ops II Zombies. Made based on community decision to create an official community patch from March 2023.

# Notice

B2OP is new, while it was obviously tested during development, it is yet to be seen if everything works 100% as it should in real life scenarios. Please inform me about any issues you may encounter with the patch, so they can be fixed, preferably with decent amount of information in what circumstances an issue occured.

For additional questions, feel free to join my [Discord](https://discord.gg/fDY4VR6rNE) server and head to section dedicated to B2OP patch when myself or someone qualified can answer them.

# Categories

This patch is meant to be used during games of Highrounds, No Powers & Round Speedruns. Below you can see alternatives for other categories

| Category| Patch | Creator | Link |
| --- | --- | --- | --- |
| First Room | First Room Fix | Zi0 | [GitHub](https://github.com/Zi0MIX/T6-FIRST-ROOM-FIX) |
| EE Speedrun | Easter Egg GSC Timer | HuthTV | [GitHub](https://github.com/HuthTV/BO2-Easter-Egg-GSC-timer) |
| Song Speedruns | Song Auto-Timer | Zi0 | [GitHub](https://github.com/Zi0MIX/T6-SONG-TIMER-PATCH) |

# Installation

## Plutonium - Modern (R2905 & R3000+)

Download the main script from [releases](https://github.com/Zi0MIX/T6-B2OP-PATCH/releases) section, and put it Plutonium script folder

```C:\Users\{your username}\AppData\Local\Plutonium\storage\t6\scripts\zm```

## Plutonium - Ancient (r353 and similar)

Download the `_clientids.gsc` script from [releases](https://github.com/Zi0MIX/T6-B2OP-PATCH/releases) section, and inject it to the game [Video tutorial](https://youtu.be/Qhmful3ZVkE).

## Redacted LAN

Download the raw [.gsc file](https://github.com/Zi0MIX/T6-B2OP-PATCH/blob/main/b2op.gsc) containing the code (make sure it's downloaded from `main` branch), and insert it in Redacted scripts folder

```{path to your redacted}\data\scripts```

# Features

Features in B2OP patch

## List of the patch features

- Basic anticheat capabilities (DVARs, Box etc.)
- Automatic permaperks assignment (consistent with in-game logic)
- Full bank
- Fixed strafe & backwards speed
- Fixed traps & JetGun (disabled for maps that don't need it)
- Toogleable game / round timers
- Toogleable hud counting buildables
- Toogleable prints with time splits for key rounds
- Toogleable velocity meter
- Optional box override (First Box patch)
- Optional fridge override

## Network Frame fix

If you play on Plutonium R2905 (or similar), please use additional script from release section 

```network-frame-fix.gsc```

Which will set the network frame to the right values

# HUD

All HUD elements are toogleable (with the exception of watermarks), below is the table with DVARs that can be used to hide and show them. Change DVAR state by invoking the in-game command line (`~` button by default), enter name of the DVAR and value following the spacebar.

| HUD element | DVAR | Default |
| --- | --- | --- |
| Timers + SPH print | `timers` 0/1 | Enabled |
| Buildables HUD | `buildables` 0/1 | Enabled |
| Velocity meter | `velocity` 0/1 | Disabled |

If you wish to hide all HUD elements, simply paste this line to the console upon loading to the game (you only need to do once per bo2 restart, DVAR state carries over between games)

```timers 0;buildables 0```

# Box / Fridge

This patch has the following capabilites regarding box and fridge:

- Overriding weapon in the box (First Box Patch)
- Overriding starting box location
- Overriding weapon in the fridge (Fridge Patch)

None of the modules specified above will do anything to your game, unless specific actions are taken.

## Overriding box location

Player is allowed to change box location until either round 11 or until box is used.
To change box location, a DVAR `lb` has to be set to the right value. Below is table with values that can be used to set the box.

| Map | DVAR value | Corresponding location |
| --- | --- | --- |
| Town | `dt` | Double Tap cage |
| Town | `qr` | Quick Revive room |
| Nuketown | `yellow` | Behind yellow house |
| Nuketown | `green` | Behind green house |
| Mob of the Dead | `cafe` | Cafeteria |
| Mob of the Dead | `warden` | Warden's Office |
| Origins | `2` | Generator 2 |
| Origins | `3` | Generator 3 |

For example:

```lb dt```

Exclusively to new Plutonium, players can send a message in the game chat to make the box move, message would be the same as the DVAR change, so for example. To open in-game chat, players have to press `t`.

For example:

```lb dt```

## Overriding box weapon

Player is allowed to override weapons in the box until round 11, as long as he would be able to get specified weapon under normal conditions.
Player can still get a teddy bear from the box, despite overriding the weapon. If that happens, weapon has to be set again after box appeared in the new spot.
To set weapon in the box, a DVAR `fb` bas to be set to the right value. Below is table with values that can be used to override weapon. It is also possible to put actual weapon code instead of the key below, assuming players know weapon codes.

| Weapon | DVAR value |
| --- | --- |
| Ballistic Knife | `bk` |
| Blundergat | `blunder` |
| EMP | `emp` |
| Monkeys | `monk` |
| Paralyzer | `paralyzer` |
| RayGun | `mk1` |
| RayGun MK2 | `mk2` |
| Sliquifier | `sliq` |
| Time Bomb | `time` |
| AK47 | `ak47` |
| AK74u | `ak74` |
| AN94 | `an94` |
| B23R (wall) | `b23r` |
| B23R (box) | `b23re` |
| Chicom CQB | `chic` |
| Death Machine | `dm` |
| DSR50 | `dsr` |
| Executioner | `exe` |
| Fal | `fal` |
| Five-Seven | `57` |
| Five-Seven DW | `257` |
| Galil | `galil` |
| HAMR | `hamr` |
| KAP-40 | `kap` |
| KSG | `ksg` |
| LSAT | `lsat` |
| M1216 | `m1216` |
| M1927 | `tommy` |
| M14 | `m14` |
| M16 | `m16` |
| M27 | `m27` |
| M82A1 Barret | `barret` |
| M8A1 | `m8` |
| MG08 | `mg` |
| MP5 | `mp5` |
| MP40 | `mp40` |
| MTAR | `mtar` |
| Olympia | `oly` |
| PDW57 | `pdw` |
| Python | `pyt` |
| Remington 870 | `remington` |
| RNMA | `rnma` |
| RPD | `rpd` |
| RPG | `rpg` |
| Saiga | `s12` |
| Scar | `scar` |
| Skorpion EVO | `evo` |
| SVU AS | `svu` |
| Tommy Gun | `tommy` |
| Type 25 | `type` |
| War Machine | `wm` |

For example:

```fb mk2```

Similar to box location, there is an exclusive feature for New Plutonium, where players can set weapons in the box via chat messages.

For example:

```fb mk2```

## Overriding fridge weapon

Player is allowed to override weapons for himself and his time in the fridge until either round 11 or first use of the fridge. It is not possible to put in a weapon that'd not be possible to put during the normal game.
To override fridge weapon, a DVAR `fridge` has to be set to the right value. 

Values from this DVAR can be seen above (in the `Overriding box weapon` section), but in order to put upgraded weapon in the fridge, a `+` has to be added in front of the weapon key.

Example for normal weapon:

```fridge m16```

Example for upgraded weapon:

```fridge +m16```

Exclusively to New Plutonium, fridge can be set using chat commands, and using this feature players can set weapons individially.

Example of player setting weapon for himself:

```fridge m16```

Example of player setting upgraded weapon for himself:

```fridge +m16```

Example of player setting weapons for everyone (host only):

```fridge all m16```

Example of player setting upgraded weapons for everyone (host only):

```fridge all +m16```

# Permaperks

Patch does award players with permaperks on connect, but only at the beginning of the game. Players joining in progress will not be given any permaperks. Every player joining the game past round 15 will have PermaJug taken away from him.
List of permaperks awarded by B2OP

| Perk | Notes |
| --- | --- |
| Revive | - |
| Better Headshots | - |
| Tombstone | - |
| Mini-Jug | Will not be awarded if game starts past round 15, will also actively be taken from players past round 15 |
| Flopper | Only on Buried |
| Better Box | Given only on Die Rise and Buried. Taken away on Tranzit |
| Cash Back | - |
| Sniper Points | - |

Players are always recommended to restart the game after being given perma perks, but this is no longer enforced since version 1.2
Instead, players are prompted with restart recommendation.
- Solo - Restart is recommended, but realistically error it is meant to prevent doesn't happen on solo.
- Coop (Redacted & Ancient) - Restart is highly recommended, but as restarting on coop on those is not as fast, players can ignore it and play at their own risk of having permaperks not taken away when they should be
- Coop (New Pluto) - Restart is performed automatically, since such functionality is supported by New Plutonium and players don't have to do it manually

# Contribution / Reporting issues

If you wish to contribute to the project with feedback, advice, issue report, please open an issue in the Issues section of this repository.
If you'd like to contribute to the code, please fork this repository, apply changes / fixes and open a pull request. If the change is in line with rules and the purpose of this patch, it'll be merged and a new version of the patch will be released.

# Own additions

THIS IS FOR ADVANCED USERS ONLY. The patch has few handles for external GSC scripts than can be used to modify certain behaviours in a controlled environment. Examples of such modification can be found in the `/plugin_templates` directory in this repository. 
Currently it is possible to:
- Override the behavior of the Fridge controller by providing it with a set of weapons
- Override the character each player is playing with (yes it is possible to duplicate characters, but please note we do not know if doing so isn't contributing to any errors, as certain characters have some special logic related to them on some maps)
- Override the position and color of HUD elements, such as timers.

After editing a template like that, put it in the same folder as the main patch, and if you did everything right, you'll observe changes you applied. Note, for all Plutonium versions (except for the most recent one), a script will have to be compiled before it'll work. That is not the case for Redacted.
