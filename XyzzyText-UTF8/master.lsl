// Modification on the master script

// Modifications are marked by
// SALAHZAR <lsl>
////////////////////////////////////////////
// XyzzyText v2.1.UTF8 (UTF8-support) by Salahzar Stenvaag
// XyzzyText v2.1 Script (Set Line Color) by Huney Jewell
// XyzzyText v2.0 Script (5 Face, Single Texture)
//
// Heavily Modified by Thraxis Epsilon, Gigs Taggart 5/2007 and Strife Onizuka 8/2007
// Rewrite to allow one-script-per-object operation w/ optional slaves
// Enable prim-label functionality
// Enabled Banking
//
// Modified by Kermitt Quirk 19/01/2006
// To add support for 5 face prim instead of 3
//
// Core XyText Originally Written by Xylor Baysklef
//
//
////////////////////////////////////////////

// This is broken on the SL source we pulled it from, we have not tested our attempts at unbreaking it.

/////////////// CONSTANTS ///////////////////
// XyText Message Map.
integer DISPLAY_STRING = 204000;
integer DISPLAY_EXTENDED = 204001;
integer REMAP_INDICES = 204002;
integer RESET_INDICES = 204003;
integer SET_FADE_OPTIONS = 204004;
integer SET_FONT_TEXTURE = 204005;
integer SET_LINE_COLOR = 204006;
integer SET_COLOR = 204007;
integer RESCAN_LINKSET = 204008;



//internal API
integer REGISTER_SLAVE = 205000;
integer SLAVE_RECOGNIZED = 205001;
integer SLAVE_DISPLAY = 205003;
integer SLAVE_DISPLAY_EXTENDED = 205004;
integer SLAVE_RESET = 205005;

// This is an extended character escape sequence.
string ESCAPE_SEQUENCE = "\\e";

// This is used to get an index for the extended character.
string EXTENDED_INDEX = "12345";

// Face numbers.
integer FACE_1 = 3;
integer FACE_2 = 7;
integer FACE_3 = 4;
integer FACE_4 = 6;
integer FACE_5 = 1;

// Used to hide the text after a fade-out.
key TRANSPARENT = "701917a8-d614-471f-13dd-5f4644e36e3c";
key null_key = NULL_KEY;

///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// This is the key of the font we are displaying.
// pick one and uncomment it

// key gFontTexture = "b2e7394f-5e54-aa12-6e1c-ef327b6bed9e";
// 48 pixel font

//key gFontTexture = "f226766c-c5ac-690e-9018-5a37367ae95a";
// 38 pixel font

//key gFontTexture= "ac955f98-74bb-290f-7eb6-dca54e5e4491";
//key gFontTexture= "e5efeead-c69e-eb81-e7bd-dad2bb787d2b";
// BitStream Vera Monotype
// SALAHZAR

// All displayable characters. Default to ASCII order. string gCharIndex; list decode=[];
// to handle special characters from CP850 page for european countries
// SALAHZAR

// This is whether or not to use the fade in/out special effect.
integer gCellUseFading = FALSE;
// This is how long to display the text before fading out (if using
// fading special effect).
// Note: < 0 means don't fade out.
float gCellHoldDelay = 1.0;

integer gSlaveRegistered; list gSlaveNames;

integer BANK_STRIDE=3; //offset, length, highest_dirty list gBankingData;

/////////// END GLOBAL VARIABLES ////////////

