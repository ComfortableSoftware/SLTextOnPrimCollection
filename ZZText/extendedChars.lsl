// Accessing the new characters from textures

// This is the most difficult part. Still need to clean up offsets, since now they are still a bit wrong.

vector GetGridOffset(vector grid_pos)
{
    // Zoom in on the texture showing our character pair.
    integer Col = llRound(grid_pos.x) % 40; // PK was 20
    integer Row = llRound(grid_pos.y) % 20; // PK was 10

    // Return the offset in the texture.
    return <-0.45 + 0.025 * Col, 0.45 - 0.05 * Row, 0.0>; // PK was 0.05 and 0.1
}

ShowChars(vector grid_pos1, vector grid_pos2, vector grid_pos3, vector grid_pos4, vector grid_pos5)
{
   // Set the primitive textures directly.


   llSetLinkPrimitiveParamsFast(LINK_THIS, [
        PRIM_TEXTURE, FACE_1, GetGridTexture(grid_pos1), <0.125, 0.05, 0>, GetGridOffset(grid_pos1) + <0.0375-0.025-0.002, 0.025, 0>, 0.0,
        PRIM_TEXTURE, FACE_2, GetGridTexture(grid_pos2), <0.05, 0.05, 0>, GetGridOffset(grid_pos2)+<-0.025-0.002, 0.025,0>, 0.0,
        PRIM_TEXTURE, FACE_3, GetGridTexture(grid_pos3), <-0.74, 0.05, 0>, GetGridOffset(grid_pos3)+ <-.34-0.002, 0.025, 0>, 0.0,
        PRIM_TEXTURE, FACE_4, GetGridTexture(grid_pos4), <0.05, 0.05, 0>, GetGridOffset(grid_pos4)+<-0.025-0.002, 0.025,0>, 0.0,
        PRIM_TEXTURE, FACE_5, GetGridTexture(grid_pos5), <0.125, 0.05, 0>, GetGridOffset(grid_pos5) + <0.0375-0.025-0.077-0.002, 0.025, 0>, 0.0

//      PRIM_TEXTURE, FACE_1, GetGridTexture(grid_pos1), <0.25, 0.1, 0>, GetGridOffset(grid_pos1) + <0.075, 0, 0>, 0.0,
//      PRIM_TEXTURE, FACE_2, GetGridTexture(grid_pos2), <0.1, 0.1, 0>, GetGridOffset(grid_pos2), 0.0,
//      PRIM_TEXTURE, FACE_3, GetGridTexture(grid_pos3), <-1.48, 0.1, 0>, GetGridOffset(grid_pos3)+ <0.37, 0, 0>, 0.0,
//      PRIM_TEXTURE, FACE_4, GetGridTexture(grid_pos4), <0.1, 0.1, 0>, GetGridOffset(grid_pos4), 0.0,
//      PRIM_TEXTURE, FACE_5, GetGridTexture(grid_pos5), <0.25, 0.1, 0>, GetGridOffset(grid_pos5) - <0.075, 0, 0>, 0.0

        ]);
}

integer GetIndex(string char)
{
    integer ret = llSubStringIndex(gCharIndex, char);

    if(0 <= ret)
        return ret;

    // special char do nice trick :)
    string escaped = llEscapeURL(char);

    // remap ’
    if (escaped == "%E2%80%99")
        return 7;

    // llSay(PUBLIC_CHANNEL, "Looking for " + escaped);
    integer found = llListFindList(decode, [escaped]);

    // not found
    if(found < 0)
        return FALSE;

    // return correct index
    return llStringLength(gCharIndex) + found;

}

RenderString(string str)
{
    // Get the grid positions for each pair of characters.
    vector GridPos1 = GetGridPos( GetIndex(llGetSubString(str, 0, 0)),
                                  GetIndex(llGetSubString(str, 1, 1)) );
    vector GridPos2 = GetGridPos( GetIndex(llGetSubString(str, 2, 2)),
                                  GetIndex(llGetSubString(str, 3, 3)) );
    vector GridPos3 = GetGridPos( GetIndex(llGetSubString(str, 4, 4)),
                                  GetIndex(llGetSubString(str, 5, 5)) );
    vector GridPos4 = GetGridPos( GetIndex(llGetSubString(str, 6, 6)),
                                  GetIndex(llGetSubString(str, 7, 7)) );
    vector GridPos5 = GetGridPos( GetIndex(llGetSubString(str, 8, 8)),
                                  GetIndex(llGetSubString(str, 9, 9)) );

    // Use these grid positions to display the correct textures/offsets.
    ShowChars(GridPos1, GridPos2, GridPos3, GridPos4, GridPos5);
}
