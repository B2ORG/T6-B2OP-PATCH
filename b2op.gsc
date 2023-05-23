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

init()
{
	flag_init("game_started");
	flag_init("box_rigged");
	flag_init("permaperks_were_set");
	flag_init("start_permajug_remover");

	// Patch Config
	level.B2OP_CONFIG = array();
	level.B2OP_CONFIG["version"] = 1.4;
	level.B2OP_CONFIG["beta"] = false;
	level.B2OP_CONFIG["debug"] = false;

	level thread on_game_start();
}

on_game_start()
{
	level endon("end_game");

	// Func Config
	level.B2OP_CONFIG["hud_color"] = (1, 1, 1);
	level.B2OP_CONFIG["hud_enabled"] = true;
	level.B2OP_CONFIG["timers_enabled"] = true;
	level.B2OP_CONFIG["buildables_enabled"] = true;
	// level.B2OP_CONFIG["hordes_enabled"] = true;
	// level.B2OP_CONFIG["sph_enabled"] = true;
	level.B2OP_CONFIG["velocity_enabled"] = false;
	level.B2OP_CONFIG["give_permaperks"] = true;
	level.B2OP_CONFIG["fridge"] = true;
	level.B2OP_CONFIG["first_box_module"] = true;

	thread set_dvars();
	level thread on_player_joined();

	flag_wait("initial_blackscreen_passed");

    level thread b2op_main_loop();
	level thread timers();
	level thread first_box_handler();
	level thread perma_perks_setup();
	level thread fridge_handler();
	level thread buildable_controller();
    level thread hud_alpha_controller(); 
	safety_zio();
	safety_debugger();
	safety_beta();
}

