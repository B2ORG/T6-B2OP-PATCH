# T6-B2OP-PATCH

Patch for playing world record games in Black Ops II Zombies. Made based on community decision to create an official community patch from March 2023. What makes this patch stick out from among countless patches that have come before it, is focus on optimization, stability, and user freedom. Stuff like box, fridge overrides or characters are fully optional and invoked in-game by the players.

Patch has already proved itself in multiple top games, including, but not limited to:
- Town [100](https://x.com/Slewya/status/1837385114940022888) No Jug WR by Slewya
- Town [29:14](https://youtu.be/jkJhQG_dsK0) 30sr WR by TheBrokenHead115
- Die Rise [120](https://youtu.be/N0D1UieRNgM) coop WR by Issuez & NoMoleMan
- Mob of the Dead [31:09](https://www.twitch.tv/videos/1918422380) 30sr WR by Becca
- Buried [255](https://www.twitch.tv/videos/2023305226) WR by Blasteress
- Buried [210](https://www.twitch.tv/videos/2241796423) coop WR by Blasteress & notway
- Buried [150](https://www.twitch.tv/videos/1866405878) No Power coop WR by Astrox & Nessquik
- Origins [173](https://www.twitch.tv/videos/2546264620) WR by Vengiix
- Origins [131](https://youtu.be/w2_WvEB6KSs) coop WR by DestroyeR and NoMoleMan

# Informations

Please inform me about any issues you may encounter with the patch, so they can be fixed, preferably with decent amount of information in what circumstances an issue occured. The main channel for issues is GitHubs Issues section, although it won't hurt to ask about it on [Discord](https://discord.gg/fDY4VR6rNE) first

I'm currently the sole developer for B2OP, but the person making almost all important decisions is [Astrox](https://twitter.com/lAsTroXl). The best way to talk to both of us about the patch is joining the Discord from the link above and talk in the dedicated B2 section

Before reporting a problem, please check out the FAQ section down below, you may find answers you're looking for there

[Also check out a B2 website with useful tools and data](https://b2.wtf/)

# Categories

This patch is meant to be used during games of Highrounds, No Powers & Round Speedruns. Below you can see alternatives for other categories

| Category| Patch | Creator | Link |
| --- | --- | --- | --- |
| First Room | B2FR | Zi0 | [GitHub](https://github.com/B2ORG/T6-B2FR-PATCH) |
| EE Speedrun | Easter Egg GSC Timer | HuthTV | [GitHub](https://github.com/HuthTV/BO2-Easter-Egg-GSC-timer) |
| Song Speedruns | B2SONG | Zi0 | [GitHub](https://github.com/B2ORG/T6-B2SONG-PATCH) |

> [!TIP]
> For World at War you can check [Evelyn's community patch](https://gitlab.com/EvelynYuki/WAW-Community-Patch/)

> [!TIP]
> For Black Ops III you can check [oJumpy's community patches](https://steamcommunity.com/profiles/76561199211441639/myworkshopfiles/?appid=311210)

# Installation

Since version 2.0, all scripts that are meant to be used by players are available in [releases](https://github.com/B2ORG/T6-B2OP-PATCH/releases) section. Downloading raw code from code section will not work!

> [!TIP]
> I've created a video on [how to install these patches](https://youtu.be/yjNbmlya6ik) in case instructions here are unclear

> [!WARNING]
> Redacted and Ancient Plutonium versions are now DEPRECATED. It means they're no longer guaranteed to receive new features and in the future I'll stop supporting them completely. Black Ops II is at the stage where by using older launchers for record games is pointless and is reducing the competitive integrity of the community, and maintaining the patch for 4 versions (realistically 2905 is already quite different from live) is an extra overhead.
> End of life time for these versions isn't currently set in stone, from my perspective the sooner the better. Currently planning it for the next major release.

> [!CAUTION]
> Whenever there's a new major patch release (eg. 2.* to 3.0 or 3.* to 4.0), please note that a lot of internal logic changes, therefore stability may not be up to the full standard. While we recommend you update your patch as we fix issues and add new features, we acknowledge increased risk with new major versions, which is why we usually leave most recent release of last major version in releases for some time, so players can access it until new version was battletested and issues have been fixed. We appreciate early adopters, who by reporting any problems help us provide the stable experience.

## Plutonium

Download script `b2op-plutonium.gsc` from releases section, and put it in your Plutonium folder, by default it's located in:

```
%LOCALAPPDATA%\Plutonium\storage\t6\raw\scripts\zm
```

> [!TIP]
> You can press CTRL + R on your keyboard and paste this string there. Assuming you haven't changed any Plutonium paths, directory with scripts should open right away.

> [!WARNING]
> Prior to patch version 4.0, the directory we recommended here was `Plutonium\storage\t6\scripts\zm` (the only difference is that `raw` folder in the middle), you should still use that directory if you want to use the patch in 2905. On modern Plutonium, it is recommended to start using the new location (remove the patch you currently have in the old location and place the updated version in the new directory specified above)

For previous versions, network frame fix script was separate, but now it is built into the patch version for Plutonium (for this reason make sure not to use version for Redacted or Ancient on Plutonium)

## Redacted LAN

Download script `b2op-redacted.gsc` from releases section, and put it in script folder in your Redacted directory.

```
.\data\scripts
```

> [!WARNING]
> Please do not use `fast_restart` on Redacted, as the patch will not load afterwards. It can also cause the game to just crash outright.

## Plutonium - Ancient (r353 and similar)

To install, download `b2op-ancient.zip` from releases section, and inject it the same way as other patches for Ancient. Do note, zip contains a directory structure and filename that you're suppose to inject without changing it, so far people always injected files called `_clientids.gsc`, but in this case it would not work.

> [!CAUTION]
> I have found a way of "fixing" the problem with network frame on Ancient Plutonium. In order to do that i need to ship B2OP for that launcher alongside existing 3arc code, which we obtained by decompiling game scripts. Because of it, they many not 100% reflect the proper game logic, we believe it's accurate but it's only as good as the decompiler. Because of that fact, **I CAN NOT** guarantee the game integrity to the extent i can do that with other versions of this patch, use at your own risk!

> [!TIP]
> Ancient Plutonium injection oftentimes fail, it can sometimes take multiple attempts to successfully inject. A good indicator is, after an injection try to open the console, if it opens the patch has been injected.

## B2OP Features

A high level overview what features are available in each of the versions.

| Feature | Plutonium | Plutonium (2905) | Redacted | Ancient |
| :--- | :---: | :---: | :---: | :---: |
| Plutonium anticheat integration | ✓ | ✗ | ✗ | ✗ |
| Basic anticheat | ✓ | ✓ | ✓ | ✓ |
| Network frame fix | ✓ | ✓ | ✗ | ✓ |
| Automatic Permaperks & Bank | ✓ | ✓ | ✓ | ✓ |
| Backspeed (with option to disable) | ✓ | ✓ | ✓ | ✓ |
| Trap / JetGun fix | ✗ | ✓ | ✓ | ✓ |
| HUD timers | ✓ | ✓ | ✓ | ✓ |
| HUD buildable counter | ✓ | ✓ | ✓ | ✓ |
| HUD visibility toggling | ✓¹ | ✓¹ | ✓¹ | ✓¹ |
| Showing time splits on key rounds | ✓ | ✓ | ✓ | ✓ |
| Customizing key rounds for time splits | ✓¹ | ✗ | ✗ | ✗ |
| First Box (configurable) | ✓ | ✓ | ✓¹ | ✓¹ |
| Fridge weapon (configurable) | ✓ | ✓ | ✓¹ | ✓¹ |
| Characters & Viewmodels (configurable) | ✓ | ✓ | ✓ | ✓ |
| Simple trade tracker | ✓ | ✓ | ✓ | ✓ |
| FPS Limiter | ✓ | ✓ | ✓ | ✓ |
| DOF Disabled | ✓ | ✓ | ✓ | ✓ |

1. Configuration only as host

# Patch checksum

Starting on Plutonium version R4516, the launcher is able to show checksum of each of the patches you have as well as the entire game memory (i'm massively oversimplifying here, geeks give me a break). [Here as an article about what a checksum is](https://www.howtogeek.com/363735/what-is-a-checksum-and-why-should-you-care/). Every file has a different signature, and changing as much as a single letter in the patch changes it's signature entirely.

![checksum example](https://i.imgur.com/3rn7fPP.jpeg)

As you can see on the screenshot above, each of the GSC files you have loaded into the game is listed by the game. Occurance of this data is navigated by `cg_flashScriptHashes` DVAR (do not worry, the patch will set this DVAR for you automatically, no action required).

## Checksum example screenshot breakdown

Line begins with the file descriptor. It'll either be the actual name of the GSC file (in case it's not compiled, which won't be the case for B2OP), or it'll say `(raw (source))` which indicates a precompiled patch (much like B2OP). In the normal circumstances you're expected to have `ranked.gsc` file (which comes with Plutonium) and one compiled patch. Now the checksum you're interested in is the highlighted part in the parenthesis (on that note, checksums on the screenshot are examples, don't use them for any kind of validation). It's a checksum generated by CRC32 algorithm, and is a unique signature of a patch.

## Game memory checksum

Again, i use this term to help people understand the concept, please do not get mad. Those are checksums generated from the game memory and represent the factual state of your game. This is a combination of patches/mods you loaded and internal game stuff. Those can only be generated by the game and whether or not they'll be useful for checking legitimacy is to be seen. They are not part of this screenshot and are managed by a different DVAR `cg_drawChecksums` (also managed by the patch).

## How does B2 ecosystem interact with this new verification process

Checksum of each new B2 patch version will be attached to the release, which will allow you to verify whether a valid patch is used yourself. In terms of what the patch do, it force enables displaying those checksums certain rounds (details on that below). They are only shown for few seconds and not on milestone rounds (to not ruin screenshots etc.)

## How can i use checksums to validate patch in my own or someone elses game

I've [created a tool](https://b2.wtf/gsc/hash) for doing just that, type in the checksum (one highlighted on the screenshot above) and press `Check`. If checksum is registered in the system, you'll see all the relevant details about the file. Altenatively, you can drag the file itself into the page to see it's checksum (and details if the system has them).

## For game verificators

You should expect checksums to be displayed at the end of following rounds (for version 3.3 onwards)

End of 18, 28, 38 onwards up to the end, and additionally

| Type of game | Start of additional displays |
| :--- | :--- |
| Survival Maps Solo | End of .3 rounds from 83 onwards |
| Survival Maps Coop | End of .3 rounds from 73 onwards |
| Survival Maps 3p/4p | End of .3 rounds from 63 onwards |
| Normal Maps Solo | End of .3 rounds from 153 onwards |
| Normal Maps Coop | End of .3 rounds from 103 onwards |
| Normal Maps 3p/4p | End of .3 rounds from 63 onwards |

# FAQ

1) My game is restarting automatically, how do i fix it?

- You don't, that's intended behavior of the system that's giving you permaperks to prevent a rare bug where permaperks were not taken away from players sometimes. How it works is you load into the game, each player is scanned for missing permaperks, if anyone is missing something, they're awarded missing permaperks, and then the game will force a restart. After the restart you are free to carry on. Do note, most of the time you are going to lose some of the perks almost instantly, so restarts few minutes in will require the process to repeat. Since version 2.0, if you restart on round 1, the permaperk awarding system will not be initiated to prevent issues like infinite restarts on Tranzit, where players would kill a zombie too fast and game would just keep giving them perma headshot damage back.

2) I put the patch in the right folder but it does not work

- Make sure you downloaded right version from [releases section](https://github.com/B2ORG/T6-B2OP-PATCH/releases) (do not download the zip file called Source code, it is added to the release automatically by github and contains raw code, that is not going to work). Failing to do so may result in the patch not working at all, or misbehaving, which in some situations can cause your game to not be legit. Always match names of released files with the launcher you're using. Read Installation instructions above.

3) It says the patch gives players first box, which is not legit. How come this patch is deemed an official patch for BO2 records?

- That's because in order for weapons in the box to be changed, you have to explicitly execute the right command (or chat message, details below in [Overriding box location](#overriding-box-location) section). If you don't do that, the box will remain untouched.

4) Is there anything i need to worry about regarding legitimacy of my game while using this patch?

- Do not use First Box or Box Location modifiers while playing Highrounds, those are OK only for round speedruns (and other categories that explicitly allow it). Make sure you're using the correct version of the patch in relation to your launcher (for example, Redacted version will not fix Network Frame problem on Plutonium, etc.). Also do not use this patch for categories it's not meant for. I've linked alternatives to other categories in a table above in [Categories](#categories) section

5) I heard this patch may cause early errors

- B2OP was built with optimizations for this kind of things in mind. But yes, technically any patch you load (even something so simple that has 5 lines of code and does only one thing) is an additional overhead for the game. From what we've seen so far from players using it, the patch does not directly contribute to any errors. One thing i can recommend is disabling HUD elements, because from what we've been able to measure, that has the biggest overhead from all of the things this patch does. See [HUD](#hud) section to check how to do that

6) Why version for Ancient is so different

- Ancient has an internal bug that's causing something called **network frame** to have a wrong values on coop. What it does, is it's causing certain scripts to execute at different rates. In order to fix it on Ancient specifically, B2OP has to contain a big chunk of the 3arc code that it's replacing (alongside the function that has to be changed in order to fix the flawed network frame behavior). This is causing the file to be distributed as a zip (so you can extract the directory inside of it and it's ready for injection) and is noticeably bigger in size.

7) What is a DVAR

- DVAR is a variable that player can (usually) modify from the game console. DVARs mentioned in this document are all changeable. In order to set a DVAR, press `~` button, then type in dvar name, and value you want to assign to it, like so

```
steam_backspeed 1
```

8) Network Frame Fix file is missing from this repository

- As it's not something i naturally expect players to use (B2OP includes that fix), i moved this file from this repository to [this gist](https://gist.github.com/Zi0MIX/2b9fb6c049111c72d3f9945a45b4c2b1), so you can still use it if you for example develop your own BO2 script

9) There is a bunch of text showing up on my screen while playing on Plutonium with this patch

- Yes, most of it is either Plutonium anticheat stuff that the patch triggers, or data about the game that is useful for both you the player and also people who watch/validate your game. Even tho it may look like a lot, the patch was built to show as little as possible while providing all important info.

10) I'm getting an error about having 2 patches loaded at the same time.

- Plutonium have changed their go-to directory for scripts, but they maintain them for backwards compatibility. Try the following
    - Check if you still have a `t6r` folder in your Plutonium directory, if so, just remove it (it's a leftover from earliest versions of Plutonium)
    - Check if you have anything in `Plutonium\storage\t6\scripts\zm`, if so, just remove it. The patch should be in `Plutonium\storage\t6\raw\scripts\zm` alongside `ranked.gsc` file according to current Plutonium guidelines.

# Steps for basic troubleshooting

- Make sure you're using correct and up to date version downloaded from releases section on this page.
- Remove other patches. B2 Plugins should not cause any issues, but if you are using any, for the sake of troubleshooting remove them as well.
- Check if the directory the patch is in is correct. Perhaps you have multiple instances of Plutonium or Redacted and you put it in the directory belonging to another instance.

# HUD

All HUD elements are toogleable (with the exception of watermarks), below is the table with DVARs that can be used to hide and show them. Change DVAR state by invoking the in-game command line (`~` button by default), enter name of the DVAR and value following the spacebar.

> [!TIP]
> Disabling hud elements reduces variable allocations of the patch, so if you're a fan of optimizations, toggle all of these off by pasting following line into your console.

```
timers 0;splits 0;buildables 0
```

| HUD element | DVAR | Default |
| --- | --- | --- |
| Timers | `timers` 0/1 | Enabled |
| SPH print | `splits` 0/1 | Enabled |
| Buildables HUD | `buildables` 0/1 | Enabled |

## Kill hud

You can also permanently disable all B2 hud for the entire game, which will additionally remove some allocations from the script itself. This shouldn't really be necessary, but for a situation where every single child variable counts it can be useful. To do that set the following DVAR

```
kill_hud 1
```

> [!WARNING]
> Once HUD is killed, you won't be able to re-enable it without restarting the game, normally just hiding it using the method shown above should be enough.

## Split display accuracy

Prior to version 3.5 splits were not fully accurate. Starting on 3.5, B2OP emulates the logic used by original code to calculate the accurate red number moment (end of fade-in transition). Below is a table showing time difference for each split between the actual red number time and time displayed by split message.

| Round split | Offset (+ seconds) |
| :--- | :---: |
| 30 | -0.25 |
| 50 | -1.25 |
| 70 | -2.25 |
| 100 | -4.25 |

# Box / Fridge

This patch has the following capabilites regarding box and fridge:

- Overriding weapon in the box (First Box Patch)
- Overriding starting box location
- Overriding weapon in the fridge (Fridge Patch)

> [!NOTE]
> None of the modules specified above will do anything to your game, unless specific actions described in following sections are taken.

> [!TIP]
> All 3 modules normally work by host inserting the correct DVAR in the console. However specifically in Plutonium (2905 and live versions) you can also do it via a chat message. Chat command is exactly the same as the console one, unless otherwise specified in the specific section below, this functionality allows offhost players to perform these actions as well.

## Managing modules via binds

On Plutonium you can invoke these commands without typing/copying them in every time by using binds. Binds need to be set in the bind config file.

Bind config default location

```
%localappdata%\Plutonium\storage\t6\players\bindings_zm.bdg
```

For example following bind will input the command `fb mk2|galil` after you press `p`

```
bind P "fb mk2|galil"
```

You can also add `say` in front of the command to make it output chat command for you

```
bind P "say fb mk2|galil"
```

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

Additionally, players can chain multiple weapons via a single message with both methods, following example will yield the first box module triggering 3 times

```
fb mk2|monk|galil
```

## Overriding fridge weapon

Player is allowed to override weapons for himself and his team in the fridge until either round 11 or first use of the fridge. This functionality does not allow for inserting weapons that are not normally allowed to be put in the fridge by the game.
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

Example of player setting weapons for everyone (host only):

```
fridge all m16
```

Example of player setting upgraded weapons for everyone (host only):

```
fridge all +m16
```

# Basic trade tracker

Basic trade tracker is a small utility available in survival maps, it prints stats as players pick up RayGuns, and can also be triggered by chat commands.

## Chat commands

- Use `box {weapon}` chat command to display current stats about a weapon (Plutonium only)

## Stop trade tracker

- If you wish to stop the tracker (you don't like it / for allocation purposes), you can use DVAR `kill_box_tracker 1`, this will permanently clear all the logic from the tracker from the game. WARNING! Once disabled, it won't work again in that game.

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

> [!NOTE]
> The game will restart automatically after awarding players with permaperks, when the sitution allows for it (all launchers solo and Plutonium coop). Otherwise it'll just end, as restarting would cause the crash. In unsupported configurations, all players are recommended to get into a solo game to get their permaperks before starting the coop.

# Tank fix

On Plutonium R4516+, the tank has been changed to match how it works on Steam and Console. [This file](https://github.com/B2ORG/T6-B2OP-PATCH/blob/main/b2op_tomb.gsc) is a fix to that, if the community agrees that it should be prepatches, there's gonna be a separate release in [release section](https://github.com/B2ORG/T6-B2OP-PATCH/releases) for that fix specifically, as it has to be a separate file. You can hear about this topic in [this video](https://youtu.be/p8s-4b4D1J8)

# Characters

Up until version 3.0, it was possible to set characters via Plugins system, but it's not particulary easy nor user friendly, so a new version of this system has been created.

> [!NOTE]
> You don't need to have the patch in for character selections to work if you're the off-host player, as long as the host has it, it'll work.

> [!NOTE]
> If in a coop game a player does not use any preset, it is possible for him to take a character before player with that character set. In that case preset will not work. In order for the system to work properly, have all players in the game set their presets.

> [!NOTE]
> Character settings are the same for B2FR & B2OP, which means you don't need to change the settings between these 2 patches

> [!TIP]
> When using fast_restart, characters for off-host players are evaluated before host (that's how the game does it). I've decided to not change this behavior as it'd require further changes of the existing game logic. Instead, in order to preserve priority of character selection, use map_restart command.

## Character commands

In order to set a character, paste the right command into the console in the main menu before the game actually begins, or use chat message method on Plutonium. For survival maps, host setting applies to all players. Please note, if a character is already taken, your setting will not be applied.

- CIA

```
statwriteddl playerstatsbymap zm_highrise weaponlocker lh_clip 2;uploadstats
```

- CDC

```
statwriteddl playerstatsbymap zm_highrise weaponlocker lh_clip 1;uploadstats
```

- Misty

```
statwriteddl playerstatsbymap zm_highrise weaponlocker clip 3;uploadstats
```

- Russman

```
statwriteddl playerstatsbymap zm_highrise weaponlocker clip 1;uploadstats
```

- Stuhlinger

```
statwriteddl playerstatsbymap zm_highrise weaponlocker clip 2;uploadstats
```

- Marlton

```
statwriteddl playerstatsbymap zm_highrise weaponlocker clip 4;uploadstats
```

- Weasel

```
statwriteddl playerstatsbymap zm_highrise weaponlocker stock 4;uploadstats
```

- Billy

```
statwriteddl playerstatsbymap zm_highrise weaponlocker stock 3;uploadstats
```

- Sal

```
statwriteddl playerstatsbymap zm_highrise weaponlocker stock 2;uploadstats
```

- Finn

```
statwriteddl playerstatsbymap zm_highrise weaponlocker stock 1;uploadstats
```

- Dempsey

```
statwriteddl playerstatsbymap zm_highrise weaponlocker alt_clip 1;uploadstats
```

- Nikolai

```
statwriteddl playerstatsbymap zm_highrise weaponlocker alt_clip 2;uploadstats
```

- Takeo

```
statwriteddl playerstatsbymap zm_highrise weaponlocker alt_clip 4;uploadstats
```

- Richtofen

```
statwriteddl playerstatsbymap zm_highrise weaponlocker alt_clip 3;uploadstats
```

## Reset character presets

In order to disable presets (to restore randomized characters) use following commands

- Survival maps

```
statwriteddl playerstatsbymap zm_highrise weaponlocker lh_clip 0;uploadstats
```

- Tranzit / Die Rise / Buried

```
statwriteddl playerstatsbymap zm_highrise weaponlocker clip 0;uploadstats
```

- Mob of the Dead

```
statwriteddl playerstatsbymap zm_highrise weaponlocker stock 0;uploadstats
```

- Origins

```
statwriteddl playerstatsbymap zm_highrise weaponlocker alt_clip 0;uploadstats
```

## Chat commands on Plutonium

On Plutonium you can use chat commands to manage characters. After changing the settings, the game will have to be restarted to take effect (that's the recommended way to change characters in game, as stat command may not always work). The patch will only listen for the chat messages about characters for first two rounds. Enter following message into the chat:

```
char <name>
```

Where <name> is the name of the character. Following values are accepted:

```
misty russman stuhlinger marlton weasel billy sal finn dempsey nikolai takeo richtofen cia cdc
```

You can also reset character presets by typing in

```
char reset
```

> [!TIP]
> You can check which preset you currently have set by entering `whoami` in the chat

## Redacted offline mode

Because this system is based on player stats that are not available, when in Redacted offline mode, characters are operated differently. You need to enter the match, set the character via a DVAR and use `map_restart` command. As oppose to using stats system, this will not persist across game launches.

For characters use following DVARs

- CDC, Russman, Finn, Dempsey

```
set_character 1
```

- CIA, Stuhlinger, Sal, Nikolai

```
set_character 2
```

- Misty, Billy, Richtofen

```
set_character 3
```

- Marlton, Weasel, Takeo

```
set_character 4
```

- Random character

```
set_character 0
```

## Viewmodel swapping

As a response to drawbacks in the character system, we added additional functionaltiy that allows you to swap only the viewmodel (hands in first person), as oppose to the entire character. Changes here will apply instantly and have no effect to any game logic (as far as the game is concerned, the character has not been changed). You may swap viewmodels either by using `view` chat message or `viewmodel` dvar, followed by one of these values

```
misty russman stuhlinger marlton weasel billy sal finn dempsey nikolai takeo richtofen cia cdc
```

or

```
reset
```

to set viewmodel back to what it should be with your original character.

# Contributions

If you'd like to contribute to the code, please fork this repository, apply changes / fixes and open a pull request. If the change is in line with rules and the purpose of this patch, it'll be merged and a new version of the patch will be released.

Since version 2.0, it's become a bit harder to work on the patch (natural progression i suppose), following things are required:

- [Python](https://www.python.org/downloads/windows/) 3.12 or newer
- [gsc-tool](https://github.com/xensik/gsc-tool/releases) 1.4.0 or newer

Install Python (and make sure to check adding it to the system PATH while doing so). Download gsc-tool, do not change the name of the program. Put everything in the patch main directory.

After applying desired changes, run script `compile.py` while in the patch main directory (press on address bar in the folder view, put `cmd` and press enter. A command line will open with that folder already set). Run script by putting in `python compile.py`. If you did everything right, script should compile everything for you and put stuff in right folders.

> [!NOTE]
> Please note, as the modding scene for BO2 is still very young, stuff and tech is changing rapidly. Above description may not always be up to date, but i will try to not let that happen too often.
