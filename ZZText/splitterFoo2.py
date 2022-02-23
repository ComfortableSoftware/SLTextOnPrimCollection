#!/usr/bin/env python


# Splitter python-fu script

# You need to put this under the %USERPROFILE%\.gimp-2.6\plug-ins folder (in my case: \Documents and Settings\salahzar.SALAHZAR-PC\.gimp-2.6\plug-ins).

# To avoid problems with indents, spaces and tabs create the file with explorer guides.py and right clich use the IDLE edit to past the following source.

# Note: you need to restart GIMP to see it working.

# When running it is very simple just tell it "512" to split every 512 points.

# Since this is a python (assumed python 2.7 ish) for use inside GIMP it may be angry in an editor that doesn't understand python for GIMP.

import math
from gimpfu import *

def python_guides(timg, tdrawable, interval=100):
    timg.undo_group_start()
    for x in range(0, timg.width, interval):
       timg.add_vguide(x)

    for y in range(0, timg.height, interval):
       timg.add_hguide(y)

    timg.undo_group_end()

    gimp.displays_flush()

register(
        "python_fu_guides",
        "Guides: this will split the images in sections...",
        "Guides: this will split the images in sections...",
        "Salahzar Stenvaag",
        " ",
        "2008",
        "<Image>/Filters/Guides...",
        "RGB*, GRAY*",
        [
                (PF_INT, "interval", "Interval", 100)
        ],
        [],
        python_guides)

main()
