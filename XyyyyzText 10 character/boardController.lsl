////////////////////////////////////////////
// XyyyyzText Board Control
//
// Written by Tdub Dowler
// Modified by Awsoonn Rawley
// Refactored by Strife Onizuka
// Highly modified by Criz Collins to support different text for each line
////////////////////////////////////////////


/////////////// VARIABLES /////////////////
// set the number of characters for each line here
// if you have created 6 child prims in each line
// to display the text you'll have 60 characters.
integer linelength = 80;
///////////// END VARIABLES ////////////////


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
list replace;

string Replace(string source, list replace)
{
  while (llSubStringIndex(source, llList2String(replace, 0)) != -1)
  {
    integer index = llSubStringIndex(source, llList2String(replace, 0));
    string temp = llDeleteSubString(source, index, (index + (llStringLength(llList2String(replace, 0)) - 1)));
    source = llInsertString(temp, index, llList2String(replace, 1));
  }
  return source;
}

SetText(string msg)
{
  msg = Replace(msg, ["ä", "ae"]);
  msg = Replace(msg, ["ö", "oe"]);
  msg = Replace(msg, ["ü", "ue"]);
  msg = Replace(msg, ["ß", "ss"]);

  list msglist = llParseStringKeepNulls(msg, ["|"], []);
  string space = " ";
  msg = "";

  integer n;
  for (n=0; n<llGetListLength(msglist); n++)
  {
    string thisline = llList2String(msglist, n);
    integer strlen = llStringLength(thisline);
    if (strlen >= (linelength-1))
    {
      thisline = llGetSubString(thisline, 0, (linelength-4))+"...";
    }
    else
    {
      integer m;
      for (m=0; m<(linelength-strlen); m++)
      {
        thisline += space;
      }
    }

    msg += thisline;
  }

  llMessageLinked(LINK_ALL_CHILDREN, SET_LINE_CHANNEL, msg, "");
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
    llMessageLinked(LINK_ALL_OTHERS, DISPLAY_STRING, LOAD_MSG, "");

    integer StartLink = llGetLinkNumber() + 1;
    // Configure the board.
    integer i = 0;
    do
      llMessageLinked(StartLink + i, SET_CELL_INFO, llList2CSV([SET_LINE_CHANNEL, i * 10]), "");
    while( ++i < prims );
  }

  link_message(integer sender_num, integer num, string str, key id)
  {
    SetText(str);
  }
}
