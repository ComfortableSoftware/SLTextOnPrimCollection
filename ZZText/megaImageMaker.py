#! /usr/bin/env python

# Mega-image maker python-fu script

# You need to put this under the %USERPROFILE%\.gimp-2.6\plug-ins folder (in my case: \Documents and Settings\salahzar.SALAHZAR-PC\.gimp-2.6\plug-ins).

# To avoid problems with indents, spaces and tabs create the file with explorer megaimages.py and right clich use the IDLE edit to past the following source.


# If you need your characters you need to change the UTF-8 codings in "decode" var

from gimpfu import *

# you can remove logging, I used it to be sure program was working since it can be a bit slow
# to generate all the combination
def python_log_init():
    fileHandle = open( 'python.log', 'w')
    fileHandle.close()

def python_log(s):
    fileHandle = open ( 'python.log', 'a' )
    fileHandle.write(str(s)+"\n")
    fileHandle.close()

def python_xytext2(font,color,size,limit):
  """Print the arguments on standard output"""
  python_log_init()
  python_log("font: %s color: <%d,%d,%d> size: %d limit: %d" % ( font, color[0], color[1], color[2], size, limit ))
  chars = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"


  #

  #        cap cedille      u:         e/            a^         a:          a/         a ring      cedille     e^           e:
  decode=  ["\xC3\x87", "\xC3\xBC", "\xC3\xA9", "\xC3\xA2", "\xC3\xA4", "\xC3\xA0", "\xC3\xA5", "\xC3\xA7", "\xC3\xAA", "\xC3\xAB" ]


  #                    e\           i:               i^            i\                A:          A ring          E/              ae           AE           marker >
  decode+=["\xC3\xA8", "\xC3\xAF", "\xC3\xAE", "\xC3\xAC", "\xC3\x84", "\xC3\x85", "\xC3\x89", "\xC3\xA6", "\xC3\x86", "\xE2\x96\xB6" ]

  #                 o:               o/           u^          u\              y:               O:             U:          cent           pound        yen
  decode+=["\xC3\xB6", "\xC3\xB2", "\xC3\xBB", "\xC3\xB9", "\xC3\xBF", "\xC3\x96", "\xC3\x9C", "\xC2\xA2", "\xC2\xA3", "\xC2\xA5"]

  #                 A^              a/              i/                o/            u/              n~           E:            y/              inv ?         O^
  decode+=["\xC3\x82", "\xC3\xA1", "\xC3\xAD", "\xC3\xB3", "\xC3\xBA", "\xC3\xB1", "\xC3\x8B", "\xC3\xBD", "\xC2\xBF", "\xC3\x94" ]

  #                   inv !             I\             I/           degree       E^              I^            o^            U^
  decode+=["\xC2\xA1", "\xC3\x8C", "\xC3\x8D", "\xC2\xB0", "\xC3\x8A", "\xC3\x8E", "\xC3\xB4", "\xC3\x9B" ]

  #                     Y:          euro           german ss         E\              A\           A/              U\           U/               O\           O/
  decode+=["\xC3\x9D", "\xE2\x82\xAC", "\xC3\x9F", "\xC3\x88", "\xC3\x80", "\xC3\x81", "\xC3\x99", "\xC3\x9A", "\xC3\x92", "\xC3\x93"   ]

  #                   Sv           sv             zv             Zv              Y:             I:
  decode+=[ "\xC5\xA0", "\xC5\xA1", "\xC5\xBE", "\xC5\xBD", "\xC3\x9D", "\xC3\x8C" ]


  width=5120
  height=5120
  img = gimp.Image(width, height, RGB)
  layer = gimp.Layer(img, "my font", width, height, RGB_IMAGE, 100, NORMAL_MODE)
  img.add_layer(layer, 0)
  layer.add_alpha()
  gimp.set_foreground(color)
  pdb.gimp_selection_all(img)
  pdb.gimp_edit_clear(layer)
  pdb.gimp_selection_none(img)
  size= 20 # 23 # 21.3 # 30

  index=0
  numtot=len(chars)+len(decode)
  #numtot=50
  if limit>0: numtot=limit
  deltay=12.8 # 13.8215 # 12.8 # 18
  deltax=25.6 # 27.6432 # 25.6 # 36
  maxchars=len(chars)
  for first in range(numtot):

     if first<maxchars:
        el1=chars[first]
     else:
        el1=decode[first-maxchars]

     python_log(str(first)+"/"+str(numtot)+":  "+el1)
     for second in range(first+1):

          # to save time removed function call
          if second<maxchars:
             el2=chars[second]
          else:
             el2=decode[second-maxchars]

          y=second * deltay * 2 # horizontal distance
          x=first*deltax # line distance
          pdb.gimp_text_fontname(img,layer,y,x,el1,0,TRUE,size,PIXELS,font)
          pdb.gimp_text_fontname(img,layer,y+deltay,x,el2,0,TRUE,size,PIXELS,font)

          index+=1


  # Now ready to display this image
  img.merge_visible_layers(0)
  gimp.Display(img)


register(
  "xytext2", "", "", "", "", "",
  "<Toolbox>/Xtns/_MegaImage", "",
  [
  (PF_FONT, "font", "Font to use", "Arial"),
  (PF_COLOR,"color","Color to use", (255,255,255) ),
  (PF_INT,    "size", "Font size", 45          ),
  (PF_INT,  "limit", "limit font generation ", 0  ),

  ],
  [],
  python_xytext2
  )

main()
