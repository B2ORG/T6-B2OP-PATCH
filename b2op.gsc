#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_prison;
#include maps\mp\zm_tomb;
#include maps\mp\zm_tomb_utility;

main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::fixed_wait_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::fixed_wait_network_frame);

    level thread safe_init();
}

safe_init()
{
	flag_init("dvars_set");
	flag_init("cheat_printed_backspeed");
	flag_init("cheat_printed_noprint");
	flag_init("cheat_printed_cheats");
	flag_init("cheat_printed_gspeed");

	flag_init("game_started");
	flag_init("box_rigged");
	flag_init("break_firstbox");
	flag_init("permaperks_were_set");

	// Patch Config
	level.B2OP_CONFIG = array();
	level.B2OP_CONFIG["version"] = 1;
	level.B2OP_CONFIG["beta"] = false;
	level.B2OP_CONFIG["debug"] = true;
	// level.B2OP_CONFIG["vanilla"] = get_vanilla_setting(false);
	// level.B2OP_CONFIG["for_player"] = "";
	// level.B2OP_CONFIG["key_hud_plugin"] = undefined;

	set_dvars();
	level thread on_game_start();
}

on_game_start()
{
	level endon("end_game");

	// Func Config
	// level.B2OP_CONFIG["hud_color"] = (0, 1, 0.5);
	// level.B2OP_CONFIG["const_timer"] = true;
	// level.B2OP_CONFIG["const_round_timer"] = false;
	// level.B2OP_CONFIG["show_hordes"] = true;
	// level.B2OP_CONFIG["give_permaperks"] = true;
	// level.B2OP_CONFIG["track_permaperks"] = true;
	// level.B2OP_CONFIG["mannequins"] = false;
	// level.B2OP_CONFIG["nuketown_25_ee"] = false;
	// level.B2OP_CONFIG["forever_solo_game_fix"] = true;
	// level.B2OP_CONFIG["semtex_prenades"] = true;
	// level.B2OP_CONFIG["fridge"] = false;
	// level.B2OP_CONFIG["first_box_module"] = false;

	level thread on_player_joined();

	level waittill("initial_players_connected");

	// Initial game settings
	// level thread dvar_detector();
	// level thread first_box_handler();
	// level thread fridge_handler();
	// level thread origins_fix();
	// level thread safety_anticheat();
	// level thread powerup_point_drop_watcher();
	// level thread powerup_odds_watcher();
	// level thread powerup_vars_controller();

	flag_wait("initial_blackscreen_passed");

    level thread b2op_main_loop();

	// HUD
	// level thread timer_hud();
	// level thread round_timer_hud();

	// Scheduled prints
	// level thread display_splits();
	// level thread display_hordes();
	// level thread semtex_display();

	// Game settings
	// safety_zio();
	// safety_round();
	// safety_difficulty();
	// safety_debugger();
	// safety_beta();
	// level thread perma_perks_setup();
	// level thread nuketown_handler();
	// level thread topbarn_controller();
}

on_player_joined()
{
	level endon("end_game");

	while(true)
	{
		level waittill("connected", player);
		player thread on_player_spawned();
	}
}

on_player_spawned()
{
	level endon("end_game");
    self endon("disconnect");

	self waittill("spawned_player");

	// Perhaps a redundand safety check, but doesn't hurt
	while (!flag("initial_players_connected"))
		wait 0.05;

	// self thread welcome_prints();
	// self thread print_network_frame(6);
	// self thread velocity_meter();
	// self thread set_characters();
}

b2op_main_loop()
{
    level endon("end_game");

    while (true)
    {
        level waittill("start_of_round");

        level waittill("end_of_round");

        level thread show_split();
    }
}

// Stubs

replaceFunc(arg1, arg2)
{
}

print(arg1)
{
}

stub(arg)
{
}

// Utilities

is_debug()
{
	if (b2op_config("debug"))
		return true;
	return false;
}

debug_print(text)
{
	if (is_debug())
		print("DEBUG: " + text);
}

generate_watermark(text, color, alpha_override)
{
    if (!isDefined(level.num_of_watermarks))
        level.num_of_watermarks = 0;

	y_offset = 12 * level.num_of_watermarks;
	if (!isDefined(color))
		color = (1, 1, 1);

	if (!isDefined(alpha_override))
		alpha_override = 0.33;

    watermark = createserverfontstring("hudsmall" , 1.2);
	watermark setPoint("CENTER", "TOP", 0, y_offset - 10);
	watermark.color = color;
	watermark setText(text);
	watermark.alpha = alpha_override;
	watermark.hidewheninmenu = 0;

    level.num_of_watermarks++;
}

print_scheduler(content)
{
	level endon("end_game");
    self endon("disconnect");

    if (isDefined(self))
        self thread player_print_scheduler(content);
    else
        foreach (player in level.players)
            player thread player_print_scheduler(content);
}

player_print_scheduler(content)
{
    level endon("end_game");
    self endon("disconnect");

    while (isDefined(self.scheduled_prints) && self.scheduled_prints >= getDvarInt("con_gameMsgWindow0LineCount"))
        wait 0.05;

    if (isDefined(self.scheduled_prints))
        self.scheduled_prints++;
    else
        self.scheduled_prints = 1;

    self iPrintLn(content);
    wait_for_message_end();
    self.scheduled_prints--;

    if (self.scheduled_prints <= 0)
        self.scheduled_prints = undefined;
}

convert_time(seconds)
{
	hours = 0;
	minutes = 0;
	
	if (seconds > 59)
	{
		minutes = int(seconds / 60);

		seconds = int(seconds * 1000) % (60 * 1000);
		seconds = seconds * 0.001;

		if (minutes > 59)
		{
			hours = int(minutes / 60);
			minutes = int(minutes * 1000) % (60 * 1000);
			minutes = minutes * 0.001;
		}
	}

	str_hours = hours;
	if (hours < 10)
		str_hours = "0" + hours;

	str_minutes = minutes;
	if (minutes < 10 && hours > 0)
		str_minutes = "0" + minutes;

	str_seconds = seconds;
	if (seconds < 10)
		str_seconds = "0" + seconds;

	if (hours == 0)
		combined = "" + str_minutes  + ":" + str_seconds;
	else
		combined = "" + str_hours  + ":" + str_minutes  + ":" + str_seconds;

	return combined;
}

