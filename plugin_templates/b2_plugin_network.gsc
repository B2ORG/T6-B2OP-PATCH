#include maps\mp\gametypes_zm\_hud_util;

init()
{
    level.B2_NETWORK_HUD = ::network_frame_hud;
}

network_frame_hud()
{
	level endon("end_game");

	netframe_hud = createserverfontstring("default", 1.3);
	netframe_hud set_hud_properties("netframe_hud", "CENTER", "BOTTOM", 0, 28);
    netframe_hud setpoint("CENTER", "BOTTOM", 0, 28);
    netframe_hud.color = (1, 1, 1);
	netframe_hud.label = &"NETFRAME: ";
	netframe_hud.alpha = 1;

	while (true)
	{
		start_time = int(getTime());
		wait_network_frame();
		end_time = int(getTime());

		netframe_hud setValue(end_time - start_time);
	}
}
