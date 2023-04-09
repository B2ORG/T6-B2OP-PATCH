#include common_scripts\utility;

init()
{
    level waittill("frfix_init");
    level.B2OP_PLUGIN_FRIDGE = ::set_fridge;
    thread clear_variable();
}

set_fridge(func)
{
    switch (level.players[0].name)
    {
        default:
            foreach (player in level.players)
            {
                if (level.script == "zm_transit")
                    player [[func]]("mp5k_upgraded_zm");
                else if (level.script == "zm_highrise" || level.script == "zm_buried")
                    player [[func]]("an94_upgraded_zm");
            }
    }
}

clear_variable()
{
    level endon("end_game");

    level waittill("end_of_round");
    level.B2OP_PLUGIN_FRIDGE = undefined;
}