player_wait_for_initial_blackscreen()
{
	level endon("end_game");

    while (!flag("game_started"))
        wait 0.05;
}

is_town()
{
	if (level.script == "zm_transit" && level.scr_zm_map_start_location == "town" && level.scr_zm_ui_gametype_group == "zsurvival")
		return true;
	return false;
}

is_farm()
{
	if (level.script == "zm_transit" && level.scr_zm_map_start_location == "farm" && level.scr_zm_ui_gametype_group == "zsurvival")
		return true;
	return false;
}

is_depot()
{
	if (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zsurvival")
		return true;
	return false;
}

is_tranzit()
{
	if (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zclassic")
		return true;
	return false;
}

is_nuketown()
{
	if (level.script == "zm_nuked")
		return true;
	return false;
}

is_die_rise()
{
	if (level.script == "zm_highrise")
		return true;
	return false;
}

is_mob()
{
	if (level.script == "zm_prison")
		return true;
	return false;
}

is_buried()
{
	if (level.script == "zm_buried")
		return true;
	return false;
}

is_origins()
{
	if (level.script == "zm_tomb")
		return true;
	return false;
}

did_game_just_start()
{
	if (!isDefined(level.start_round))
		return true;

	if (!is_round(level.start_round + 2))
		return true;

	return false;
}

is_round(rnd)
{
	if (rnd <= level.round_number)
		is_rnd = true;
	else
		is_rnd = false;

	return is_rnd;
}

is_plutonium()
{
	// Returns true for Pluto versions r2693 and above
	if (getDvar("cg_weaponCycleDelay") == "")
		return false;
	return true;
}

has_magic()
{
    if (isDefined(level.enable_magic) && level.enable_magic)
        return true;
    return false;
}

has_permaperks_system()
{
	// Refer to init_persistent_abilities()
	if (isDefined(level.pers_upgrade_boards))
		return true;
	return false;
}

is_special_round()
{
	if (isDefined(flag("dog_round")) && flag("dog_round"))
		return true;

	if (isDefined(flag("leaper_round")) && flag("leaper_round"))
		return true;

	return false;
}

wait_for_message_end()
{
	wait getDvarFloat("con_gameMsgWindow0FadeInTime") + getDvarFloat("con_gameMsgWindow0MsgTime") + getDvarFloat("con_gameMsgWindow0FadeOutTime");
}

b2op_config(key)
{
	if (isDefined(level.B2OP_CONFIG[key]) && level.B2OP_CONFIG[key])
		return true;
	return false;
}

set_hud_properties(hud_key, x_align, y_align, x_pos, y_pos, col)
{
	if (!isDefined(col))
		col = level.B2OP_CONFIG["hud_color"];

	if (isDefined(level.B2OP_PLUGIN_HUD))
	{
		/* Proxy variable for irony compatibility */
		func = level.B2OP_PLUGIN_HUD[hud_key];
		plugin = [[func]](level.B2OP_CONFIG["key_hud_plugin"]);
		if (isDefined(plugin))
		{
			if (isDefined(plugin["x_align"]))
				x_align = plugin["x_align"];
			if (isDefined(plugin["y_align"]))
				y_align = plugin["y_align"];
			if (isDefined(plugin["x_pos"]))
				x_pos = plugin["x_pos"];
			if (isDefined(plugin["y_pos"]))
				y_pos = plugin["y_pos"];
			if (isDefined(plugin["color"]))
				col = plugin["color"];
		}
		else
			debug_print("set_hud_properties(): hud plugin returned undefined for key='" + hud_key + "'");
	}

	self setpoint(x_align, y_align, x_pos, y_pos);
	self.color = col;
}

// Functions

welcome_prints()
{
	wait 0.75;
	self iPrintLn("B2^1OP^7 PATCH ^1V" + level.B2OP_CONFIG["version"]);
	wait 0.75;
	self iPrintLn("Source: ^1github.com/Zi0MIX/T6-B2OP-PATCH");
}

generate_cheat()
{
	// Don't want to generate it twice
	if (isDefined(level.cheat_hud))
		return;

    level.cheat_hud = createserverfontstring("hudsmall" , 1.2);
	level.cheat_hud setPoint("CENTER", "CENTER", 0, -30);
	level.cheat_hud.color = (1, 0.5, 0);
	level.cheat_hud setText("Alright there fuckaroo, quit this cheated sheit and touch grass loser.");
	level.cheat_hud.alpha = 1;
	level.cheat_hud.hidewheninmenu = 0;

	level notify("cheat_generated");

	return;
}

set_dvars()
{
	level endon("end_game");

    setdvar("player_strafeSpeedScale", 1);
    setdvar("player_backSpeedScale", 0.9);
    setdvar("g_speed", 190);
    setdvar("con_gameMsgWindow0Filter", "gamenotify obituary");
    setdvar("sv_cheats", 0);

    if (!flag("dvars_set"))
        flag_set("dvars_set");
}

dvar_detector() 
{
	level endon("end_game");

	flag_wait("dvars_set");

	red_color = (0.8, 0, 0);
	dvar_definitions = array();
	dvar_definitions["dvar_name"] = array("sv_cheats", "g_speed");
	dvar_definitions["dvar_values"] = array("0", "190");
	dvar_definitions["dvar_watermark"] = array("CHEATS", "GSPEED");
	dvar_definitions["watermark_color"] = array(red_color, red_color);
	dvar_definitions["is_cheat"] = array(true, true);

	dvar_detections = array();

	while (true) 
	{
		for (i = 0; i < dvar_definitions.size; i++)
		{
			detection_key = "cheat_" + dvar_definitions["dvar_name"][i];

			if (getDvar(dvar_definitions["dvar_name"][i]) != dvar_definitions["dvar_values"][i])
			{
				debug_print("Detected " + dvar_definitions["dvar_name"][i]);

				if (dvar_definitions["is_cheat"][i])
					generate_cheat();

				if (!isinarray(dvar_detections, detection_key))
				{
					generate_watermark(dvar_definitions["dvar_watermark"][i], dvar_definitions["watermark_color"][i]);
					dvar_detections[dvar_detections.size] = detection_key;
				}

				level notify("reset_dvars");
			}
		}

		wait 0.1;
	}
}

fixed_wait_network_frame()
{
	if (!isDefined(level.players) || level.players.size == 1)
		wait 0.1;
	else
		wait 0.05;
}

safety_zio()
{
	// Song autotiming
	if (isDefined(level.SONG_TIMING))
	{
		iPrintLn("^1SONG PATCH DETECTED!!!");
		level notify("end_game");
	}

	// Innit patch
	if (isDefined(level.INNIT_CONFIG))
	{
		iPrintLn("^1INNIT PATCH DETECTED!!!");
		level notify("end_game");
	}
}

safety_round()
{
	maxround = 1;
	if (is_town() || is_farm() || is_depot() || is_nuketown())
		maxround = 10;

	debug_print("Starting round detected: " + level.start_round);

	if (level.start_round <= maxround)
		return;

	generate_watermark("STARTING ROUND", (0.8, 0, 0));
}

safety_difficulty()
{
	if (level.gamedifficulty == 0)
		generate_watermark("EASY MODE", (0.8, 0, 0));
	return;
}

safety_debugger()
{
	if (is_debug())
	{
		foreach(player in level.players)
			player thread award_points(333333);
		generate_watermark("DEBUGGER", (0.8, 0.8, 0));
	}
}

safety_anticheat()
{
	level endon("end_game");

	level waittill("cheat_generated");
	while (isDefined(level.cheat_hud))
		wait 0.1;

	foreach (player in level.players)
		player doDamage(player.health + 69, player.origin);
}

safety_beta()
{
	if (b2op_config("beta"))
		generate_watermark("BETA", (0, 0.8, 0));
}

/* change that into iprint */
print_network_frame(len)
{
	level endon("end_game");
	self endon("disconnect");

    player_wait_for_initial_blackscreen();

    self.network_hud = createfontstring("hudsmall" , 1.9);
	self.network_hud setPoint("CENTER", "TOP", "CENTER", 5);
	self.network_hud.alpha = 0;
	self.network_hud.color = (1, 1, 1);
	self.network_hud.hidewheninmenu = 1;
    self.network_hud.label = &"NETWORK FRAME: ^2";

	flag_wait("initial_blackscreen_passed");

	start_time = int(getTime());
	wait_network_frame();
	end_time = int(getTime());
	network_frame_len = (end_time - start_time) / 1000;

	if (!isdefined(len))
		len = 5;

	if ((level.players.size == 1) && (network_frame_len != 0.1))
	{
		self.network_hud.label = &"NETWORK FRAME: ^1";
		generate_watermark("PLUTO SPAWNS", (0.8, 0, 0));
	}
	else if ((level.players.size > 1) && (network_frame_len != 0.05))
	{
		self.network_hud.label = &"NETWORK FRAME: ^1";
		generate_watermark("PLUTO SPAWNS", (0.8, 0, 0));
	}

	self.network_hud setValue(network_frame_len);

	self.network_hud.alpha = 1;
	wait len;
	self.network_hud.alpha = 0;
	wait 0.1;
	self.network_hud destroy();
}

timer_hud()
{
    /* Return if timer disabled */

    timer_hud = createserverfontstring("big" , 1.6);
	timer_hud set_hud_properties("timer_hud", "TOPRIGHT", "TOPRIGHT", 60, -26);
	if (!is_plutonium())
		timer_hud set_hud_properties("round_hud", "TOPLEFT", "TOPLEFT", -55, -22);
	timer_hud.alpha = 0;
	timer_hud.hidewheninmenu = 1;

	level.FRFIX_START = int(getTime() / 1000);
	flag_set("game_started");
}

round_timer_hud()
{
    level endon("end_game");

	round_hud = createserverfontstring("big" , 1.6);
	round_hud set_hud_properties("round_hud", "TOPRIGHT", "TOPRIGHT", 60, -9);
	if (!is_plutonium())
		round_hud set_hud_properties("round_hud", "TOPLEFT", "TOPLEFT", -55, -7);
	round_hud.alpha = 0;
	round_hud.hidewheninmenu = 1;

    /* Return if no round timer hud enabled */
	while (true)
	{
		level waittill("start_of_round");

		round_start = int(getTime() / 1000);

        round_hud setTimerUp(0);
        round_hud FadeOverTime(0.25);
        round_hud.alpha = 1;

		level waittill("end_of_round");

		round_end = int(getTime() / 1000) - round_start;

		round_start = undefined;

		for (ticks = 0; ticks < 20; ticks++)
		{
			round_hud setTimer(round_end - 0.1);
			wait 0.25;
		}

		round_hud FadeOverTime(0.25);
		round_hud.alpha = 0;
	}
}

show_split()
{
	level endon("end_game");

    /* Add check for hud enabled */

    switch (level.round_number)
    {
        case 30:
        case 50:
        case 70:
        case 100:
        case 150:
        case 200:
            wait 8.5;
            break;
        default:
            return;
    }

    timestamp = convert_time(int(getTime() / 1000) - level.FRFIX_START);
    self thread print_scheduler("Round " + level.round_number + " time: ^1", timestamp);
}

display_hordes()
{
	level endon("end_game");

    /* Add check for hud enabled */

    wait 0.05;

    if (!is_special_round() && is_round(20))
    {
        label = "HORDES ON " + level.round_number + ": ^3";
        zombies_value = int(((maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total) / 24) * 100);
        self thread print_scheduler(label, zombies_value / 100);
    }
}

velocity_meter()
{
    self endon("disconnect");
    level endon("end_game");

    /* Add check for hud enabled */

    player_wait_for_initial_blackscreen();

    self.hud_velocity = createfontstring("default" , 1.1);
	self.hud_velocity set_hud_properties("hud_velocity", "CENTER", "CENTER", "CENTER", 200);
	self.hud_velocity.alpha = 0.75;
	self.hud_velocity.hidewheninmenu = 1;

    while (true)
    {
        if (isDefined(self.afterlife) && self.afterlife)
		    hud.alpha = 0;
	    else
		    hud.alpha = 1;

		velocity = int(length(self getvelocity() * (1, 1, 0)));
		self.hud_velocity velocity_meter_scale(velocity);
        self.hud_velocity setValue(velocity);

        wait 0.05;
    }
}

velocity_meter_scale(vel)
{
	self.color = (0.6, 0, 0);
	self.glowcolor = (0.3, 0, 0);

	if (vel < 330)
	{
		self.color = (0.6, 1, 0.6);
		self.glowcolor = (0.4, 0.7, 0.4);
	}

	else if (vel <= 340)
	{
		self.color = (0.8, 1, 0.6);
		self.glowcolor = (0.6, 0.7, 0.4);
	}

	else if (vel <= 350)
	{
		self.color = (1, 1, 0.6);
		self.glowcolor = (0.7, 0.7, 0.4);
	}

	else if (vel <= 360)
	{
		self.color = (1, 0.8, 0.4);
		self.glowcolor = (0.7, 0.6, 0.2);
	}

	else if (vel <= 370)
	{
		self.color = (1, 0.6, 0.2);
		self.glowcolor = (0.7, 0.4, 0.1);
	}

	else if (vel <= 380)
	{
		self.color = (1, 0.2, 0);
		self.glowcolor = (0.7, 0.1, 0);
	}
}

/*
perma_perks_setup()
{
	level endon("end_game");

	if (!has_permaperks_system())
		return;

	self thread watch_permaperk_award();

	foreach (player in level.players)
	{
		player thread permaperks_watcher();
		player thread permaperk_failsafe_early();

		player.frfix_awarding_permaperks = false;
		if (isDefined(level.B2OP_PLUGIN_PERMAPERKS))
			player thread [[level.B2OP_PLUGIN_PERMAPERKS]]();
		else
			player thread award_permaperks_safe();
	}

	while (true)
	{
		level waittill("connected", player);

		player thread permaperks_watcher();
		if (!is_round(15))
			player thread permaperk_failsafe_early();
		else
			player thread permaperk_failsafe_late();

		if (isDefined(level.B2OP_PLUGIN_PERMAPERKS))
			player thread [[level.B2OP_PLUGIN_PERMAPERKS]]();
	}
}

watch_permaperk_award()
{
	level endon("end_game");

	present_players = level.players.size;

	while (true)
	{
		i = 0;
		foreach (player in level.players)
		{
			if (!isDefined(player.frfix_awarding_permaperks))
				i++;
		}

		if (i == present_players && flag("permaperks_were_set"))
		{
			thread print_scheduler("Permaperks Awarded: ", "^1RESTART REQUIRED");
			wait 1.5;
			if (is_plutonium())
				map_restart();
			else
				level notify("end_game");
		}

		if (!did_game_just_start())
			break;

		wait 0.1;
	}

	foreach (player in level.players)
	{
		if (isDefined(player.frfix_awarding_permaperks))
			player.frfix_awarding_permaperks = undefined;
	}
}

permaperks_watcher()
{
	level endon("end_game");
	self endon("disconnect");

	self.last_perk_state = array();
	foreach(perk in level.pers_upgrades_keys)
		self.last_perk_state[perk] = self.pers_upgrades_awarded[perk];

	while (true)
	{
		foreach(perk in level.pers_upgrades_keys)
		{
			if (self.pers_upgrades_awarded[perk] != self.last_perk_state[perk])
			{
				if (!isDefined(self.frfix_awarding_permaperks))
					self print_permaperk_state(self.pers_upgrades_awarded[perk], perk);
				self.last_perk_state[perk] = self.pers_upgrades_awarded[perk];
				wait 0.1;
			}
		}

		wait 0.1;
	}
}

permaperk_struct(current_array, code, award, take, to_round, maps_exclude, map_unique)
{
	if (!isDefined(maps_exclude))
		maps_exclude = array();
	if (!isDefined(to_round))
		to_round = 255;
	if (!isDefined(map_unique))
		map_unique = undefined;

	permaperk = spawnStruct();
	permaperk.code = code;
	permaperk.to_round = to_round;
	permaperk.award = award;
	permaperk.take = take;
	permaperk.maps_to_exclude = maps_exclude;
	permaperk.map_unique = map_unique;

	// debug_print("generating permaperk struct | data: code=" + code + " to_round=" + to_round + " award=" + award + " take=" + take + " map_unique=" + map_unique + " | size of current: " + current_array.size);

	current_array[current_array.size] = permaperk;
	return current_array;
}

award_permaperks_safe()
{
	level endon("end_game");
	self endon("disconnect");

	if (!b2op_config("give_permaperks"))
		return;

	while (!isalive(self))
		wait 0.05;

	wait 0.5;

	perks_to_process = array();
	perks_to_process = permaperk_struct(perks_to_process, "revive", true, false);
	perks_to_process = permaperk_struct(perks_to_process, "multikill_headshots", true, false);
	perks_to_process = permaperk_struct(perks_to_process, "perk_lose", true, false);
	perks_to_process = permaperk_struct(perks_to_process, "jugg", true, false, 15);
	perks_to_process = permaperk_struct(perks_to_process, "flopper", true, false, 255, array(), "zm_buried");
	perks_to_process = permaperk_struct(perks_to_process, "box_weapon", false, true, 255, array("zm_buried"));
	perks_to_process = permaperk_struct(perks_to_process, "nube", true, true, 10, array("zm_highrise"));
	perks_to_process = permaperk_struct(perks_to_process, "board", true, false);

	self.frfix_awarding_permaperks = true;

	foreach (perk in perks_to_process)
	{
		wait 0.05;

		if (isDefined(perk.map_unique) && perk.map_unique != level.script)
			continue;

		perk_code = perk.code;
		debug_print(self.name + ": processing -> " + perk_code);

		// If award and take are both set, it means maps specified in 'maps_to_exclude' are the maps on which perk needs to be taken away
		if (perk.award && perk.take && isinarray(perk.maps_to_exclude, level.script))
		{
			self remove_permaperk(perk_code);
			wait_network_frame();
		}
		// Else if take is specified, take
		else if (!perk.award && perk.take && !isinarray(perk.maps_to_exclude, level.script))
		{
			self remove_permaperk(perk_code);
			wait_network_frame();
		}

		// Do not try to award perk if player already has it
		if (self.pers_upgrades_awarded[perk_code])
			continue;

		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			// Award perk if all conditions match
			if (perk.award && !is_round(perk.to_round) && !isinarray(perk.maps_to_exclude, level.script))
			{
				self award_permaperk(stat_name, perk_code, stat_value);
				wait_network_frame();
			}
		}
	}

	wait 0.5;
	self.frfix_awarding_permaperks = undefined;
	self uploadstatssoon();
}

award_permaperk(stat_name, perk_code, stat_value)
{
	flag_set("permaperks_were_set");

	perk_name = permaperk_name(perk_code);

	self.stats_this_frame[stat_name] = 1;
	self set_global_stat(stat_name, stat_value);
	info_print(self.name + ": Permaperk '" + perk_name + "' activation -> " + stat_name + " set to: " + stat_value);
}

remove_permaperk_wrapper(perk_code, round)
{
	perk_name = permaperk_name(perk_code);

	if (!isDefined(round))
		round = 1;

	debug_print("remove_permaperk_wrapper(self=" + self.name + ", perk_code=" + perk_code + ", round=" + round + ")");

	if (is_round(round) && self.pers_upgrades_awarded[perk_code])
	{
		info_print("Permaperk failsafe triggered for " + self.name + ": " + perk_name);
		self remove_permaperk(perk_code, perk_name);
		self playsoundtoplayer("evt_player_downgrade", self);
	}
}

remove_permaperk(perk_code, perk_name)
{
	if (!isDefined(perk_name))
		perk_name = permaperk_name(perk_code);

	info_print("Perk Removal for " + self.name + ": " + perk_name);
	self.pers_upgrades_awarded[perk_code] = 0;
}

permaperk_failsafe_early()
{
	level endon("end_game");
	self endon("disconnect");

	while (!is_round(16))
	{
		level waittill("start_of_round");
		wait 5;

		remove_permaperk_wrapper("nube", 10);
		remove_permaperk_wrapper("jugg", 15);
	}

	debug_print(self.name + " exiting permaperk_failsafe_early()");
}

permaperk_failsafe_late()
{
	level endon("end_game");
	self endon("disconnect");

	debug_print(self.name + " entering permaperk_failsafe_late()");

	/* We want to remove the perks before players spawn to prevent health bonus 
	The wait is essential, it allows the game to process permaperks internally before we override them */
	wait 2;

	remove_permaperk_wrapper("nube");
	remove_permaperk_wrapper("jugg");
}

permaperk_name(perk)
{
	switch (perk)
	{
		case "revive":
			return "Quick Revive";
		case "multikill_headshots":
			return "Extra Headshot Damage";
		case "perk_lose":
			return "Tombstone";
		case "jugg":
			return "Juggernog";
		case "flopper":
			return "Flopper";
		case "box_weapon":
			return "Better Mystery Box";
		case "nube":
			return "Nube";
		case "board":
			return "Metal Boards";
		case "carpenter":
			return "Metal Carpenter Boards";
		case "insta_kill":
			return "Insta-Kill Pro";
		case "cash_back":
			return "Perk Refund";
		case "pistol_points":
			return "Double Pistol Points";
		case "double_points":
			return "Half-Off";
		case "sniper":
			return "Sniper Points";
		default:
			return perk;
	}
}

award_points(amount)
{
	level endon("end_game");
	self endon("disconnect");

	if (is_mob())
		flag_wait("afterlife_start_over");
	self.score = amount;
}

fridge_handler()
{
	level endon("end_game");

	if (!is_tranzit() && !is_die_rise() && !is_buried())
		return;

	if (!b2op_config("fridge"))
		return;

	print_scheduler("Fridge module: ", "^2ENABLED");

	self thread fridge();
	self thread fridge_state_watcher();

	// Cleanup
	level waittill("terminate_fridge_process");

	info_print("FRIDGE: One of the players obtained his weapon. Fridge module no longer available");
	print_scheduler("Fridge module: ", "^2DISABLED");

	foreach(player in level.players)
	{
		if (isDefined(player.fridge_state))
			player.fridge_state = undefined;
	}
}

fridge()
{
	level endon("end_game");
	level endon("terminate_fridge_process");

	// Use plugin to set initial fridge weapons, only for players connected from r1
	if (isDefined(level.B2OP_PLUGIN_FRIDGE))
	{
		self thread [[level.B2OP_PLUGIN_FRIDGE]](::player_rig_fridge);
		level notify("terminate_fridge_process");
	}

	while (is_plutonium())
	{
		level waittill("say", message, player);

		if (isSubStr(message, "fridge all") && player ishost())
			rig_fridge(getSubStr(message, 11));
		else if (isSubStr(message, "fridge"))
			rig_fridge(getSubStr(message, 7), player);

		message = undefined;
	}

	/* Redacted / Ancient */
	setDvar("fridge", "");
	while (true)
	{
		wait 0.05;
		if (getDvar("fridge" == ""))
			continue;

		rig_fridge(getDvar("fridge"));
	}
}

rig_fridge(key, player)
{
	debug_print("rig_fridge(): key=" + key + "'");

	if (isSubStr(key, "+"))
		weapon = get_weapon_key(getSubStr(key, 1), ::fridge_pap_weapon_verification);
	else
		weapon = get_weapon_key(key, ::fridge_weapon_verification);

	if (weapon == "")
		return;

	if (isDefined(player))
		player player_rig_fridge(weapon);
	else
	{
		foreach(player in level.players)
			player player_rig_fridge(weapon);
	}
}

player_rig_fridge(weapon)
{
	self clear_stored_weapondata();

	wpn = array();
	wpn["clip"] = weaponClipSize(weapon);
	wpn["stock"] = weaponMaxAmmo(weapon);
	wpn["dw_name"] = weapondualwieldweaponname(weapon);
	wpn["alt_name"] = weaponaltweaponname(weapon);
	wpn["lh_clip"] = weaponClipSize(wpn["dw_name"]);
	wpn["alt_clip"] = weaponClipSize(wpn["alt_name"]);
	wpn["alt_stock"] = weaponMaxAmmo(wpn["alt_name"]);

	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", weapon);
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", wpn["clip"]);
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", wpn["stock"]);

	if (isDefined(wpn["alt_name"]) && wpn["alt_name"] != "")
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_name", wpn["alt_name"]);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_clip", wpn["alt_clip"]);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_stock", wpn["alt_stock"]);
	}

	if (isDefined(wpn["dw_name"]) && wpn["dw_name"] != "")
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "dw_name", wpn["dw_name"]);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "lh_clip", wpn["lh_clip"]);
	}
}