ResetCharIndex() {

    // Doktor Seuss added this and modified the next line down so this all works better in off world editors
    string dblqt = llChar(34)
    gCharIndex  = " !" + dblqt + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`";
    gCharIndex += "abcdefghijklmnopqrstuvwxyz{|}~\n\n\n\n\n";

    // special UTF-8 chars for European languages
    // SALAHZAR special chars according to a selection from CP850
    // these 80 chars correspond to the following chars in CP850 codepage: (some are not viewable in editor)
    // rows(11)="????????????????????"
    // rows(12)="?????????????????????"
    // rows(13)="????????????????????"
    // rows(14)="?????????????????????"
    // rows(15)="?????????????????????"
    // rows(16)="????????????????????"
    // rows(17)="???????????????????????????"
    // rows(18)="??????????????????????? "
    decode= [ "%C3%87", "%C3%BC", "%C3%A9", "%C3%A2", "%C3%A4", "%C3%A0", "%C3%A5", "%C3%A7", "%C3%AA", "%C3%AB" ];
    decode+=[ "%C3%A8", "%C3%AF", "%C3%AE", "%C3%AC", "%C3%84", "%C3%85", "%C3%89", "%C3%A6", "%C3%AE", "xxxxxx" ];
    decode+=[ "%C3%B6", "%C3%B2", "%C3%BB", "%C3%B9", "%C3%BF", "%C3%96", "%C3%9C", "%C2%A2", "%C2%A3", "%C2%A5" ];
    decode+=[ "%E2%82%A7", "%C6%92", "%C3%A1", "%C3%AD", "%C3%B3", "%C3%BA", "%C3%B1", "%C3%91", "%C2%AA", "%C2%BA"];
    decode+=[ "%C2%BF", "%E2%8C%90", "%C2%AC", "%C2%BD", "%C2%BC", "%C2%A1", "%C2%AB", "%C2%BB", "%CE%B1", "%C3%9F" ];
    decode+=[ "%CE%93", "%CF%80", "%CE%A3", "%CF%83", "%C2%B5", "%CF%84", "%CE%A6", "%CE%98", "%CE%A9", "%CE%B4" ];
    decode+=[ "%E2%88%9E", "%CF%86", "%CE%B5", "%E2%88%A9", "%E2%89%A1", "%C2%B1", "%E2%89%A5", "%E2%89%A4", "%E2%8C%A0", "%E2%8C%A1" ];
    decode+=[ "%C3%B7", "%E2%89%88", "%C2%B0", "%E2%88%99", "%C2%B7", "%E2%88%9A", "%E2%81%BF", "%C2%B2", "%E2%82%AC", "" ];

    // END
    // SALAHZAR
  }

vector GetGridOffset(integer index) {

  // Calculate the offset needed to display this character.
  integer Row = index / 10;
  integer Col = index % 10;

  // Return the offset in the texture.
  //return <-0.45 + 0.1 * Col, 0.45 - 0.1 * Row, 0.0>;
  return <-0.45 + 0.1 * Col, 0.425 - 0.05 * Row, 0.0>; // SALAHZAR modified vertical offsets for 512x1024 textures

}

ShowChars(integer link,vector grid_offset1, vector grid_offset2, vector grid_offset3, vector grid_offset4, vector grid_offset5) {

  // Set the primitive textures directly.

  // <-0.256, 0, 0>
  // <0, 0, 0>
  // <0.130, 0, 0>
  // <0, 0, 0>
  // <-0.74, 0, 0>


// SALAHZAR modified .1 to .05 to handle different sized texture

  llSetLinkPrimitiveParams( link,[
       PRIM_TEXTURE, FACE_1, (string)gFontTexture, <0.126, 0.05, 0>, grid_offset1 + <0.037, 0, 0>, 0.0,
       PRIM_TEXTURE, FACE_2, (string)gFontTexture, <0.05, 0.05, 0>, grid_offset2, 0.0,
       PRIM_TEXTURE, FACE_3, (string)gFontTexture, <-0.74, 0.05, 0>, grid_offset3 - <0.244, 0, 0>, 0.0,
       PRIM_TEXTURE, FACE_4, (string)gFontTexture, <0.05, 0.05, 0>, grid_offset4, 0.0,
       PRIM_TEXTURE, FACE_5, (string)gFontTexture, <0.126, 0.05, 0>, grid_offset5 - <0.037, 0, 0>, 0.0
       ]);

}

// SALAHZAR intelligent procedure to extract UTF-8 codes and convert to index in our "cp850"-like table integer GetIndex(string char) {

   integer  ret=llSubStringIndex(gCharIndex, char);
   if(ret>=0) return ret;

   // special char do nice trick :)
   string escaped=llEscapeURL(char);
   integer found=llListFindList(decode, [escaped]);

   // Return blank if not found
   if(found<0) return 0;

   // return correct index
   return 100+found;


} // END SALAHZAR


RenderString(integer link, string str) {

  // Get the grid positions for each pair of characters.
  vector GridOffset1 = GetGridOffset( GetIndex(llGetSubString(str, 0, 0)) ); // SALAHZAR intermediate function
  vector GridOffset2 = GetGridOffset( GetIndex(llGetSubString(str, 1, 1)) ); // SALAHZAR
  vector GridOffset3 = GetGridOffset( GetIndex(llGetSubString(str, 2, 2)) ); // SALAHZAR
  vector GridOffset4 = GetGridOffset( GetIndex(llGetSubString(str, 3, 3)) ); // SALAHZAR
  vector GridOffset5 = GetGridOffset( GetIndex(llGetSubString(str, 4, 4)) ); // SALAHZAR

  // Use these grid positions to display the correct textures/offsets.
  ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5);

}

RenderWithEffects(integer link, string str) {

  // Get the grid positions for each pair of characters.
  vector GridOffset1 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 0, 0)) );
  vector GridOffset2 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 1, 1)) );
  vector GridOffset3 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 2, 2)) );
  vector GridOffset4 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 3, 3)) );
  vector GridOffset5 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 4, 4)) );

  // First set the alpha to the lowest possible.
  llSetLinkAlpha(link,0.05, ALL_SIDES);

  // Use these grid positions to display the correct textures/offsets.
  ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5);          // Now turn up the alpha until it is at full strength.
   float Alpha = 0.10;
   for (; Alpha <= 1.0; Alpha += 0.05)
      llSetLinkAlpha(link,Alpha, ALL_SIDES);
         // See if we want to fade out as well.
  if (gCellHoldDelay < 0.0)
      // No, bail out. (Just keep showing the string at full strength).
      return;
         // Hold the text for a while.
  llSleep(gCellHoldDelay);
     // Now fade out.
  for (Alpha = 0.95; Alpha >= 0.05; Alpha -= 0.05)
      llSetLinkAlpha(link,Alpha, ALL_SIDES);
         // Make the text transparent to fully hide it.
  llSetLinkTexture(link,TRANSPARENT, ALL_SIDES);

}

integer RenderExtended(integer link, string str, integer render) {

  // Look for escape sequences.
  integer length = 0;
  list Parsed       = llParseString2List(str, [], (list)ESCAPE_SEQUENCE);
  integer ParsedLen = llGetListLength(Parsed);

  // Create a list of index values to work with.
  list Indices;
  // We start with room for 5 indices.
  integer IndicesLeft = 5;

  string Token;
  integer Clipped;
  integer LastWasEscapeSequence = FALSE;
  // Work from left to right.
  integer i = 0;
  for (; i < ParsedLen && IndicesLeft > 0; ++i) {
      Token = llList2String(Parsed, i);

      // If this is an escape sequence, just set the flag and move on.
      if (Token == ESCAPE_SEQUENCE) {
          LastWasEscapeSequence = TRUE;
      }
      else { // Token != ESCAPE_SEQUENCE
          // Otherwise this is a normal token.  Check its length.
          Clipped = FALSE;
          integer TokenLength = llStringLength(Token);
          // Clip if necessary.
          if (TokenLength > IndicesLeft) {
              TokenLength = llStringLength(Token = llGetSubString(Token, 0, IndicesLeft - 1));
              IndicesLeft = 0;
              Clipped = TRUE;
          }
          else
              IndicesLeft -= TokenLength;

          // Was the previous token an escape sequence?
          if (LastWasEscapeSequence) {
              // Yes, the first character is an escape character, the rest are normal.
              length += 2 + TokenLength;
              if(render)
              {
                   // This is the extended character.
                   Indices += (llSubStringIndex(EXTENDED_INDEX, llGetSubString(Token, 0, 0)) + 95);

                   // These are the normal characters.
                   integer j = 1;
                   for (; j < TokenLength; ++j)
                   {
                      Indices += llSubStringIndex(gCharIndex, llGetSubString(Token, j, j));
                   }
               }
          }
          else { // Normal string.
              // Just add the characters normally.
              length += TokenLength;
              if(render)
              {
                  integer j = 0;
                  for (; j < TokenLength; ++j)
                  {
                      Indices += llSubStringIndex(gCharIndex, llGetSubString(Token, j, j));
                  }
               }
          }

          // Unset this flag, since this was not an escape sequence.
          LastWasEscapeSequence = FALSE;
      }
  }

  // Use the indices to create grid positions.
 if(render)
 {
      vector GridOffset1 = GetGridOffset( llList2Integer(Indices, 0) );
      vector GridOffset2 = GetGridOffset( llList2Integer(Indices, 1) );
      vector GridOffset3 = GetGridOffset( llList2Integer(Indices, 2) );
      vector GridOffset4 = GetGridOffset( llList2Integer(Indices, 3) );
      vector GridOffset5 = GetGridOffset( llList2Integer(Indices, 4) );

      // Use these grid positions to display the correct textures/offsets.
      ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5);
  }
  return length;

}

integer ConvertIndex(integer index) {

  // This converts from an ASCII based index to our indexing scheme.
  if (index >= 32) // ' ' or higher
      index -= 32;
  else { // index < 32
      // Quick bounds check.
      if (index > 15)
          index = 15;

      index += 94; // extended characters
  }

  return index;

}


PassToRender(integer render,string message, integer bank) { // float time;

   integer extendedlen = 0;
   integer link;
   integer i = 0;
   integer msgLen = llStringLength(message);
   string TextToRender;
   integer num_slaves=llGetListLength(gSlaveNames);
   string slave_name; //avoids unnecessary casts, keeping it as a string


   //get the bank offset and length
   integer bank_offset=llList2Integer(gBankingData, (bank * BANK_STRIDE));
   integer bank_length=llList2Integer(gBankingData, (bank * BANK_STRIDE) + 1);
   integer bank_highest_dirty=llList2Integer(gBankingData, (bank * BANK_STRIDE) + 2);

   integer x = 0;
   for (;x < msgLen;x = x + 5)
   {

       if (i >= bank_length)  //we don't want to run off the end of the bank
       {
           //set the dirty to max, and bail out, we're done
           gBankingData=llListReplaceList(gBankingData, (list)bank_length, (bank * BANK_STRIDE) + 2, (bank * BANK_STRIDE) + 2);
           return;
       }

       link = unpack(gXyTextPrims,(i + bank_offset));
       TextToRender = llGetSubString(message, x, x + 15);

       if(gSlaveRegistered && (link % (num_slaves + 1)))
       {
           slave_name=llList2String(gSlaveNames, (link % (num_slaves + 1)) - 1);
           if (render == 1)
              llMessageLinked(LINK_THIS, SLAVE_DISPLAY, TextToRender, (key)((string)link + "," + slave_name));
           if (render == 2)
           {
               //time = llGetAndResetTime();
               if(llSubStringIndex(TextToRender,"\e") > x)
                   extendedlen = 5;
               else
                   extendedlen = RenderExtended(link,TextToRender,0);
               if (extendedlen > 5)
               {
                   x += extendedlen - 5;
               }
              llMessageLinked(LINK_THIS, SLAVE_DISPLAY_EXTENDED, TextToRender, (key)((string)link + "," + slave_name));
             // llOwnerSay((string)llGetAndResetTime());
           }
              //sorry, no fade effect with slave
       }
       else
       {
           if (render == 1)
               RenderString(link,TextToRender);
           if (render == 2)
           {
               extendedlen = RenderExtended(link,TextToRender,1);
               if (extendedlen > 5)
               {
                   x += extendedlen - 5;
               }

           }
           if (render == 3)
               RenderWithEffects(link,TextToRender);
       }
       ++i;
   }

   if (bank_highest_dirty==0)
       bank_highest_dirty=bank_length;

   integer current_highest_dirty=i;
   while (i < bank_highest_dirty)
   {
       link = unpack(gXyTextPrims,(i + bank_offset));

       if(gSlaveRegistered && (link % (num_slaves+1) != 0))
       {
           slave_name=llList2String(gSlaveNames, (link % (num_slaves + 1)) - 1);
           llMessageLinked(LINK_THIS, SLAVE_DISPLAY, "     ", (key)((string)link + "," + slave_name));
           //sorry, no fade effect with slave
       }
       else
       {
           RenderString(link,"     ");
       }
       ++i;
   }
   gBankingData=llListReplaceList(gBankingData, (list)current_highest_dirty, (bank * BANK_STRIDE) + 2, (bank * BANK_STRIDE) + 2);

}

// Bitwise Voodoo by Gigs Taggart and optimized by Strife Onizuka list gXyTextPrims;


integer get_number_of_prims() {//ignores avatars.

   integer a = llGetNumberOfPrims();
   while(llGetAgentSize(llGetLinkKey(a)))
       --a;
   return a;

}

//functions to pack 8-bit shorts into ints list pack_and_insert(list in_list, integer pos, integer value) { // //figure out the bitpack position // integer pack = pos & 3; //4 bytes per int // pos=pos >> 2; // integer shifted = value << (pack << 3); // integer old_value = llList2Integer(in_list, pos); // shifted = old_value | shifted; // in_list = llListReplaceList(in_list, (list)shifted, pos, pos); // return in_list;

   //Safe optimized version
   integer index = pos >> 2;
   return llListReplaceList(in_list, (list)(llList2Integer(in_list, index) | (value << ((pos & 3) << 3))), index, index);

}

integer unpack(list in_list, integer pos) {

   return (llList2Integer(in_list, pos >> 2) >> ((pos & 3) << 3)) & 0x000000FF;//unsigned

// return (llList2Integer(in_list, pos >> 2) << (((~pos) & 3) << 3)) >> 24;//signed }

change_color(vector color) {

   integer num_prims=llGetListLength(gXyTextPrims) << 2;

   integer i = 0;

   for (; i<=num_prims; ++i)
   {
       integer link = unpack(gXyTextPrims,i);
       if (!link)
           return;

       llSetLinkPrimitiveParams( link,[
           PRIM_COLOR, FACE_1, color, 1.0,
           PRIM_COLOR, FACE_2, color, 1.0,
           PRIM_COLOR, FACE_3, color, 1.0,
           PRIM_COLOR, FACE_4, color, 1.0,
           PRIM_COLOR, FACE_5, color, 1.0
       ]);
   }

}

change_line_color(integer bank, vector color) {

   //get the bank offset and length
   integer i = llList2Integer(gBankingData, (bank * BANK_STRIDE));
   integer bank_end = i + llList2Integer(gBankingData, (bank * BANK_STRIDE) + 1);

   for (; i < bank_end; ++i)
   {
       integer link = unpack(gXyTextPrims,i);
       if (!link)
           return;

       llSetLinkPrimitiveParams( link,[
           PRIM_COLOR, FACE_1, color, 1.0,
           PRIM_COLOR, FACE_2, color, 1.0,
           PRIM_COLOR, FACE_3, color, 1.0,
           PRIM_COLOR, FACE_4, color, 1.0,
           PRIM_COLOR, FACE_5, color, 1.0
       ]);
   }

}


init() {

   llSay(0,"Init beginning...");
   integer num_prims=get_number_of_prims();
   string link_name;
   integer bank=0;
   integer prims_pointer=0; //"pointer" to the next entry to be used in the gXyTextPrims list.

   list temp_bank = [];
   integer temp_bank_stride=2;

   //FIXME: font texture might should be per-bank
   llMessageLinked(LINK_THIS, SET_FONT_TEXTURE, "", gFontTexture);

   gXyTextPrims=[];
   integer x=0;
   for (;x<64;++x)
   {
       gXyTextPrims = (gXyTextPrims = []) + gXyTextPrims + 0;  //we need to pad out the list to make it easier to add things in any order later
   }

   @loop;

{

       llSay(0,"Scanning bank #"+(string)bank);

       //loop over all prims, looking for ones in the current bank
       for(x=0;x<=num_prims;++x)
       {
           link_name=llGetLinkName(x);
           list tmp = llParseString2List(link_name, (list)"-", []);
           if(llList2String(tmp,0) == "xyzzytext")
           {
               if (llList2Integer(tmp,1) == bank)
               {
                   temp_bank += llList2Integer(tmp,2) + (list)x;
               }
           }

       }

       if (temp_bank != [])
       {
           //sort the current bank
           temp_bank = llListSort(temp_bank, temp_bank_stride, TRUE);

           integer temp_len = llGetListLength(temp_bank);

           //store metadata
           gBankingData += [prims_pointer, temp_len/temp_bank_stride, 0];

           //repack the bank into the prim list
           for (x = 0; x < temp_len; x += temp_bank_stride)
           {
               gXyTextPrims = pack_and_insert(gXyTextPrims, prims_pointer, llList2Integer(temp_bank, x + 1));
               ++prims_pointer;
           }
           ++bank;
           temp_bank=[];
           jump loop;
       }
   }

   llMessageLinked(LINK_THIS, SLAVE_RESET, "" , null_key);
   //llOwnerSay((string)llGetFreeMemory());
   llSay(0,"Xyzzy initialized.");

}


default {

  state_entry() {
      // Initialize the character index.
      ResetCharIndex();
      init();
  }

  on_rez(integer num)
  {
     llResetScript();
  }

  link_message(integer sender, integer channel, string data, key id) {
       if (id==null_key)
           id="0";

       if (channel == DISPLAY_STRING) {
           PassToRender(1,data, (integer)((string)id));
       }
       else if (channel == DISPLAY_EXTENDED) {
           PassToRender(2,data, (integer)((string)id));
       }
       else if (channel == REMAP_INDICES) {
           // Parse the message, splitting it up into index values.
           list Parsed = llCSV2List(data);
           integer i = 0;
           // Go through the list and swap each pair of indices.
           for (; i < llGetListLength(Parsed); i += 2) {
               integer Index1 = ConvertIndex( llList2Integer(Parsed, i) );
               integer Index2 = ConvertIndex( llList2Integer(Parsed, i + 1) );

               // Swap these index values.
               string Value1 = llGetSubString(gCharIndex, Index1, Index1);
               string Value2 = llGetSubString(gCharIndex, Index2, Index2);

               gCharIndex = llDeleteSubString(gCharIndex, Index1, Index1);
               gCharIndex = llInsertString(gCharIndex, Index1, Value2);

               gCharIndex = llDeleteSubString(gCharIndex, Index2, Index2);
               gCharIndex = llInsertString(gCharIndex, Index2, Value1);
           }
       }
       else if (channel == RESCAN_LINKSET)
       {
           init();
       }
       else if (channel == RESET_INDICES) {
           // Restore the character index back to default settings.
           ResetCharIndex();
       }
       else if (channel == SET_FADE_OPTIONS) {
           // Change the channel we listen to for cell commands, the
           // starting character position to extract from, and
           // special effect attributes.
           list Parsed = llCSV2List(data);
           gCellUseFading      = (integer) llList2String(Parsed, 0);
           gCellHoldDelay      = (float)   llList2String(Parsed, 1);
       }
       else if (channel == SET_FONT_TEXTURE) {
           // Use the new texture instead of the current one.
           gFontTexture = id;
       }
       else if (channel == SET_COLOR) {
           change_color((vector)data);
       }
       else if (channel == SET_LINE_COLOR) {
           change_line_color((integer)((string)id), (vector)data);
       }
       else if (channel == REGISTER_SLAVE)
       {
           if(!~llListFindList(gSlaveNames, (list)data))
           {//isn't registered yet
               gSlaveNames += data;
               gSlaveRegistered=TRUE;
               //llOwnerSay((string)llGetListLength(gSlaveNames) + " Slave(s) Recognized: " + data);
           }

// else // {//it already exists // llOwnerSay((string)llGetListLength(gSlaveNames) + " Slave, Existing Slave Recognized: " + data); // }

           llMessageLinked(LINK_THIS, SLAVE_RECOGNIZED, data , null_key);
       }
   }

   touch_start(integer count)
   {
       //llMessageLinked(LINK_THIS,DISPLAY_STRING,"123456789","1");
   }


   changed(integer change)
   {
       if(change&CHANGED_INVENTORY)
       {
           if(gSlaveRegistered)
           {
               //by using negative indexes they don't need to be adjusted when an entry is deleted.
               integer x = ~llGetListLength(gSlaveNames);
               while(++x)
               {
                   if (!~llGetInventoryType(llList2String(gSlaveNames, x)))
                   {
                       //llOwnerSay("Slave Removed: " + llList2String(gSlaveNames, x));
                       gSlaveNames = llDeleteSubList(gSlaveNames, x, x);
                   }
               }
               gSlaveRegistered = !(gSlaveNames == []);
           }
       }
   }

}
