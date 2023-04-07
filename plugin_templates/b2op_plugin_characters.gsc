main()
{
    thread safe_init();
}

safe_init()
{
    initialize_vars();

    /* CIA / CDC maps */
    level.B2OP_PLUGIN_CHARACTER["town"]["white"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["town"]["blue"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["town"]["yellow"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["town"]["green"] = undefined;

    /* Tranzit characters maps */
    level.B2OP_PLUGIN_CHARACTER["tranzit"]["white"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["tranzit"]["blue"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["tranzit"]["yellow"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["tranzit"]["green"] = undefined;

    /* Mob characters */
    level.B2OP_PLUGIN_CHARACTER["mob"]["white"] = "weasel";
    level.B2OP_PLUGIN_CHARACTER["mob"]["blue"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["mob"]["yellow"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["mob"]["green"] = undefined;

    /* Origins characters */
    level.B2OP_PLUGIN_CHARACTER["origins"]["white"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["origins"]["blue"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["origins"]["yellow"] = undefined;
    level.B2OP_PLUGIN_CHARACTER["origins"]["green"] = undefined;

    thread clear_variable();
}

initialize_vars()
{
    level.B2OP_PLUGIN_CHARACTER = array();
    level.B2OP_PLUGIN_CHARACTER["town"] = array();
    level.B2OP_PLUGIN_CHARACTER["tranzit"] = array();
    level.B2OP_PLUGIN_CHARACTER["mob"] = array();
    level.B2OP_PLUGIN_CHARACTER["origins"] = array();
}

clear_variable()
{
    level endon("end_game");

    level waittill("end_of_round");
    level.B2OP_PLUGIN_CHARACTER = undefined;
}