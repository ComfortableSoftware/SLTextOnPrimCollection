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
          PRIM_TYPE, PRIM_TYPE_PRISM, 32, <0.199, 0.8, 0.0>, 0.30, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>,
          PRIM_SIZE, <0.03, 2.89, 0.5>,
          PRIM_TEXTURE, 1, "09b04244-9569-d21f-6de0-4bbcf5552222", <2.48, 1.0, 0.0>, <-0.74, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 6, "09b04244-9569-d21f-6de0-4bbcf5552222", <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 4, "09b04244-9569-d21f-6de0-4bbcf5552222", <14.75, 1.0, 0.0>, <0.27, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 7, "09b04244-9569-d21f-6de0-4bbcf5552222", <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 3, "09b04244-9569-d21f-6de0-4bbcf5552222", <2.48, 1.0, 0.0>, <-0.25, 0.0, 0.0>, 0.0]);

    llRemoveInventory(llGetScriptName());
  }
}
