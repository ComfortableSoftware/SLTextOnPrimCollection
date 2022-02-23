UTF-8 character specification

This must closely match what you produced with python-fu

ResetCharIndex() {
    gCharIndex  = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`";
    // \" <-- Fixes LSL syntax highlighting bug.
    gCharIndex += "abcdefghijklmnopqrstuvwxyz{|}~";
  //        cap cedille      u:         e/            a^         a:          a/         a ring      cedille     e^           e:
  decode=  ["%C3%87", "%C3%BC", "%C3%A9", "%C3%A2", "%C3%A4", "%C3%A0", "%C3%A5", "%C3%A7", "%C3%AA", "%C3%AB",


  //                    e\           i:               i^            i\                A:          A ring          E/              ae           AE           marker >
       "%C3%A8", "%C3%AF", "%C3%AE", "%C3%AC", "%C3%84", "%C3%85", "%C3%89", "%C3%A6", "%C3%86", "%E2%96%B6" ,

  //                 o:               o/           u^          u\              y:               O:             U:          cent           pound        yen
       "%C3%B6", "%C3%B2", "%C3%BB", "%C3%B9", "%C3%BF", "%C3%96", "%C3%9C", "%C2%A2", "%C2%A3", "%C2%A5",

  //                 A^              a/              i/                o/            u/              n~           E:            y/              inv ?         O^
       "%C3%82", "%C3%A1", "%C3%AD", "%C3%B3", "%C3%BA", "%C3%B1", "%C3%8B", "%C3%BD", "%C2%BF", "%C3%94",

  //                   inv !             I\             I/           degree       E^              I^            o^            U^
       "%C2%A1", "%C3%8C", "%C3%8D", "%C2%B0", "%C3%8A", "%C3%8E", "%C3%B4", "%C3%9B",

  //                     Y:          euro           german ss         E\              A\           A/              U\           U/               O\           O/
       "%C3%9D", "%E2%82%AC", "%C3%9F", "%C3%88", "%C3%80", "%C3%81", "%C3%99", "%C3%9A", "%C3%92", "%C3%93",

  //                   Sv           sv             zv             Zv              Y:             I:
       "%C5%A0", "%C5%A1", "%C5%BE", "%C5%BD", "%C3%9D", "%C3%8C" ];


}