fridge_state_watcher()
{
	level endon("end_game");
	level endon("terminate_fridge_process");

	while (true)
	{
		foreach(player in level.players)
		{
			locker = player get_locker_stat();
			/* Save state of the locker, if it's any weapon */
			if (!isDefined(player.fridge_state) && locker != "")
				player.fridge_state = locker;
			/* If locker is saved, but stat is cleared, break out */
			else if (isDefined(player.fridge_state) && locker == "")
				break;
		}

		if (is_round(11))
			break;

		wait 0.25;
	}
	level notify("terminate_fridge_process", player.name);
}

get_locker_stat(stat)
{
	if (!isDefined(stat))
		stat = "name";

	value = self getdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", stat);
	// debug_print("get_locker_stat(): value='" + value + "' for stat='" + stat + "'");
	return value;
}

first_box_handler()
{
    level endon("end_game");

	if (!has_magic())
		return;

	flag_wait("initial_blackscreen_passed");

    level.is_first_box = false;

	// Debug func, doesn't do anything in production
	self thread debug_print_initial_boxsize();

	// Init threads watching the status of boxes
	self thread init_box_status_watcher();
	// Scan weapons in the box
	self thread scan_in_box();
	// First Box main loop
	self thread first_box();

	while (true)
	{
		if (isDefined(level.is_first_box) && level.is_first_box)
			break;

		wait 0.25;
	}

	generate_watermark("FIRST BOX", (0.8, 0, 0));
}

