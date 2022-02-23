////////////////////////////////////////////
// XyzzyText v2.1.UTF8 Slave Script by Arnold Wilder
// XyText v2.0 SLAVE Script (5 Face, Single Texture)
//
// Modified by Thraxis Epsilon and Gigs Taggart 5/2007
// Rewrite to allow one-script-per-object operation
//
// Modified by Kermitt Quirk 19/01/2006
// To add support for 5 face prim instead of 3
//
// Originally Written by Xylor Baysklef
//
//
////////////////////////////////////////////


integer REMAP_INDICES = 204002; integer RESET_INDICES = 204003;

//internal API integer REGISTER_SLAVE = 205000; integer SLAVE_RECOGNIZED = 205001; integer SLAVE_DISPLAY = 205003; integer SET_FONT_TEXTURE = 204005;

integer SLAVE_DISPLAY_EXTENDED = 205004; integer SLAVE_RESET = 205005;


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


///////////// GLOBAL VARIABLES ///////////////
// This is the key of the font we are displaying.
//key gFontTexture = "b2e7394f-5e54-aa12-6e1c-ef327b6bed9e"; // 48 pixel font
key gFontTexture = "f226766c-c5ac-690e-9018-5a37367ae95a"; // 38 pixel font
//key gFontTexture= "ac955f98-74bb-290f-7eb6-dca54e5e4491";
//key gFontTexture= "e5efeead-c69e-eb81-e7bd-dad2bb787d2b"; // BitStream Vera Monotype
// All displayable characters. Default to ASCII order.
string gCharIndex; list decode=[]; // to handle special characters from CP850 page for european countries

integer gActive; //if we are recognized, this is true
/////////// END GLOBAL VARIABLES ////////////

