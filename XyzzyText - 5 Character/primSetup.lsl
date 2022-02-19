

// (Caution! Not compatible with 5 face double texture Xytext)

////////////////////////////////////////////
// XyzzyText Prim Setup Script (5 Face)
//
// Modified by Thraxis Epsilon
//
////////////////////////////////////////////

default
{
  state_entry()
  {

    llSetPrimitiveParams([
        PRIM_TYPE, PRIM_TYPE_PRISM, PRIM_HOLE_DEFAULT, <0.199, 0.8, 0.0>, 0.68, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>,
        PRIM_SIZE, <0.03, 2.89, 0.5>,
        PRIM_TEXTURE, 1, "09b04244-9569-d21f-6de0-4bbcf5552222", <0.126, 0.10, 0.0>, <-0.740013, 0.0, 0.0>, 0.0,
        PRIM_TEXTURE, 6, "09b04244-9569-d21f-6de0-4bbcf5552222", <0.050, 0.100, 0.00>, <0.0, 0.0, 0.0>, 0.0,
        PRIM_TEXTURE, 4, "09b04244-9569-d21f-6de0-4bbcf5552222", <-0.740, 0.10, 0.00>, <0.130009, 0.0, 0.0>, 0.0,
        PRIM_TEXTURE, 7, "09b04244-9569-d21f-6de0-4bbcf5552222", <0.050, 0.100, 0.00>, <0.0, 0.0, 0.0>, 0.0,
        PRIM_TEXTURE, 3, "09b04244-9569-d21f-6de0-4bbcf5552222", <0.126, 0.10, 0.0>, <-0.255989, 0.0, 0.0>, 0.0]);
    llRemoveInventory(llGetScriptName());
  }
}