debug_print_initial_boxsize()
{
	in_box = 0;

	foreach (weapon in getArrayKeys(level.zombie_weapons))
	{
		if (maps\mp\zombies\_zm_weapons::get_is_in_box(weapon))
			in_box++;
	}
	debug_print("Size of initial box weapon list: " + in_box);
}

init_box_status_watcher()
{
    level endon("end_game");

	level.total_box_hits = 0;

	while (!isDefined(level.chests))
		wait 0.05;
	
	foreach(chest in level.chests)
		chest thread watch_box_state();
}

watch_box_state()
{
    level endon("end_game");

    while (!isDefined(self.zbarrier))
        wait 0.05;

	while (true)
	{
        while (self.zbarrier getzbarrierpiecestate(2) != "opening")
            wait 0.05;
		level.total_box_hits++;
        while (self.zbarrier getzbarrierpiecestate(2) == "opening")
            wait 0.05;
	}
}

scan_in_box()
{
    level endon("end_game");

	// Only town needed
    if (is_town() || is_farm() || is_depot() || is_tranzit())
        should_be_in_box = 25;
	else if (is_nuketown())
        should_be_in_box = 26;
	else if (is_die_rise())
        should_be_in_box = 24;
	else if (is_mob())
        should_be_in_box = 16;
    else if (is_buried())
        should_be_in_box = 22;
	else if (is_origins())
		should_be_in_box = 23;

	offset = 0;
	if (is_die_rise() || is_origins())
		offset = 1;

    while (isDefined(should_be_in_box))
    {
        wait 0.05;

        in_box = 0;

		foreach (weapon in getarraykeys(level.zombie_weapons))
        {
            if (maps\mp\zombies\_zm_weapons::get_is_in_box(weapon))
                in_box++;
        }

		// debug_print("in_box: " + in_box + " should: " + should_be_in_box);

        if (in_box == should_be_in_box)
			continue;

		else if ((offset > 0) && (in_box == (should_be_in_box + offset)))
			continue;

		level.is_first_box = true;
		break;

    }
    return;
}