ResetCharIndex() {

  string dblqt = llChar(34)
  gCharIndex  = " !" + dblqt + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`";
  gCharIndex += "abcdefghijklmnopqrstuvwxyz{|}~";
  gCharIndex += "\n\n\n\n\n";
    // special UTF-8 chars for European languages // SALAHZAR special chars according to a selection from CP850
    // these 80 chars correspond to the following chars in CP850 codepage: (some are not viewable in editor)
    // rows(11)="Çüéâäàåçêë"
    // rows(12)="èïîìÄÅÉæÆ◄"
    // rows(13)="öòûùÿÖÜ¢£¥"
    // rows(14)="₧ƒáíóúñÑªº"
    // rows(15)="¿⌐¬½¼¡«»αß"
    // rows(16)="ΓπΣσµτΦΘΩδ"
    // rows(17)="∞φε∩≡±≥≤⌠⌡"
    // rows(18)="÷≈°∙·√ⁿ²€ "
    decode= [ "%C3%87", "%C3%BC", "%C3%A9", "%C3%A2", "%C3%A4", "%C3%A0", "%C3%A5", "%C3%A7", "%C3%AA", "%C3%AB" ];
    decode+=[ "%C3%A8", "%C3%AF", "%C3%AE", "%C3%AC", "%C3%84", "%C3%85", "%C3%89", "%C3%A6", "%C3%AE", "xxxxxx" ];
    decode+=[ "%C3%B6", "%C3%B2", "%C3%BB", "%C3%B9", "%C3%BF", "%C3%96", "%C3%9C", "%C2%A2", "%C2%A3", "%C2%A5" ];
    decode+=[ "%E2%82%A7", "%C6%92", "%C3%A1", "%C3%AD", "%C3%B3", "%C3%BA", "%C3%B1", "%C3%91", "%C2%AA", "%C2%BA"];
    decode+=[ "%C2%BF", "%E2%8C%90", "%C2%AC", "%C2%BD", "%C2%BC", "%C2%A1", "%C2%AB", "%C2%BB", "%CE%B1", "%C3%9F" ];
    decode+=[ "%CE%93", "%CF%80", "%CE%A3", "%CF%83", "%C2%B5", "%CF%84", "%CE%A6", "%CE%98", "%CE%A9", "%CE%B4" ];
    decode+=[ "%E2%88%9E", "%CF%86", "%CE%B5", "%E2%88%A9", "%E2%89%A1", "%C2%B1", "%E2%89%A5", "%E2%89%A4", "%E2%8C%A0", "%E2%8C%A1" ];
    decode+=[ "%C3%B7", "%E2%89%88", "%C2%B0", "%E2%88%99", "%C2%B7", "%E2%88%9A", "%E2%81%BF", "%C2%B2", "%E2%82%AC", "" ];}

vector GetGridOffset(integer index) {

  // Calculate the offset needed to display this character.
  integer Row = index / 10;
  integer Col = index % 10;

  // Return the offset in the texture.
  //return <-0.45 + 0.1 * Col, 0.45 - 0.1 * Row, 0.0>; //512*512 texture
  return <-0.45 + 0.1 * Col, 0.425 - 0.05 * Row, 0.0>; //512*1024 texture

}

ShowChars(integer link,vector grid_offset1, vector grid_offset2, vector grid_offset3, vector grid_offset4, vector grid_offset5) {

  // Set the primitive textures directly.

  // <-0.256, 0, 0>
  // <0, 0, 0>
  // <0.130, 0, 0>
  // <0, 0, 0>
  // <-0.74, 0, 0>

  llSetLinkPrimitiveParams( link,[
       PRIM_TEXTURE, FACE_1, (string)gFontTexture, <0.126, 0.05, 0>, grid_offset1 + <0.037, 0, 0>, 0.0,
       PRIM_TEXTURE, FACE_2, (string)gFontTexture, <0.05, 0.05, 0>, grid_offset2, 0.0,
       PRIM_TEXTURE, FACE_3, (string)gFontTexture, <-0.74, 0.05, 0>, grid_offset3 - <0.244, 0, 0>, 0.0,
       PRIM_TEXTURE, FACE_4, (string)gFontTexture, <0.05, 0.05, 0>, grid_offset4, 0.0,
       PRIM_TEXTURE, FACE_5, (string)gFontTexture, <0.126, 0.05, 0>, grid_offset5 - <0.037, 0, 0>, 0.0
       ]);

// } We are not sure the original intent, our best guess is un/commented as needed to get a compile to succeed

// Extract UTF-8 codes and convert to index in our "cp850"-like table integer GetIndex(string char) {

   integer  ret = llSubStringIndex(gCharIndex, char);
   if(ret>=0) return ret;

   // special char do nice trick
   string escaped=llEscapeURL(char);
   integer found=llListFindList(decode, [escaped]);

   // Return blank if not found
   if(found<0) return 0;

   // return correct index
   return 100+found;

}

RenderString(integer link, string str) {

  // Get the grid positions for each pair of characters.
  vector GridOffset1 = GetGridOffset( GetIndex(llGetSubString(str, 0, 0)) );
  vector GridOffset2 = GetGridOffset( GetIndex(llGetSubString(str, 1, 1)) );
  vector GridOffset3 = GetGridOffset( GetIndex(llGetSubString(str, 2, 2)) );
  vector GridOffset4 = GetGridOffset( GetIndex(llGetSubString(str, 3, 3)) );
  vector GridOffset5 = GetGridOffset( GetIndex(llGetSubString(str, 4, 4)) );


  // Use these grid positions to display the correct textures/offsets.
  ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5);

}

RenderExtended(integer link, string str) {

  // Look for escape sequences.
  list Parsed       = llParseString2List(str, [], [ESCAPE_SEQUENCE]);
  integer ParsedLen = llGetListLength(Parsed);

  // Create a list of index values to work with.
  list Indices;
  // We start with room for 5 indices.
  integer IndicesLeft = 5;

  integer i;
  string Token;
  integer Clipped;
  integer LastWasEscapeSequence = FALSE;
  // Work from left to right.
  for (i = 0; i < ParsedLen && IndicesLeft > 0; i++) {
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
              Token = llGetSubString(Token, 0, IndicesLeft - 1);
              TokenLength = llStringLength(Token);
              IndicesLeft = 0;
              Clipped = TRUE;
          }
          else
              IndicesLeft -= TokenLength;

          // Was the previous token an escape sequence?
          if (LastWasEscapeSequence) {
              // Yes, the first character is an escape character, the rest are normal.

              // This is the extended character.
              Indices += [llSubStringIndex(EXTENDED_INDEX, llGetSubString(Token, 0, 0)) + 95];

              // These are the normal characters.
              integer j;
              for (j = 1; j < TokenLength; j++)
                  Indices += [llSubStringIndex(gCharIndex, llGetSubString(Token, j, j))];
          }
          else { // Normal string.
              // Just add the characters normally.
              integer j;
              for (j = 0; j < TokenLength; j++)
                  Indices += [llSubStringIndex(gCharIndex, llGetSubString(Token, j, j))];
          }

          // Unset this flag, since this was not an escape sequence.
          LastWasEscapeSequence = FALSE;
      }
  }

  // Use the indices to create grid positions.
  vector GridOffset1 = GetGridOffset( llList2Integer(Indices, 0) );
  vector GridOffset2 = GetGridOffset( llList2Integer(Indices, 1) );
  vector GridOffset3 = GetGridOffset( llList2Integer(Indices, 2) );
  vector GridOffset4 = GetGridOffset( llList2Integer(Indices, 3) );
  vector GridOffset5 = GetGridOffset( llList2Integer(Indices, 4) );

  // Use these grid positions to display the correct textures/offsets.
  ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5);

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


default {

   state_entry()
   {
       // Initialize the character index.
       ResetCharIndex();
       llMessageLinked(LINK_THIS, REGISTER_SLAVE, llGetScriptName() , NULL_KEY);
   }

   on_rez(integer num)
   {
       llResetScript();
   }

   link_message(integer sender, integer channel, string data, key id)
   {

       if (channel == SLAVE_RECOGNIZED)
       {
           if (data == llGetScriptName())
           {
               gActive=TRUE;
           }
           return;
       }

       if (channel == SLAVE_DISPLAY)
       {
           if (!gActive)
               return;

           list params=llCSV2List((string)id);
           if (llList2String(params, 1) != llGetScriptName())
               return;


           RenderString(llList2Integer(params, 0),data);
           return;
       }

      if (channel == SLAVE_DISPLAY_EXTENDED)
      {
           if (!gActive)
               return;

           list params=llCSV2List((string)id);
           if (llList2String(params, 1) != llGetScriptName())
               return;

           RenderExtended(llList2Integer(params, 0),data);
      }

       if (channel == SET_FONT_TEXTURE)
       {
          gFontTexture = id;
          return;
       }

       if (channel == REMAP_INDICES) {
          // Parse the message, splitting it up into index values.
          list Parsed = llCSV2List(data);
          integer i;
          // Go through the list and swap each pair of indices.
          for (i = 0; i < llGetListLength(Parsed); i += 2) {
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
          return;
       }
       if (channel == RESET_INDICES) {
          // Restore the character index back to default settings.
          ResetCharIndex();
          return;
       }


       if (channel == SLAVE_RESET)
       {
           ResetCharIndex();
           gActive=FALSE;
           llMessageLinked(LINK_THIS, REGISTER_SLAVE, llGetScriptName() , NULL_KEY);
       }

   }
