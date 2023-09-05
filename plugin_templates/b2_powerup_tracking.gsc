#include maps\mp\zombies\_zm_powerups;

main()
{
    replaceFunc(maps\mp\zombies\_zm_powerups::powerup_drop, ::powerup_drop_tracking);
    level.B2_POWERUP_TRACKING = ::init_powerup_tracking;
}

init_powerup_tracking()
{
	level thread powerup_point_drop_watcher();
	level thread powerup_odds_watcher();
	level thread powerup_vars_controller();
}

powerup_point_drop_watcher()
{
	level endon("end_game");

	while (true)
	{
		wait 0.05;

		if (!level.zombie_vars["zombie_drop_item"])
			continue;

		while (level.zombie_vars["zombie_drop_item"])
			wait 0.05;
		print("INFO: Point drop");
	}
}

powerup_vars_controller()
{
	level endon("end_game");

	while (true)
	{
		level waittill("start_of_round");

		if (level.powerup_drop_count != 0 || level.zombie_powerup_array.size < 1)
		{
			print("WARN: Possible issue with powerup related variables\nlevel.powerup_drop_count=" + level.powerup_drop_count + " level.zombie_powerup_array.size=" + level.zombie_powerup_array.size + ".\nPlease send screenshot of the console to Zi0#1063");
			print_scheduler("^1WARNING: ^7Possible issue with powerups");
			print_scheduler("Check console for details");
		}
	}
}

powerup_odds_watcher()
{
	level endon("end_game");

	while (true)
	{
		level waittill("powerup_check", chance);
		print("INFO: rand_drop = " + chance);
		chance = undefined;
	}
}

powerup_drop_tracking(drop_point)
{
    if (level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"])
        return;

    if (!isdefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0)
        return;

    rand_drop = randomint(100);
	level notify("powerup_check", rand_drop);

    if (rand_drop > 2)
    {
        if (!level.zombie_vars["zombie_drop_item"])
            return;

        debug = "score";
    }
    else
        debug = "random";

    playable_area = getentarray("player_volume", "script_noteworthy");
    level.powerup_drop_count++;
    powerup = maps\mp\zombies\_zm_net::network_safe_spawn("powerup", 1, "script_model", drop_point + vectorscale((0, 0, 1), 40.0));
    valid_drop = 0;

    for (i = 0; i < playable_area.size; i++)
    {
        if (powerup istouching(playable_area[i]))
            valid_drop = 1;
    }

    if (valid_drop && level.rare_powerups_active)
    {
        pos = (drop_point[0], drop_point[1], drop_point[2] + 42);

        if (check_for_rare_drop_override(pos))
        {
            level.zombie_vars["zombie_drop_item"] = 0;
            valid_drop = 0;
        }
    }

    if (!valid_drop)
    {
        level.powerup_drop_count--;
        powerup delete();
        return;
    }

    powerup powerup_setup();
    print_powerup_drop(powerup.powerup_name, debug);
    powerup thread powerup_timeout();
    powerup thread powerup_wobble();
    powerup thread powerup_grab();
    powerup thread powerup_move();
    powerup thread powerup_emp();
    level.zombie_vars["zombie_drop_item"] = 0;
    level notify("powerup_dropped", powerup);
}