first_box()
{	
    level endon("end_game");
	level endon("break_firstbox");

	if (!b2op_config("first_box_module"))
		return;

	flag_wait("initial_blackscreen_passed");

	self thread print_scheduler("First Box module: ^2", "AVAILABLE");
	self thread watch_for_finish_firstbox();
	self.rigged_hits = 0;

	while (is_plutonium())
	{
		message = undefined;

		level waittill("say", message, player);

		if (isSubStr(message, "fb"))
			wpn_key = getSubStr(message, 3);
		else
			continue;

		self thread rig_box(wpn_key, player);
		wait_network_frame();

		wpn_key = undefined;

		while (flag("box_rigged"))
			wait 0.05;
	}

	/* Redacted / Ancient */
	setDvar("fb", "");
	while (true)
	{
		wait 0.05;

		if (getDvar("fb") == "")
			continue;

		self thread rig_box(getDvar("fb"), level.players[0]);
		wait_network_frame();

		while (flag("box_rigged"))
			wait 0.05;

		setDvar("fb", "");
	}
}

rig_box(gun, player)
{
    level endon("end_game");

	weapon_key = get_weapon_key(gun, ::box_weapon_verification);
	if (weapon_key == "")
	{
		self thread print_scheduler("Wrong weapon key: ^1",  gun);
		return;
	}

	// weapon_name = level.zombie_weapons[weapon_key].name;
	self thread print_scheduler("" + player.name + " set box weapon to: ^3", weapon_display_wrapper(weapon_key));
	level.is_first_box = true;
	self.rigged_hits++;

	saved_check = level.special_weapon_magicbox_check;
	current_box_hits = level.total_box_hits;
	removed_guns = array();

	flag_set("box_rigged");
	debug_print("FIRST BOX: flag('box_rigged'): " + flag("box_rigged"));

	level.special_weapon_magicbox_check = undefined;
	foreach(weapon in getarraykeys(level.zombie_weapons))
	{
		if ((weapon != weapon_key) && level.zombie_weapons[weapon].is_in_box == 1)
		{
			removed_guns[removed_guns.size] = weapon;
			level.zombie_weapons[weapon].is_in_box = 0;

			debug_print("FIRST BOX: setting " + weapon + ".is_in_box to 0");
		}
	}

	while ((current_box_hits == level.total_box_hits) || !isDefined(level.total_box_hits))
	{
		if (is_round(11))
		{
			debug_print("FIRST BOX: breaking out of First Box above round 10");
			break;
		}
		wait 0.05;
	}
	
	wait 5;

	level.special_weapon_magicbox_check = saved_check;

	debug_print("FIRST BOX: removed_guns.size " + removed_guns.size);
	if (removed_guns.size > 0)
	{
		foreach(rweapon in removed_guns)
		{
			level.zombie_weapons[rweapon].is_in_box = 1;
			debug_print("FIRST BOX: setting " + rweapon + ".is_in_box to 1");
		}
	}

	flag_clear("box_rigged");
	return;
}

