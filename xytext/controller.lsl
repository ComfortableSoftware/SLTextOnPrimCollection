////////////////////////////////////////////
// XyText Board Control
//
// Written by Tdub Dowler
// Modified by Awsoonn Rawley
// Refactored by Strife Onizuka
////////////////////////////////////////////


/////////////// CONSTANTS /////////////////
// XyText Message Map.
integer SET_LINE_CHANNEL  = 100100;
integer DISPLAY_STRING   = 204000;
integer DISPLAY_EXTENDED  = 204001;
integer REMAP_INDICES    = 204002;
integer RESET_INDICES    = 204003;
integer SET_CELL_INFO    = 204004;
string LOAD_MSG      = "Loading...";
///////////// END CONSTANTS ////////////////
integer prims;

SetText(string msg)
{
  llMessageLinked(LINK_SET, SET_LINE_CHANNEL, msg, "");
}

XytstOrder()
{
  // Fills each cell of the board with it's number.
  string str = "";
  integer i = 0;
  do
  {
    str += llGetSubString("     " + (string)i,-10,-1);
    llSetText("Generating Pattern: " + (string)i, <0,1,0>, 1.0);
  }while(++i < prims);

  llSetText("Displaying Order Test...", <0,1,0>, 1.0);

  // Send the message
  llMessageLinked(LINK_SET, SET_LINE_CHANNEL, str, "");

  llSetText("", ZERO_VECTOR, 0.0);
}


default
{
  on_rez(integer start)
  {
    llResetScript();
  }

  state_entry()
  {
    // Determin the number of prims.
    prims = llGetNumberOfPrims();

    // Clear the screen.
    llMessageLinked(LINK_SET, DISPLAY_STRING, LOAD_MSG, "");

    integer StartLink = llGetLinkNumber() + 1;
    // Configure the board.
    integer i = 0;
    do
      llMessageLinked(StartLink + i, SET_CELL_INFO, llList2CSV([SET_LINE_CHANNEL, i * 10]), "");
    while( ++i < prims );

    // Build this script in world to reveal the secret message!
    SetText( llBase64ToString("SXMgdGhhdCBub3QgY29vbCBvciB3aGF0PyA6KQ==") );
  }

  touch_end(integer num)
  {
    // This can be used to help find mislinked prims. Its not required at all.
    XytstOrder();
  }
}
