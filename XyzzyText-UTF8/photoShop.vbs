Dim appRef
Set appRef = CreateObject( "Photoshop.Application" )
' Remember current unit settings and then set units to
' the value expected by this script
Dim originalRulerUnits
originalRulerUnits = appRef.Preferences.RulerUnits
appRef.Preferences.RulerUnits = 1 ' psPixels
' Create a new 512*512 pixel document and assign it to a variable.
Dim docRef
Dim artLayerRef
Dim textItemRef
dim rows(18)
rows(1)=" !""#$%&'()"
rows(2)="*+,-./0123"
rows(3)="456789:;<="
rows(4)=">?@ABCDEFG"
rows(5)="HIJKLMNOPQ"
rows(6)="RSTUVWXYZ["
rows(7)="\]^_`abcde"
rows(8)="fghijklmno"
rows(9)="pqrstuvwxy"
rows(10)="z{|}~·ΘΩ√ "    

rows(11)="Çüéâäàåçêë"
rows(12)="èïîìÄÅÉæÆ◄"
rows(13)="öòûùÿÖÜ¢£¥"
rows(14)="₧ƒáíóúñÑªº"
rows(15)="¿⌐¬½¼¡«»αß"
rows(16)="ΓπΣσµτΦΘΩδ"
rows(17)="∞φε∩≡±≥≤⌠⌡"
rows(18)="÷≈°∙·√ⁿ²€ "


dim fontname
fontname="Comics"

Set docRef = appRef.Documents.Add(512, 1024, 72, "CP850 " & fontname, 2, 3, 1)
' Create a new art layer containing text
Dim colorObj
Set colorObj=CreateObject("Photoshop.SolidColor")
colorObj.RGB.Red=255
colorObj.RGB.Green=255
colorObj.RGB.Blue=255



' Set the contents of the text layer.
for i=1 to 18
   for j=1 to 10
     Set artLayerRef = docRef.ArtLayers.Add
     artLayerRef.Kind = 2
     Set textItemRef = artLayerRef.TextItem
     ' textItemRef.Font = fontname
     textItemRef.Color=colorObj
     textItemRef.Justification = 2 
     textItemRef.Font = "A Charming Font"
     textItemRef.Size = 38
     textItemRef.Contents = mid(rows(i),j,1)
     textItemRef.Position = Array((j-1)*51.2+25,i*51.2-7)
   next
next
' Restore unit settingPhotoshop CS3
appRef.Preferences.RulerUnits = originalRulerUnits