watch_for_finish_firstbox()
{
    level endon("end_game");

	while (!is_round(11))
		wait 0.1;

	self thread print_scheduler("First Box module: ^1", "DISABLED");
	if (self.rigged_hits)
		self thread print_scheduler("First box used: ^3", self.rigged_hits + " ^7times");

	level notify("break_firstbox");
	flag_set("break_firstbox");
	debug_print("FIRST BOX: notifying module to break");

	return;
}

get_weapon_key(weapon_str, verifier)
{
	switch(weapon_str)
	{
		case "mk1":
			key = "ray_gun_zm";
			break;
		case "mk2":
			key = "raygun_mark2_zm";
			break;
		case "monk":
			key = "cymbal_monkey_zm";
			break;
		case "emp":
			key = "emp_grenade_zm";
			break;
		case "time":
			key = "time_bomb_zm";
			break;
		case "sliq":
			key = "slipgun_zm";
			break;
		case "blunder":
			key = "blundergat_zm";
			break;
		case "paralyzer":
			key = "slowgun_zm";
			break;

		case "ak47":
			key = "ak47_zm";
			break;
		case "an94":
			key = "an94_zm";
			break;
		case "barret":
			key = "barretm82_zm";
			break;
		case "b23r":
			key = "beretta93r_zm";
			break;
		case "b23re":
			key = "beretta93r_extclip_zm";
			break;
		case "dsr":
			key = "dsr50_zm";
			break;
		case "evo":
			key = "evoskorpion_zm";
			break;
		case "57":
			key = "fiveseven_zm";
			break;
		case "257":
			key = "fivesevendw_zm";
			break;
		case "fal":
			key = "fnfal_zm";
			break;
		case "galil":
			key = "galil_zm";
			break;
		case "mtar":
			key = "tar21_zm";
			break;
		case "hamr":
			key = "hamr_zm";
			break;
		case "m27":
			key = "hk416_zm";
			break;
		case "exe":
			key = "judge_zm";
			break;
		case "kap":
			key = "kard_zm";
			break;
		case "bk":
			key = "knife_ballistic_zm";
			break;
		case "ksg":
			key = "ksg_zm";
			break;
		case "wm":
			key = "m32_zm";
			break;
		case "mg":
			key = "mg08_zm";
			break;
		case "lsat":
			key = "lsat_zm";
			break;
		case "dm":
			key = "minigun_alcatraz_zm";
		case "mp40":
			key = "mp40_stalker_zm";
			break;
		case "pdw":
			key = "pdw57_zm";
			break;
		case "pyt":
			key = "python_zm";
			break;
		case "rnma":
			key = "rnma_zm";
			break;
		case "type":
			key = "type95_zm";
			break;
		case "rpd":
			key = "rpd_zm";
			break;
		case "s12":
			key = "saiga12_zm";
			break;
		case "scar":
			key = "scar_zm";
			break;
		case "m1216":
			key = "srm1216_zm";
			break;
		case "tommy":
			key = "thompson_zm";
			break;
		case "chic":
			key = "qcw05_zm";
			break;
		case "rpg":
			key = "usrpg_zm";
			break;
		case "m8":
			key = "xm8_zm";
			break;
		case "m16":
			key = "m16_zm";
			break;
		case "remington":
			key = "870mcs_zm";
			break;
		case "oly":
		case "olympia":
			key = "rottweil72_zm";
			break;
		case "mp5":
			key = "mp5k_zm";
			break;
		case "ak74":
			key = "ak74u_zm";
			break;
		case "m14":
			key = "m14_zm";
			break;
		case "svu":
			key = "svu_zm";
			break;
		default:
			key = weapon_str;
	}

	if (!isDefined(verifier))
		verifier = ::default_weapon_verification;

	key = [[verifier]](key);

	debug_print("get_weapon_key(): weapon_key: " + key);
	return key;
}

