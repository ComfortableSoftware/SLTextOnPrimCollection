integer DISPLAY_STRING   = 204000;
integer DISPLAY_EXTENDED  = 204001;
integer REMAP_INDICES    = 204002;
integer RESET_INDICES    = 204003;
integer SET_FADE_OPTIONS  = 204004;
integer SET_FONT_TEXTURE  = 204005;
integer SET_LINE_COLOR   = 204006;
integer SET_COLOR      = 204007;
integer RESCAN_LINKSET   = 204008;


integer gToggle;

default
{
  state_entry()
  {
    llListen(0,"",NULL_KEY,"");

  }


  listen(integer channel,string name, key id, string message)
  {
    if (gToggle)
      llMessageLinked(LINK_THIS,DISPLAY_STRING,name + ":"+ message,"0");
    else
      llMessageLinked(LINK_THIS,DISPLAY_STRING,name + ":"+ message,"1");

    gToggle=!gToggle;

  }
}
