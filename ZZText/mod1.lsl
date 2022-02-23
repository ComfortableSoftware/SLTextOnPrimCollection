// Enabling answering to only a specific channel instead of DISPLAY_STRING channel

// This heavily helps in producing multi cell boards:

integer ME;
default
{
    state_entry()
    {
        // need that each cell has its own number as object name starting from 1000 for instance
        ME = (integer)llGetObjectName();
    }

    // be sure we are answering only to channel ME
    link_message(integer sender, integer channel, string data, key id)
    {
        if (channel == (ME))
        {
            RenderString(data);
            return;
        }
    }
}
