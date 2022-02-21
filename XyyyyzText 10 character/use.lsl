default
{
    state_entry()
    {
        llListen(PUBLIC_CHANNEL, "", NULL_KEY, "");
    }

    listen(integer channel, string name, key id, string message)
    {
        llMessageLinked(LINK_THIS, 1, message, llGetKey());
    }
}