default_weapon_verification()
{
    weapon_key = get_base_weapon_name(weapon_key, 1);

    if (!is_weapon_included(weapon_key))
        return "";

	return weapon_key;
}

box_weapon_verification(weapon_key)
{
	if (isDefined(level.zombie_weapons[weapon_key]) && level.zombie_weapons[weapon_key].is_in_box)
		return weapon_key;
	return "";
}

fridge_weapon_verification(weapon_key)
{
    wpn = get_base_weapon_name(weapon_key, 1);
	// debug_print("fridge_weapon_verification(): wpn='" + wpn + "' weapon_key='" + weapon_key + "'");

    if (!is_weapon_included(wpn))
        return "";

    if (is_offhand_weapon(wpn) || is_limited_weapon(wpn))
        return "";

    return wpn;
}

fridge_pap_weapon_verification(weapon_key)
{
    weapon_key = fridge_weapon_verification(weapon_key);
	// debug_print("fridge_pap_weapon_verification(): weapon_key='" + weapon_key + "'");
	if (weapon_key != "")
		return level.zombie_weapons[weapon_key].upgrade_name;
	return "";
}

weapon_display_wrapper(weapon_key)
{
	if (weapon_key == "emp_grenade_zm")
		return "Emp Grenade";
	if (weapon_key == "cymbal_monkey_zm")
		return "Cymbal Monkey";
	
	return get_weapon_display_name(weapon_key);
}