on_player_joined()
{
	level endon("end_game");

	while(true)
	{
		level waittill("connected", player);
		player thread on_player_spawned();
		player thread on_player_spawned_permaperk();
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

	self thread welcome_prints();
	self thread evaluate_network_frame();
	self thread velocity_meter();
	self thread set_characters();
	self thread fill_up_bank();
	self thread buildable_stat();
}

on_player_spawned_permaperk()
{
	level endon("end_game");
    self endon("disconnect");

	/* We want to remove the perks before players spawn to prevent health bonus 
	The wait is essential, it allows the game to process permaperks internally before we override them */
	wait 2;

	if (has_permaperks_system() && flag("start_permajug_remover"))
		self remove_permaperk_wrapper("jugg");
}

b2op_main_loop()
{
    level endon("end_game");

    // debug_print("initialized b2op_main_loop");
    while (true)
    {
        level waittill("start_of_round");
        check_dvars();
        // level thread show_hordes();

		if (has_permaperks_system())
		{
			if (is_debug())
				level.players[0] remove_permaperk_wrapper("insta_kill", 2);

			wait 2;
			foreach(player in level.players)
			{
				player remove_permaperk_wrapper("jugg", 15);
				player remove_permaperk_wrapper("nube", 10);
			}
		}

        level waittill("end_of_round");
        level thread show_split();
    }
}

// Stubs

replaceFunc(arg1, arg2)
{
}

// Utilities

is_debug()
{
	if (b2op_config("debug"))
		return true;
	return false;
}

/*
debug_print(text)
{
	if (!is_debug())
		return;

	if (is_plutonium())
		print("DEBUG: " + text);
	else
		iprintln("DEBUG: " + text);
}
*/

generate_watermark_slots()
{
	slots = array();

	positions = array(0, -90, 90, -180, 180, -270, 270, -360, 360, -450, 450, -540, 540, -630, 630);

	foreach(pos in positions)
	{
		i = slots.size;
		slots[i] = array();
		slots[i]["pos"] = pos;
		slots[i]["perm_on"] = false;
		slots[i]["temp_on"] = false;
	}

	level.set_of_slots = slots;
}

get_watermark_position(mode)
{
	mode += "_on";
	for (i = 0; i < level.set_of_slots.size; i++)
	{
		if (!level.set_of_slots[i][mode])
		{
			level.set_of_slots[i][mode] = true;
			pos = level.set_of_slots[i]["pos"];
			if (pos < 640 && pos > -640)
				return pos;
			return 0;
		}
	}
	return 0;
}

generate_watermark(text, color, alpha_override)
{
	if (is_true(flag(text)))
		return;

    if (!isDefined(level.set_of_slots))
        generate_watermark_slots();

	x_pos = get_watermark_position("perm");
	if (!isDefined(x_pos))
		return;

	if (!isDefined(color))
		color = (1, 1, 1);

	if (!isDefined(alpha_override))
		alpha_override = 0.33;

    watermark = createserverfontstring("hudsmall" , 1.2);
	watermark setPoint("CENTER", "TOP", x_pos, -5);
	watermark.color = color;
	watermark setText(text);
	watermark.alpha = alpha_override;
	watermark.hidewheninmenu = 0;

	flag_set(text);

    level.num_of_watermarks++;
}

generate_temp_watermark(kill_on, text, color, alpha_override)
{
	level endon("end_game");

	if (is_true(flag(text)))
		return;

    if (!isDefined(level.set_of_slots))
        generate_watermark_slots();

	x_pos = get_watermark_position("temp");
	if (!isDefined(x_pos))
		return;

	if (!isDefined(color))
		color = (1, 1, 1);

	if (!isDefined(alpha_override))
		alpha_override = 0.33;

    twatermark = createserverfontstring("hudsmall" , 1.2);
	twatermark setPoint("CENTER", "TOP", x_pos, -17);
	twatermark.color = color;
	twatermark setText(text);
	twatermark.alpha = alpha_override;
	twatermark.hidewheninmenu = 0;

	flag_set(text);

	while (level.round_number < kill_on)
		level waittill("end_of_round");

	twatermark.alpha = 0;
	twatermark destroy_hud();

	/* Cleanup slots array if there are no huds to track */
	for (i = 0; i < level.set_of_slots.size; i++)
	{
		if (level.set_of_slots[i]["pos"] == x_pos)
			level.set_of_slots[i]["temp_on"] = false;
	}
}

print_scheduler(content, player)
{
	// debug_print("print_scheduler(content='" + content + ")");
    if (isDefined(player))
	{
		// debug_print(player.name + ": print scheduled: " + content);
        player thread player_print_scheduler(content);
	}
    else
	{
		// debug_print("general: print scheduled: " + content);
        foreach (player in level.players)
            player thread player_print_scheduler(content);
	}
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
	/* Returns true for Pluto versions r2693 and above */
	if (getDvar("cg_weaponCycleDelay") == "")
		return false;
	return true;
}

safe_restart()
{
	if (is_plutonium())
		map_restart();
	else
		level notify("end_game");
}

has_magic()
{
    if (is_true(level.enable_magic))
        return true;
    return false;
}

has_permaperks_system()
{
	/* Refer to init_persistent_abilities() */
	if (isDefined(level.pers_upgrade_boards))
		return true;
	return false;
}

is_special_round()
{
	if (is_true(flag("dog_round")))
		return true;

	if (is_true(flag("leaper_round")))
		return true;

	return false;
}

is_tracking_buildables()
{
	if (is_buried() || is_die_rise())
		return true;
	return false;
}

get_zombies_left()
{
	return maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total;
}

get_hordes_left()
{
	return int((get_zombies_left() / 24) * 100) / 100;
}

wait_for_message_end()
{
	wait getDvarFloat("con_gameMsgWindow0FadeInTime") + getDvarFloat("con_gameMsgWindow0MsgTime") + getDvarFloat("con_gameMsgWindow0FadeOutTime");
}

b2op_config(key)
{
	if (is_true(level.B2OP_CONFIG[key]))
		return true;
	return false;
}

set_hud_properties(hud_key, x_align, y_align, x_pos, y_pos, col)
{
	if (!isDefined(col))
		col = level.B2OP_CONFIG["hud_color"];

	if (isDefined(level.B2OP_PLUGIN_HUD))
	{
		data = level.B2OP_PLUGIN_HUD[hud_key];
		if (isDefined(data))
		{
			if (isDefined(data["x_align"]))
				x_align = data["x_align"];
			if (isDefined(data["y_align"]))
				y_align = data["y_align"];
			if (isDefined(data["x_pos"]))
				x_pos = data["x_pos"];
			if (isDefined(data["y_pos"]))
				y_pos = data["y_pos"];
			if (isDefined(data["color"]))
				col = data["color"];
		}
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

set_dvars()
{
	level endon("end_game");

	if (is_tranzit() || is_die_rise() || is_mob() || is_buried())
    	level.round_start_custom_func = ::trap_fix;

    setdvar("player_strafeSpeedScale", 1);
    setdvar("player_backSpeedScale", 0.9);
    setdvar("g_speed", 190);
    setdvar("con_gameMsgWindow0Filter", "gamenotify obituary");
    setdvar("sv_cheats", 0);

	init_dvar("timers");
	init_dvar("buildables");
	// init_dvar("hordes");
	init_dvar("velocity");
}

check_dvars()
{
    if (getDvar("sv_cheats") != "0")
        generate_watermark("SVCHEATS", (0.8, 0, 0));

    if (getDvar("g_speed") != "190")
        generate_watermark("GSPEED", (0.8, 0, 0));
}

init_dvar(dvar_str)
{
	if (getDvar(dvar_str) != "")
		return;
	if (b2op_config(dvar_str + "_enabled"))
		setDvar(dvar_str, "1");
	else
		setDvar(dvar_str, "0");
}

award_points(amount)
{
	level endon("end_game");
	self endon("disconnect");

	if (is_mob())
		flag_wait("afterlife_start_over");
	self.score = amount;
}

safety_zio()
{
	// Songs
	if (isDefined(level.SONG_TIMING))
	{
		print_scheduler("^1SONG PATCH DETECTED!!!");
		emulate_menu_call("endgame");
	}

	// First Room Fix
	if (isDefined(level.FRFIX_CONFIG))
	{
		print_scheduler("^1FIRST ROOM FIX DETECTED!!!");
		emulate_menu_call("endgame");
	}
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

safety_beta()
{
	if (b2op_config("beta"))
		generate_watermark("BETA", (0, 0.8, 0));
}

evaluate_network_frame()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

	start_time = int(getTime());
	wait_network_frame();
	end_time = int(getTime());
	network_frame_len = (end_time - start_time) / 1000;
    net_frame_good = false;

    /* To avoid direct float equality evaluation */
    if (level.players.size == 1)
    {
        if (network_frame_len > 0.06 && network_frame_len < 0.14)
            net_frame_good = true;
    }
    else
    {
        if (network_frame_len < 0.09)
            net_frame_good = true;
    }

    if (net_frame_good)
        print_scheduler("Network Frame: ^2GOOD", self);
    else
    {
        print_scheduler("Network Frame: ^1BAD", self);
		generate_watermark("NETWORK FRAME", (0.8, 0, 0));
    }
}

trap_fix()
{
    rnd_155 = 1044606905;

    if (level.zombie_health <= rnd_155)
        return;

    level.zombie_health = rnd_155;

    foreach (zombie in get_round_enemy_array())
    {
        if (zombie.health > rnd_155)
            zombie.heath = rnd_155;
    }
}

hud_alpha_controller()
{
    level endon("end_game");

    while (true)
    {
        if (getDvar("timers") == "0")
        {
            if (isDefined(level.timer_hud) && level.timer_hud.alpha > 0)
                level.timer_hud.alpha = 0;
            if (isDefined(level.round_hud) && level.round_hud.alpha > 0)
                level.round_hud.alpha = 0;
        }
        else if (getDvar("timers") == "1")
        {
            if (isDefined(level.timer_hud) && level.timer_hud.alpha == 0)
                level.timer_hud.alpha = 1;
            if (isDefined(level.round_hud) && level.round_hud.alpha == 0)
                level.round_hud.alpha = 1;
        }

		if (getDvar("buildables") == "0")
		{
            if (isDefined(level.springpad_hud) && level.springpad_hud.alpha > 0)
                level.springpad_hud.alpha = 0;
            if (isDefined(level.subwoofer_hud) && level.subwoofer_hud.alpha > 0)
                level.subwoofer_hud.alpha = 0;
            if (isDefined(level.turbine_hud) && level.turbine_hud.alpha > 0)
                level.turbine_hud.alpha = 0;
		}
        else if (getDvar("buildables") == "1")
        {
            if (isDefined(level.springpad_hud) && level.springpad_hud.alpha == 0)
                level.springpad_hud.alpha = 1;
            if (isDefined(level.subwoofer_hud) && level.subwoofer_hud.alpha == 0)
                level.subwoofer_hud.alpha = 1;
            if (isDefined(level.turbine_hud) && level.turbine_hud.alpha == 0)
                level.turbine_hud.alpha = 1;
		}


        wait 0.05;
    }
}

timers()
{
    level endon("end_game");

	level.FRFIX_START = int(getTime() / 1000);
	flag_set("game_started");

    if (!b2op_config("hud_enabled"))
        return;

    level.timer_hud = createserverfontstring("big" , 1.6);
	level.timer_hud set_hud_properties("timer_hud", "TOPRIGHT", "TOPRIGHT", 60, -14);
	level.timer_hud.alpha = 1;
    level.timer_hud setTimerUp(0);

	level.round_hud = createserverfontstring("big" , 1.6);
	level.round_hud set_hud_properties("timer_hud", "TOPRIGHT", "TOPRIGHT", 60, 3);
	level.round_hud.alpha = 0;

    level waittill("start_of_round");
    while (isDefined(level.round_hud))
	{
		round_start = int(getTime() / 1000);
		hordes_count = get_hordes_left();
        level.round_hud setTimerUp(0);

		level waittill("end_of_round");
		round_end = int(getTime() / 1000) - round_start;

		/*
		if (is_round(57) && hordes_count > 2 && b2op_config("sph_enabled"))
			print_scheduler("SPH of round " + (level.round_number - 1) + ": ^1" + (int((round_end / hordes_count) * 1000) / 1000));
		*/

		level.round_hud keep_displaying_old_time(round_end);
	}
}

keep_displaying_old_time(time)
{
    level endon("end_game");
    level endon("start_of_round");

    while (true)
    {
        self setTimer(time - 0.1);
        wait 0.25;
    }
}

show_split()
{
	level endon("end_game");

    if (!b2op_config("hud_enabled") || getDvar("timers") == "0")
        return;

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
    print_scheduler("Round " + level.round_number + " time: ^1" + timestamp);
}

show_hordes()
{
	level endon("end_game");

    if (!b2op_config("hud_enabled") || getDvar("hordes") == "0")
        return;

    wait 0.05;

    if (!is_special_round() && is_round(50))
    {
        zombies_value = get_hordes_left();
        print_scheduler("HORDES ON " + level.round_number + ": ^3" + zombies_value);
    }
}

velocity_meter()
{
    self endon("disconnect");
    level endon("end_game");

    if (!b2op_config("hud_enabled"))
        return;

    player_wait_for_initial_blackscreen();

    self.hud_velocity = createfontstring("default" , 1.1);
	self.hud_velocity set_hud_properties("hud_velocity", "CENTER", "CENTER", "CENTER", 200);
	self.hud_velocity.alpha = 0.75;
	self.hud_velocity.hidewheninmenu = 1;

    while (true)
    {
        self velocity_visible(self.hud_velocity);

		velocity = int(length(self getvelocity() * (1, 1, 0)));
		self.hud_velocity velocity_meter_scale(velocity);
        self.hud_velocity setValue(velocity);

        wait 0.05;
    }
}

velocity_visible(hud)
{
    if (is_true(self.afterlife) || getDvar("velocity") == "0")
        hud.alpha = 0;
    else
        hud.alpha = 1;
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

buildable_hud()
{
    if (!b2op_config("hud_enabled"))
        return;
	
	level.springpad_hud = createserverfontstring("objective", 1.3);
	level.springpad_hud set_hud_properties("springpad_hud", "TOPLEFT", "TOPLEFT", -60, -17, (1, 1, 1));
	level.springpad_hud.label = &"SPRINGPADS: ^2";
	level.springpad_hud setValue(0);

	level.subwoofer_hud = createserverfontstring("objective", 1.3);
	level.subwoofer_hud set_hud_properties("subwoofer_hud", "TOPLEFT", "TOPLEFT", -60, 0, (1, 1, 1));
	level.subwoofer_hud.label = &"SUBWOOFERS: ^3";
	level.subwoofer_hud setValue(0);

	level.turbine_hud = createserverfontstring("objective", 1.3);
	level.turbine_hud set_hud_properties("turbine_hud", "TOPLEFT", "TOPLEFT", -60, 17, (1, 1, 1));
	level.turbine_hud.label = &"TURBINES: ^1";
	level.turbine_hud setValue(0);

	level.springpad_hud.alpha = 1;
	if (is_die_rise())
	{
		level.subwoofer_hud destroy();
		level.turbine_hud destroy();
	}
	else
	{
		level.subwoofer_hud.alpha = 1;
		level.turbine_hud.alpha = 1;
	}
}

fill_up_bank()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

    if (has_permaperks_system())
        self.account_value = level.bank_account_max;
}

perma_perks_setup()
{
	if (!has_permaperks_system())
		return;

	thread watch_permaperk_award();
	thread initialize_permaperks_safety();

	foreach (player in level.players)
		player thread award_permaperks_safe();
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
			/* Solo - Recommend restart */
			if (present_players == 1)
			{
				print_scheduler("Permaperks Awarded: ^3RESTART RECOMMENDED");
				break;
			}
			/* Coop Irony launchers - Recommend restart but more XD */
			else if (!is_plutonium())
			{
				print_scheduler("Permaperks Awarded: ^1RESTART STRONGLY RECOMMENDED");
				break;
			}
			/* Coop new Pluto - Automatic restart */
			else
			{
				print_scheduler("Permaperks Awarded: ^2MAP GONNA RESTART");
				wait 1.5;
				safe_restart();
			}
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

initialize_permaperks_safety()
{
	level endon("end_game");

	while (!is_round(15))
		wait 0.1;
	level waittill("start_of_round");
	wait 5;

	foreach(player in level.players)
		player remove_permaperk_wrapper("jugg");

	flag_set("start_permajug_remover");
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	if (!isDefined(maps_award))
		maps_award = array("zm_transit", "zm_highrise", "zm_buried");
	if (!isDefined(maps_take))
		maps_take = array();
	if (!isDefined(to_round))
		to_round = 255;

	permaperk = array();
	permaperk["code"] = code;
	permaperk["maps_award"] = maps_award;
	permaperk["maps_take"] = maps_take;
	permaperk["to_round"] = to_round;

	return permaperk;
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
	perks_to_process[perks_to_process.size] = permaperk_array("revive");
	perks_to_process[perks_to_process.size] = permaperk_array("multikill_headshots");
	perks_to_process[perks_to_process.size] = permaperk_array("perk_lose");
	perks_to_process[perks_to_process.size] = permaperk_array("jugg", undefined, undefined, 15);
	perks_to_process[perks_to_process.size] = permaperk_array("flopper", array("zm_buried"));
	perks_to_process[perks_to_process.size] = permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"));
	perks_to_process[perks_to_process.size] = permaperk_array("cash_back");
	perks_to_process[perks_to_process.size] = permaperk_array("sniper");
	perks_to_process[perks_to_process.size] = permaperk_array("insta_kill");
	perks_to_process[perks_to_process.size] = permaperk_array("pistol_points");
	perks_to_process[perks_to_process.size] = permaperk_array("double_points");

	self.frfix_awarding_permaperks = true;

	foreach (perk in perks_to_process)
	{
		self resolve_permaperk(perk);
		wait 0.05;
	}

	wait 0.5;
	perks_to_process = undefined;
	self.frfix_awarding_permaperks = undefined;
	self uploadstatssoon();
}

resolve_permaperk(perk)
{
	wait 0.05;

	perk_code = perk["code"];

	/* Too high of a round, return out */
	if (is_round(perk["to_round"]))
		return;

	if (isinarray(perk["maps_award"], level.script) && !self.pers_upgrades_awarded[perk_code])
	{
		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			self award_permaperk(stat_name, perk_code, stat_value);
		}
	}

	if (isinarray(perk["maps_take"], level.script) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}

award_permaperk(stat_name, perk_code, stat_value)
{
	// debug_print("awarding: " + stat_name + " " + perk_code + " " + stat_value);
	flag_set("permaperks_were_set");
	self.stats_this_frame[stat_name] = 1;
	self set_global_stat(stat_name, stat_value);
	self playsoundtoplayer("evt_player_upgrade", self);
}

remove_permaperk_wrapper(perk_code, round)
{
	if (!isDefined(round))
		round = 1;

	if (is_round(round) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}

remove_permaperk(perk_code)
{
	// debug_print("removing: " + perk_code);
	self.pers_upgrades_awarded[perk_code] = 0;
	self playsoundtoplayer("evt_player_downgrade", self);
}

fridge_handler()
{
	level endon("end_game");

	if (!has_permaperks_system() || !b2op_config("fridge"))
		return;

	// debug_print("currently in fridge='" + level.players[0] get_locker_stat() + "'");

	if (isDefined(level.B2OP_PLUGIN_FRIDGE))
	{
		thread [[level.B2OP_PLUGIN_FRIDGE]](::player_rig_fridge);
		print_scheduler("Fridge module: ^3LOADED PLUGIN");
	}
	else
	{
		print_scheduler("Fridge module: ^2AVAILABLE");
		if (is_plutonium())
			thread fridge_watch_chat();
		thread fridge_watch_dvar();
		thread fridge_watch_state();

		level waittill("terminate_fridge_process");
		print_scheduler("Fridge module: ^1DISABLED");
	}

	// Cleanup
	foreach(player in level.players)
	{
		if (isDefined(player.fridge_state))
			player.fridge_state = undefined;
	}
}

fridge_watch_dvar()
{
	level endon("end_game");
	level endon("terminate_fridge_process");

	setDvar("fridge", "");
	while (true)
	{
		wait 0.05;
		if (getDvar("fridge") == "")
			continue;

		rig_fridge(getDvar("fridge"));
		setDvar("fridge", "");
	}
}

fridge_watch_chat()
{
	level endon("end_game");
	level endon("terminate_fridge_process");

	while (true)
	{
		level waittill("say", message, player);

		if (isSubStr(message, "fridge all") && player ishost())
			rig_fridge(getSubStr(message, 11));
		else if (isSubStr(message, "fridge"))
			rig_fridge(getSubStr(message, 7), player);

		message = undefined;
	}
}

fridge_watch_state()
{
	level endon("end_game");

	fridge_claimed = false;

	while (!fridge_claimed)
	{
		foreach(player in level.players)
		{
			locker = player get_locker_stat();
			/* Save state of the locker, if it's any weapon */
			if (!isDefined(player.fridge_state) && locker != "")
				player.fridge_state = locker;
			/* If locker is saved, but stat is cleared, break out */
			else if (isDefined(player.fridge_state) && locker == "")
				fridge_claimed = true;
		}

		if (is_round(11))
			fridge_claimed = true;

		wait 0.25;
	}
	level notify("terminate_fridge_process");
}

rig_fridge(key, player)
{
	// debug_print("rig_fridge(): key=" + key + "'");

	if (isSubStr(key, "+"))
		weapon = get_weapon_key(getSubStr(key, 1), ::fridge_pap_weapon_verification);
	else
		weapon = get_weapon_key(key, ::fridge_weapon_verification);

	if (weapon == "")
		return;

	if (isDefined(player))
	{
		print_scheduler("You set your fridge weapon to: ^3" + weapon_display_wrapper(weapon), player);
		player player_rig_fridge(weapon);
	}
	else
	{
		print_scheduler(level.players[0].name + "^7 set your fridge weapon to: ^3" + weapon_display_wrapper(weapon));
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

	// Init thread counting box hits
	thread init_boxhits_watcher();
	// Scan weapons in the box
	thread scan_in_box();
	// First Box main loop
	thread first_box();
	// First Box location main loop
	thread first_box_location();
}

init_boxhits_watcher()
{
    level endon("end_game");
	level endon("break_firstbox");

	while (!isDefined(level.chests))
	{
		/* Escape if chests are not defined yet */
		if (!did_game_just_start())
			return;
		wait 0.05;
	}

	level.total_box_hits = 0;
	foreach(chest in level.chests)
		chest thread watch_box_state();

	/* Extra code for the purpose of location manager */
	while (level.total_box_hits == 0)
		wait 0.05;

	level notify("break_box_location");
}

watch_box_state()
{
    level endon("end_game");
	level endon("break_firstbox");

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

		thread generate_temp_watermark(20, "FIRST BOX", (0.5, 0.3, 0.7), 0.66);
		break;
    }
}

first_box()
{	
	if (!b2op_config("first_box_module"))
		return;

	level.rigged_hits = 0;
	thread print_scheduler("First Box module: ^2AVAILABLE");
	thread watch_for_finish_firstbox();
	thread box_watch_dvar();
	if (is_plutonium())
		thread box_watch_chat();
}

box_watch_dvar()
{
    level endon("end_game");
	level endon("break_firstbox");

	setDvar("fb", "");
	while (true)
	{
		wait 0.05;

		if (getDvar("fb") == "")
			continue;

		thread rig_box(getDvar("fb"), level.players[0]);
		wait_network_frame();

		while (flag("box_rigged"))
			wait 0.05;

		setDvar("fb", "");
	}
}

box_watch_chat()
{
    level endon("end_game");
	level endon("break_firstbox");

	while (true)
	{
		message = undefined;

		level waittill("say", message, player);

		if (isSubStr(message, "fb"))
			wpn_key = getSubStr(message, 3);
		else
			continue;

		thread rig_box(wpn_key, player);
		wait_network_frame();

		wpn_key = undefined;

		while (flag("box_rigged"))
			wait 0.05;
	}
}

rig_box(gun, player)
{
    level endon("end_game");

	weapon_key = get_weapon_key(gun, ::box_weapon_verification);
	if (isDefined(player))
		weapon_key = player player_box_weapon_verification(weapon_key);

	if (weapon_key == "")
	{
		print_scheduler("Wrong weapon key: ^1" + gun);
		return;
	}

	// weapon_name = level.zombie_weapons[weapon_key].name;
	print_scheduler(player.name + "^7 set box weapon to: ^3" + weapon_display_wrapper(weapon_key));
	thread generate_temp_watermark(20, "FIRST BOX", (0.5, 0.3, 0.7), 0.66);
	level.rigged_hits++;

	saved_check = level.special_weapon_magicbox_check;
	current_box_hits = level.total_box_hits;
	removed_guns = array();

	flag_set("box_rigged");
	// debug_print("FIRST BOX: flag('box_rigged'): " + flag("box_rigged"));

	level.special_weapon_magicbox_check = undefined;
	foreach(weapon in getarraykeys(level.zombie_weapons))
	{
		if ((weapon != weapon_key) && level.zombie_weapons[weapon].is_in_box == 1)
		{
			removed_guns[removed_guns.size] = weapon;
			level.zombie_weapons[weapon].is_in_box = 0;
			// debug_print("FIRST BOX: setting " + weapon + ".is_in_box to 0");
		}
	}

	/* Critical loop responsible for restoring proper state */
	while ((current_box_hits == level.total_box_hits) || !isDefined(level.total_box_hits))
	{
		if (is_round(11))
		{
			// debug_print("FIRST BOX: breaking out of First Box above round 10");
			break;
		}
		wait 0.05;
	}
	
	wait 5;

	level.special_weapon_magicbox_check = saved_check;

	// debug_print("FIRST BOX: removed_guns.size " + removed_guns.size);
	if (removed_guns.size > 0)
	{
		foreach(rweapon in removed_guns)
		{
			level.zombie_weapons[rweapon].is_in_box = 1;
			// debug_print("FIRST BOX: setting " + rweapon + ".is_in_box to 1");
		}
	}

	flag_clear("box_rigged");
}

watch_for_finish_firstbox()
{
    level endon("end_game");

	while (!is_round(11))
		wait 0.1;

	print_scheduler("First Box module: ^1" + "DISABLED");
	if (level.rigged_hits)
		print_scheduler("First box used: ^3" + level.rigged_hits + " ^7times");

	level notify("break_firstbox");
	// debug_print("FIRST BOX: notifying module to break");
	level.rigged_hits = undefined;
	level.total_box_hits = undefined;
}

first_box_location()
{
    level endon("end_game");
	level endon("break_firstbox");

	if (!b2op_config("first_box_module"))
		return;

	if (!is_town() && !is_nuketown() && !is_mob() && !is_origins())
		return;

	flag_wait("moving_chest_enabled");

	thread location_watch_dvar();
	thread location_watch_chat();
}

location_watch_dvar()
{
    level endon("end_game");
	level endon("break_firstbox");
	level endon("break_box_location");

	setDvar("lb", "");
	while (true)
	{
		wait 0.05;

		dvar = getDvar("lb");
		if (dvar == "")
			continue;

		process_selection = process_box_location(dvar);

		if (process_selection == "no box selected")
		{
			print_scheduler("Incorrect selection: ^1" + dvar);
			setDvar("lb", "");
			continue;
		}

		chests_script = array();
		foreach(chest in level.chests)
			chests_script[chests_script.size] = chest.script_noteworthy;

		if (!isinarray(chests_script, process_selection))
			continue;

		thread move_chest(process_selection);
		level notify("break_box_location");
	}
}

location_watch_chat()
{
    level endon("end_game");
	level endon("break_firstbox");
	level endon("break_box_location");

	while (true)
	{
		level waittill("say", message, player, ishidden);

		if (isSubStr(message, "lb"))
			loc_selection = getSubStr(message, 3);
		else
			continue;

		process_selection = process_box_location(loc_selection);

		if (process_selection == "no box selected")
		{
			print_scheduler("Incorrect selection: ^1" + loc_selection);
			continue;
		}

		chests_script = array();
		foreach(chest in level.chests)
			chests_script[chests_script.size] = chest.script_noteworthy;

		if (!isinarray(chests_script, process_selection))
			continue;

		thread move_chest(process_selection);
		level notify("break_box_location");
	}
}

move_chest(box)
{
	level endon("end_game");

	if (isDefined(level._zombiemode_custom_box_move_logic))
		kept_move_logic = level._zombiemode_custom_box_move_logic;

	level._zombiemode_custom_box_move_logic = ::force_next_location;
	foreach(chest in level.chests)
	{
		if (!chest.hidden && chest.script_noteworthy == box)
		{
			print_scheduler("Box already in selected location");
			return;
		}
		else if (!chest.hidden)
		{
			level.chest_min_move_usage = 8;
			print_box_location(box);

			flag_set("moving_chest_now");
			chest thread maps\mp\zombies\_zm_magicbox::treasure_chest_move();

			wait 0.05;
			level notify("weapon_fly_away_start");
			wait 0.05;
			level notify("weapon_fly_away_end");
			break;
		}
	}

	while (flag("moving_chest_now"))
		wait 0.05;

	if (isDefined(kept_move_logic))
		level._zombiemode_custom_box_move_logic = kept_move_logic;

	level.chest_min_move_usage = 4;
}

force_next_location()
{
	for (b=0; b<level.chests.size; b++)
	{
		if (level.chests[b].script_noteworthy == level.chest_name)
			level.chest_index = b;
	}
}

process_box_location(input_msg)
{
	// debug_print("Input for 'lb': " + input_msg);
	switch (tolower(input_msg))
	{
		case "dt":
			return "town_chest_2";
		case "qr":
			return "town_chest";
		case "cafe":
			return "cafe_chest";
		case "warden":
			return "start_chest";
		case "yellow":
			return "start_chest2";
		case "green":
			return "start_chest1";
		case "2":
			return "bunker_tank_chest";
		case "3":
			return "bunker_cp_chest";
		default:
			return "no box selected";
	}
}

print_box_location(loc)
{
	switch (loc)
	{
		case "town_chest_2":
			print_scheduler("Box moving to: ^3Double Tap Cage");
			break;
		case "town_chest":
			print_scheduler("Box moving to: ^3Quick Revive Room");
			break;
		case "cafe_chest":
			print_scheduler("Box moving to: ^3Cafeteria");
			break;
		case "start_chest":
			print_scheduler("Box moving to: ^3Warden's Office");
			break;
		case "start_chest2":
			print_scheduler("Box moving to: ^3Yellow House");
			break;
		case "start_chest1":
			print_scheduler("Box moving to: ^3Green House");
			break;
		case "bunker_tank_chest":
			print_scheduler("Box moving to: ^3Generator 2");
			break;
		case "bunker_cp_chest":
			print_scheduler("Box moving to: ^3Generator 3");
			break;
		default:
			print_scheduler("Box moving to: ^2" + loc);
	}
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

	// debug_print("get_weapon_key(): weapon_key: " + key);
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
	if (!is_true(level.zombie_weapons[weapon_key].is_in_box))
		return "";
	return weapon_key;
}

player_box_weapon_verification(weapon_key)
{
	if (self has_weapon_or_upgrade(weapon_key))
		return "";
	if (!limited_weapon_below_quota(weapon_key, self, getentarray("specialty_weapupgrade", "script_noteworthy")))
		return "";

	switch (weapon_key)
	{
		case "ray_gun_zm":
			if (self has_weapon_or_upgrade("raygun_mark2_zm"))
				return "";
		case "raygun_mark2_zm":
			if (self has_weapon_or_upgrade("ray_gun_zm"))
				return "";
	}

	return weapon_key;
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

	/* Give set attachment if weapon supports it */
	att = fridge_pap_weapon_attachment_rules(weapon_key);
	if (weapon_key != "" && weapon_supports_this_attachment(weapon_key, att))
	{
		base = get_base_name(weapon_key);
		return level.zombie_weapons[base].upgrade_name + "+" + att;
	}
	/* Else just give base attachment */
	else if (weapon_key != "")
	{
		return get_upgrade_weapon(weapon_key);
	}
	return weapon_key;
}

fridge_pap_weapon_attachment_rules(weapon_key)
{
	switch (weapon_key)
	{
		default:
			return "mms";
	}
}

weapon_display_wrapper(weapon_key)
{
	if (weapon_key == "emp_grenade_zm")
		return "Emp Grenade";
	if (weapon_key == "cymbal_monkey_zm")
		return "Cymbal Monkey";
	
	return get_weapon_display_name(weapon_key);
}

pull_character_preset(character_name)
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
		switch(toLower(character_name))
		{
			case "russman":
				preset["index"] = 0;
				preset["model"] = "c_zom_player_oldman_fb";
				preset["viewmodel"] = "c_zom_oldman_viewhands";
				preset["favourite_wall_weapons"] = array("frag_grenade_zm", "claymore_zm");
				preset["whos_who_shader"] = "c_zom_player_oldman_dlc1_fb";
				preset["character_name"] = "Russman";

				if (is_die_rise())
					preset["model"] = "c_zom_player_oldman_dlc1_fb";

				break;

			case "stuhlinger":
				preset["index"] = 1;
				preset["model"] = "c_zom_player_reporter_fb";
				preset["viewmodel"] = "c_zom_reporter_viewhands";
				preset["favourite_wall_weapons"] = array("beretta93r_zm");
				preset["whos_who_shader"] = "c_zom_player_reporter_dlc1_fb";
				preset["talks_in_danger"] = 1;
				preset["rich_sq_player"] = 1;
				preset["character_name"] = "Stuhlinger";

				if (is_die_rise())
					preset["model"] = "c_zom_player_reporter_dlc1_fb";

				break;

			case "misty":
				preset["index"] = 2;
				preset["model"] = "c_zom_player_farmgirl_fb";
				preset["viewmodel"] = "c_zom_farmgirl_viewhands";
				preset["is_female"] = 1;
				preset["favourite_wall_weapons"] = array("rottweil72_zm", "870mcs_zm");
				preset["whos_who_shader"] = "c_zom_player_farmgirl_dlc1_fb";
				preset["character_name"] = "Misty";

				if (is_die_rise())
					preset["model"] = "c_zom_player_farmgirl_dlc1_fb";

				break;

			case "marlton":
				preset["index"] = 3;
				preset["model"] = "c_zom_player_engineer_fb";
				preset["viewmodel"] = "c_zom_engineer_viewhands";
				preset["favourite_wall_weapons"] = array("m14_zm", "m16_zm");
				preset["whos_who_shader"] = "c_zom_player_engineer_dlc1_fb";
				preset["character_name"] = "Marlton";

				if (is_die_rise())
					preset["model"] = "c_zom_player_engineer_dlc1_fb";
			
				break;
		}
	}

	else if (is_town() || is_farm() || is_depot() || is_nuketown())
	{
		switch(toLower(character_name))
		{
			case "cia":
				preset["index"] = 0;
				preset["model"] = "c_zom_player_cia_fb";
				preset["viewmodel"] = "c_zom_suit_viewhands";
				break;
			case "cdc":
				preset["index"] = 1;
				preset["model"] = "c_zom_player_cdc_fb";
				preset["viewmodel"] = "c_zom_hazmat_viewhands";

				if (is_nuketown())
					preset["viewmodel"] = "c_zom_hazmat_viewhands_light";

				break;
		}
	}

	else if (is_mob())
	{
		switch(toLower(character_name))
		{
			case "finn":
				preset["index"] = 0;
				preset["model"] = "c_zom_player_oleary_fb";
				preset["viewmodel"] = "c_zom_oleary_shortsleeve_viewhands";
				preset["favourite_wall_weapons"] = array("judge_zm");
				preset["character_name"] = "Finn";
				break;

			case "sal":
				preset["index"] = 1;
				preset["model"] = "c_zom_player_deluca_fb";
				preset["viewmodel"] = "c_zom_deluca_longsleeve_viewhands";
				preset["favourite_wall_weapons"] = array("thompson_zm");
				preset["character_name"] = "Sal";
				break;

			case "billy":
				preset["index"] = 2;
				preset["model"] = "c_zom_player_handsome_fb";
				preset["viewmodel"] = "c_zom_handsome_sleeveless_viewhands";
				preset["favourite_wall_weapons"] = array("blundergat_zm");
				preset["character_name"] = "Billy";
				break;

			case "arlington":
			case "weasel":
				preset["index"] = 3;
				preset["model"] = "c_zom_player_arlington_fb";
				preset["viewmodel"] = "c_zom_arlington_coat_viewhands";
				preset["favourite_wall_weapons"] = array("ray_gun_zm");
				preset["character_name"] = "Arlington";
				preset["has_weasel"] = 1;
				break;
		}
	}

	else if (is_origins())
	{
		switch(toLower(character_name))
		{
			case "dempsey":
				preset["index"] = 0;
				preset["model"] = "c_zom_tomb_dempsey_fb";
				preset["viewmodel"] = "c_zom_dempsey_viewhands";
				preset["character_name"] = "Dempsey";
				break;

			case "nikolai":
				preset["index"] = 1;
				preset["model"] = "c_zom_tomb_nikolai_fb";
				preset["viewmodel"] = "c_zom_nikolai_viewhands";
				preset["character_name"] = "Nikolai";
				preset["voice"] = "russian";
				break;

			case "richtofen":
				preset["index"] = 2;
				preset["model"] = "c_zom_tomb_richtofen_fb";
				preset["viewmodel"] = "c_zom_richtofen_viewhands";
				preset["character_name"] = "Richtofen";
				break;

			case "takeo":
				preset["index"] = 3;
				preset["model"] = "c_zom_tomb_takeo_fb";
				preset["viewmodel"] = "c_zom_takeo_viewhands";
				preset["character_name"] = "Takeo";
				break;
		}
	}

	return preset;
}

set_characters()
{
	level endon("end_game");
	self endon("disconnect");

	/* We don't call clientid cause of Ancient */
	if (!isDefined(level.players))
		player_id = 0;
	else
		player_id = level.players.size - 1;

	while (player_id > 3)
		player_id -= 4;

	translation_layer = array("white", "blue", "yellow", "green");

	if (is_tranzit() || is_die_rise() || is_buried())
		map = "tranzit";
	else if (is_town() || is_farm() || is_depot() || is_nuketown())
		map = "town";
	else if (is_mob())
		map = "mob";
	else if (is_origins())
		map = "origins";

	translation_index = translation_layer[player_id];
	if (!isDefined(level.B2OP_PLUGIN_CHARACTER[map][translation_index]))
		return;
	character = level.B2OP_PLUGIN_CHARACTER[map][translation_index];

	prop = pull_character_preset(character);

	self setmodel(prop["model"]);
	self setviewmodel(prop["viewmodel"]);
	self set_player_is_female(prop["is_female"]);
	self.characterindex = prop["index"];

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
}

buildable_stat()
{
	if (!is_tracking_buildables())
		return;

	self.buildable_stats = array();
	self.buildable_stats["springpad_zm"] = self get_buildable_stat("springpad_zm");
	if (is_buried())
	{
		self.buildable_stats["turbine"] = self get_buildable_stat("turbine");
		self.buildable_stats["subwoofer_zm"] = self get_buildable_stat("subwoofer_zm");
	}
}

buildable_controller()
{
	level endon("end_game");

	if (!is_tracking_buildables())
		return;

	buildable_hud();

	while (true)
	{
		springpad_count = get_buildable_stat("springpad_zm");
		if (is_buried())
		{
			subwoofer_count = get_buildable_stat("subwoofer_zm");
			turbine_count = get_buildable_stat("turbine");

			level.subwoofer_hud setValue(subwoofer_count);
			level.turbine_hud setValue(turbine_count);
		}
		level.springpad_hud setValue(springpad_count);

		wait 0.1;
	}
}

get_buildable_stat(statname)
{
	if (self is_player())
		return self getdstat("buildables", statname, "buildable_pickedup");

	stat = 0;
	foreach(player in level.players)
	{
		player_stat = player getdstat("buildables", statname, "buildable_pickedup");
		player_stat -= player.buildable_stats[statname];
		stat += player_stat;
	}

	return stat;
}