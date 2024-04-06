# T6-B2OP-PATCH

Patch for playing world record games in Black Ops II Zombies. Made based on community decision to create an official community patch from March 2023. What makes this patch stick out from among countless patches that have come before it, is focus on optimization, stability, and user freedom. Stuff like box or fridge overrides are fully optional and invoked in-game by the players.

Patch has already proved itself in multiple top games, including, but not limited to:
- Town [99](https://www.twitch.tv/videos/1923623612) No Jug WR by Slewya
- Origins [164](https://www.twitch.tv/videos/2007798756) WR by Dxruma
- Buried [255](https://www.twitch.tv/videos/2023305226) WR by Blasteress
- Mob of the Dead [31:09] (https://www.twitch.tv/videos/1918422380) 30sr WR by Becca
- Buried [150](https://www.twitch.tv/videos/1866405878) No Power coop WR by Astrox & Nessquik

# Informations

Please inform me about any issues you may encounter with the patch, so they can be fixed, preferably with decent amount of information in what circumstances an issue occured. The main channel for issues is GitHubs Issues section, although it won't hurt to ask about it on [Discord](https://discord.gg/fDY4VR6rNE) first

I'm currently the sole developer for B2OP, but the person making almost all important decisions is [Astrox](https://twitter.com/lAsTroXl). The best way to talk to both of us about the patch is joining the Discord from the link above and talk in the dedicated B2 section

Before reporting a problem, please check out the FAQ section down below, you may find answers you're looking for there

# Categories

This patch is meant to be used during games of Highrounds, No Powers & Round Speedruns. Below you can see alternatives for other categories

| Category| Patch | Creator | Link |
| --- | --- | --- | --- |
| First Room | B2FR | Zi0 | [GitHub](https://github.com/B2ORG/T6-B2FR-PATCH) |
| EE Speedrun | Easter Egg GSC Timer | HuthTV | [GitHub](https://github.com/HuthTV/BO2-Easter-Egg-GSC-timer) |
| Song Speedruns | B2SONG | Zi0 | [GitHub](https://github.com/B2ORG/T6-B2SONG-PATCH) |

# Installation

Since version 2.0, all scripts that are meant to be used by players are available in [releases](https://github.com/B2ORG/T6-B2OP-PATCH/releases) section. Downloading raw code from code section will not work!

## Plutonium - Modern (R2905 & R3000+)

Download script `b2op-plutonium.gsc` from releases section, and put it in your Plutonium folder, by default it's located in:

```
C:\Users\{your username}\AppData\Local\Plutonium\storage\t6\scripts\zm
```

The appdata directory is hidden by default on windows, in order to access it, press key combination WINDOWS + R on your keyboard and type in `%LOCALAPPDATA%`, press ENTER.

For previous versions, network frame fix script was separate, but now it is built into the patch version for Plutonium (for this reason make sure not to use version for Redacted on Plutonium)

## Redacted LAN

Download script `b2op-redacted.gsc` from releases section, and put it in script folder in your Redacted directory.

```
.\data\scripts
```

## Plutonium - Ancient (r353 and similar)

**DISCLAIMER**

I have found a way of "fixing" the problem with network frame on Ancient Plutonium. In order to do that i had to rework bunch of exising logic, and because of that **I CAN NOT** guarantee the integrity of the game the same way i can with versions for Plutonium and Redacted. Network frame is fixed, but potentially other things are broken. I'm willing to maintain that version if bugs are found, but i very strongly recommend playing on Plutonium R2905 with it's dedicated B2OP version instead.

To install, download `b2op-ancient.zip` from releases section, and inject it the same way as other patches for Ancient. Do note, zip contains a directory structure and filename that you're suppose to inject without changing it, so far people always injected files called `_clientids.gsc`, but in this case it would not work.

Another thing to note, if you ever tried to inject a patch into Ancient, you know it tends to fail at times. With this patch it fails more, it sometimes can take few minutes of attempts to successfully inject.

For solo games only, you can inject `b2op-redacted.gsc` instead (if you change the name to `_clientids.gsc` and create a correct folder structure, using dedicated Ancient version is required only for coop, as that's the scenario in which network frame does not behave properly)

# FAQ

1) My game is restarting automatically, how do i fix it?

- You don't, that's intended behavior of the system that's giving you permaperks to prevent a rare bug where permaperks were not taken away from players sometimes. How it works is you load into the game, each player is scanned for missing permaperks, if anyone is missing something, they're awarded missing permaperks, and then the game will force a restart. After the restart you are free to carry on. Do note, most of the time you are going to lose some of the perks almost instantly, so restarts few minutes in will require the process to repeat. Since version 2.0, if you restart on round 1, the permaperk awarding system will not be initiated to prevent issues like infinite restarts on Tranzit, where players would kill a zombie too fast and game would just keep giving them perma headshot damage back.

2) I put the patch in the right folder but it does not work

- Make sure you downloaded compiled version from [releases](https://github.com/B2ORG/T6-B2OP-PATCH/releases) section (do not download the zip file called Source code, it is added to the release automatically by github and contains raw code, that is not going to work) and that you downloaded the right version for the right launcher. Failing to do so may result in the patch not working at all, or misbehaving, which in some situations can cause your game to not be legit. Always match names of released files with the launcher you're using. Read Installation instructions above.

3) It says the patch gives players first box, which is not legit. How come this patch is deemed an official patch for BO2 records?

- That's because in order for weapons in the box to be changed, you have to explicitly execute the right command (or chat message, details below in [Overriding box location](#overriding-box-location) section). If you don't do that, the box will remain untouched.

4) Is there anything i need to worry about regarding legitimacy of my game while using this patch?

- Do not use First Box or Box Location modifiers while playing Highrounds, those are OK only for round speedruns (and other categories that explicitly allow it). Make sure you're using the correct version of the patch in relation to your launcher (for example, Redacted version will not fix Network Frame problem on Plutonium, etc.). Also do not use this patch for categories it's not meant for. I've linked alternatives to other categories in a table above in [Categories](#categories) section

5) I heard this patch may cause early errors

- B2OP was built with optimizations for this kind of things in mind. But yes, technically any patch you load (even something so simple that has 5 lines of code and does only one thing) is an additional overhead for the game. From what we've seen so far from players using it, the patch does not directly contribute to any errors. One thing i can recommend is disabling HUD elements, because from what we've been able to measure, that has the biggest overhead from all of the things this patch does. See [HUD](#hud) section to check how to do that

6) Why version for Ancient is so different

- This is a big topic and there is gonna be a video about it, but long story short, in order to fix flawed behavior of something called "network frame", it is required to inject a very particular file that constains the logic for that functionality. Unfortunately it also contains bunch of other things that i also had to include (and modify due to limitations of the compiler that works with Ancient). That's why it is essential to use the exact folder structure and filename i provide in the zip file.

# Steps for basic troubleshooting

- Make sure you're using correct and up to date version and that the downloaded file is compiled (open in Notepad, if it's bunch of gibbrish, you know it's compiled)
- Remove other patches. B2OP Plugins should not cause any issues, but if you are using any, for the sake of troubleshooting remove them as well.
- Check if the directory the patch is in is correct. Perhaps you have multiple instances of Plutonium or Redacted and you put it in the directory belonging to another instance.

# Features

Features in B2OP patch

## List of the patch features

- Basic anticheat capabilities (DVARs, Box etc.)
- Automatic permaperks assignment (consistent with in-game logic)
- Full bank
- Fixed strafe & backwards speed (but can be reverted by setting `steam_backspeed` to 1 and restarting)
- Fixed traps & JetGun (disabled for maps that don't need it)
- Toogleable game / round timers
- Toogleable hud counting buildables
- Toogleable prints with time splits for key rounds
- Optional box override (First Box patch)
- Optional fridge override
- Disabled DOF (Depth of Field)

# HUD

All HUD elements are toogleable (with the exception of watermarks), below is the table with DVARs that can be used to hide and show them. Change DVAR state by invoking the in-game command line (`~` button by default), enter name of the DVAR and value following the spacebar. Do note, disabling hud elements reduces the overhead the patch has over the game, so if you're a fan of optimizations, toggle all of these off by pasting following line into your console

```
timers 0;splits 0;buildables 0
```

| HUD element | DVAR | Default |
| --- | --- | --- |
| Timers | `timers` 0/1 | Enabled |
| SPH print | `splits` 0/1 | Enabled |
| Buildables HUD | `buildables` 0/1 | Enabled |

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

```
lb dt
```

Exclusively to new Plutonium, players can send a message in the game chat to make the box move, message would be the same as the DVAR change, so for example. To open in-game chat, players have to press `t`.

For example:

```
lb dt
```

## Overriding box weapon

Player is allowed to override weapons in the box until round 11, as long as he would be able to get specified weapon under normal conditions. 

Note, in a coop game there are scenarios where first box could give players guns they shouldn't be getting, players are responsible for using the module responsibly. Here is an [example](https://youtu.be/5Tvlf50d6Ec) of something like this happening.

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

```
fb mk2
```

Similar to box location, there is an exclusive feature for New Plutonium, where players can set weapons in the box via chat messages.

For example:

```
fb mk2
```

Additionally, players can chain multiple weapons via a single message with both methods, following example will yield the first box module triggering 3 times

```
fb mk2|monk|galil
```

## Overriding fridge weapon

Player is allowed to override weapons for himself and his time in the fridge until either round 11 or first use of the fridge. It is not possible to put in a weapon that'd not be possible to put during the normal game.
To override fridge weapon, a DVAR `fridge` has to be set to the right value. 

Values from this DVAR can be seen above (in the [Overriding box weapon](#overriding-box-weapon) section), but in order to put upgraded weapon in the fridge, a `+` has to be added in front of the weapon key.

Example for normal weapon:

```
fridge m16
```

Example for upgraded weapon:

```
fridge +m16
```

Exclusively to New Plutonium, fridge can be set using chat commands, and using this feature players can set weapons individially.

Example of player setting weapon for himself:

```
fridge m16
```

Example of player setting upgraded weapon for himself:

```
fridge +m16
```

Example of player setting weapons for everyone (host only):

```
fridge all m16
```

Example of player setting upgraded weapons for everyone (host only):

```
fridge all +m16
```

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
| Better Box | Given only on Die Rise and Buried. Taken away on Tranzit. Will be forcibly taken away if First Box is used |
| Cash Back | - |
| Sniper Points | - |
| Insta Kill | - |
| Pistol Points | - |
| Double Points | - |

Players are always recommended to restart the game after being given perma perks, restart is done automatically when situation allows for it, otherwise players have to `map_restart` manually (the game will end automatically).

# Contributions

If you'd like to contribute to the code, please fork this repository, apply changes / fixes and open a pull request. If the change is in line with rules and the purpose of this patch, it'll be merged and a new version of the patch will be released.

Since version 2.0, it's become a bit harder to work on the patch (natural progression i suppose), following things are required:

- [Python](https://www.python.org/downloads/windows/) 3.10 or newer (recommended 3.12)
- [gsc-tool](https://github.com/xensik/gsc-tool/releases) 1.4.0 or newer

Install Python (and make sure to check adding it to the system PATH while doing so). Download gsc-tool, do not change the name of the program. For Irony, leave both filenames as they are on the cloud. Put everything in the patch main directory.

After applying desired changes, run script `compile.py` while in the patch main directory (press on address bar in the folder view, put `cmd` and press enter. A command line will open with that folder already set). Run script by putting in `python compile.py`. If you did everything right, script should compile everything for you and put stuff in right folders.

Please note, as the modding scene for BO2 is still very young, stuff and tech is changing rapidly. Above description may not always be up to date, but i will try to not let that happen too often.

# B2 Extensions

THIS IS FOR ADVANCED USERS ONLY. The patch has few handles for external GSC scripts than can be used to modify certain behaviours in a controlled environment. Examples of such modification can be found in the [B2 Extensions repository](https://github.com/B2ORG/T6-B2EXTENSIONS) alongside further instructions