pull_character_preset(character_index)
{
	preset = array();
	preset["model"] = undefined;
	preset["viewmodel"] = undefined;
	preset["favourite_wall_weapons"] = undefined;
	preset["whos_who_shader"] = undefined;
	preset["talks_in_danger"] = undefined;
	preset["rich_sq_player"] = undefined;
	preset["character_name"] = undefined;
	preset["has_weasel"] = undefined;
	preset["voice"] = undefined;
	preset["is_female"] = 0;

	if (is_tranzit() || is_die_rise() || is_buried())
	{
		if (character_index == 0)
		{
			preset["model"] = "c_zom_player_oldman_fb";
			preset["viewmodel"] = "c_zom_oldman_viewhands";
			preset["favourite_wall_weapons"] = array("frag_grenade_zm", "claymore_zm");
			preset["whos_who_shader"] = "c_zom_player_oldman_dlc1_fb";
			preset["character_name"] = "Russman";

			if (is_die_rise())
				preset["model"] = "c_zom_player_oldman_dlc1_fb";
		}

		else if (character_index == 1)
		{
			preset["model"] = "c_zom_player_reporter_fb";
			preset["viewmodel"] = "c_zom_reporter_viewhands";
			preset["favourite_wall_weapons"] = array("beretta93r_zm");
			preset["whos_who_shader"] = "c_zom_player_reporter_dlc1_fb";
			preset["talks_in_danger"] = 1;
			preset["rich_sq_player"] = 1;
			preset["character_name"] = "Stuhlinger";

			if (is_die_rise())
				preset["model"] = "c_zom_player_reporter_dlc1_fb";
		}

		else if (character_index == 2)
		{
			preset["model"] = "c_zom_player_farmgirl_fb";
			preset["viewmodel"] = "c_zom_farmgirl_viewhands";
			preset["is_female"] = 1;
			preset["favourite_wall_weapons"] = array("rottweil72_zm", "870mcs_zm");
			preset["whos_who_shader"] = "c_zom_player_farmgirl_dlc1_fb";
			preset["character_name"] = "Misty";

			if (is_die_rise())
				preset["model"] = "c_zom_player_farmgirl_dlc1_fb";
		}

		else if (character_index == 3)
		{
			preset["model"] = "c_zom_player_engineer_fb";
			preset["viewmodel"] = "c_zom_engineer_viewhands";
			preset["favourite_wall_weapons"] = array("m14_zm", "m16_zm");
			preset["whos_who_shader"] = "c_zom_player_engineer_dlc1_fb";
			preset["character_name"] = "Marlton";

			if (is_die_rise())
				preset["model"] = "c_zom_player_engineer_dlc1_fb";
		}
	}

	else if (is_town() || is_farm() || is_depot() || is_nuketown())
	{
		if (character_index == 0)
		{
			preset["model"] = "c_zom_player_cia_fb";
			preset["viewmodel"] = "c_zom_suit_viewhands";
		}

		else if (character_index == 1)
		{
			preset["model"] = "c_zom_player_cdc_fb";
			preset["viewmodel"] = "c_zom_hazmat_viewhands";

			if (is_nuketown())
				preset["viewmodel"] = "c_zom_hazmat_viewhands_light";
		}
	}

	else if (is_mob())
	{
		if (character_index == 0)
		{
			preset["model"] = "c_zom_player_oleary_fb";
			preset["viewmodel"] = "c_zom_oleary_shortsleeve_viewhands";
			preset["favourite_wall_weapons"] = array("judge_zm");
			preset["character_name"] = "Finn";
		}

		else if (character_index == 1)
		{
			preset["model"] = "c_zom_player_deluca_fb";
			preset["viewmodel"] = "c_zom_deluca_longsleeve_viewhands";
			preset["favourite_wall_weapons"] = array("thompson_zm");
			preset["character_name"] = "Sal";
		}

		else if (character_index == 2)
		{
			preset["model"] = "c_zom_player_handsome_fb";
			preset["viewmodel"] = "c_zom_handsome_sleeveless_viewhands";
			preset["favourite_wall_weapons"] = array("blundergat_zm");
			preset["character_name"] = "Billy";
		}

		else if (character_index == 3)
		{
			preset["model"] = "c_zom_player_arlington_fb";
			preset["viewmodel"] = "c_zom_arlington_coat_viewhands";
			preset["favourite_wall_weapons"] = array("ray_gun_zm");
			preset["character_name"] = "Arlington";
			preset["has_weasel"] = 1;
		}
	}

	else if (is_origins())
	{
		if (character_index == 0)
		{
			preset["model"] = "c_zom_tomb_dempsey_fb";
			preset["viewmodel"] = "c_zom_dempsey_viewhands";
			preset["character_name"] = "Dempsey";
		}

		else if (character_index == 1)
		{
			preset["model"] = "c_zom_tomb_nikolai_fb";
			preset["viewmodel"] = "c_zom_nikolai_viewhands";
			preset["character_name"] = "Nikolai";
			preset["voice"] = "russian";
		}

		else if (character_index == 2)
		{
			preset["model"] = "c_zom_tomb_richtofen_fb";
			preset["viewmodel"] = "c_zom_richtofen_viewhands";
			preset["character_name"] = "Richtofen";
		}

		else if (character_index == 3)
		{
			preset["model"] = "c_zom_tomb_takeo_fb";
			preset["viewmodel"] = "c_zom_takeo_viewhands";
			preset["character_name"] = "Nikolai";
		}
	}

	return preset;
}

set_characters()
{
	level endon("end_game");
	self endon("disconnect");

	player_id = self.clientid;
	if (player_id > 3)
		player_id -= 4;

	dvar = "frfix_player" + player_id + "_character";
	if (getDvar(dvar) != "")
	{
		prop = pull_character_preset(getDvarInt(dvar));

		self setmodel(prop["model"]);
		self setviewmodel(prop["viewmodel"]);
		self set_player_is_female(prop["is_female"]);
		self.characterindex = getDvarInt(dvar);

		if (isDefined(prop["favourite_wall_weapons"]))
			self.favorite_wall_weapons_list = prop["favourite_wall_weapons"];
		if (isDefined(prop["whos_who_shader"]))
			self.whos_who_shader = prop["whos_who_shader"];
		if (isDefined(prop["talks_in_danger"]))
			self.talks_in_danger = prop["talks_in_danger"];
		if (isDefined(prop["rich_sq_player"]))
			level.rich_sq_player = self;
		if (isDefined(prop["character_name"]))
			self.character_name = prop["character_name"];
		if (isDefined(prop["has_weasel"]))
			level.has_weasel = prop["has_weasel"];
		if (isDefined(prop["voice"]))
			self.voice = prop["voice"];

		debug_print("Read value '" + getDvar(dvar) + "' from dvar '" + dvar + "' for player '" + self.name + "' with ID '" + self.clientid + "' Set character '" + prop["model"] + "'");
	}
}
