main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::fixed_wait_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::fixed_wait_network_frame);
}

fixed_wait_network_frame()
{
    if (level.players.size == 1)
        wait 0.1;
    else if (numremoteclients())
    {
        snapshot_ids = getsnapshotindexarray();

        for (acked = undefined; !isdefined(acked); acked = snapshotacknowledged(snapshot_ids))
            level waittill("snapacknowledged");
    }
    else
        wait 0.1;
}
