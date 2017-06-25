#!/bin/bash
# Metadata to consider adding from dublin core (XMP-dc)
# See 'man Image::ExifTool::TagNames' and http://www.exiv2.org/tags-xmp-dc.html
# Creator
# Description-en-US
# Rights-en-US
# Source
# Subject
# Title-en-US
# Identifier

function myresize() {
 source=$1
 dest=$2
 size=$3
 convert $source -resize $size $dest
 exiftool -overwrite_original -preserve \
          "-XMP-dc:Source=https://whk.name/images/dwarves/$source" \
          "-XMP-dc:Identifier=https://whk.name/images/dwarves/$dest" \
          $dest
}

function mycopyoriginal() {
 source=$1
 dest=$2

 cp -a original/$source $dest
 exiftool  -overwrite_original -preserve \
          "-XMP-dc:Creator=Len Peralta (http://www.lenperalta.com)" \
          "-XMP-dc:Rights-en-US=CC BY-SA 4.0" \
          "-XMP-dc:Source=https://whk.name/images/dwarves/original/$source" \
          "-XMP-dc:Identifier=https://whk.name/images/dwarves/$dest" \
          $dest
}

function mytransparentborder() {
 source=$1
 dest=$2
 size=$3
 border=$4

 convert $source -resize $size -matte -bordercolor none -border $border $dest
 exiftool -overwrite_original -preserve \
          "-XMP-dc:Creator=Len Peralta (http://www.lenperalta.com)" \
          "-XMP-dc:Rights-en-US=CC BY-SA 4.0" \
          "-XMP-dc:Source=https://whk.name/images/dwarves/$source" \
          "-XMP-dc:Identifier=https://whk.name/images/dwarves/$dest" \
          $dest
}

function myprocessdnd() {
 # Convert DnD 2550x3330 images to various sizes
 source=$1
 base=$2

 mycopyoriginal $source ${base}_2550x3300.jpg
 myresize ${base}_2550x3300.jpg ${base}_255x330.jpg 255x330
 myresize ${base}_2550x3300.jpg ${base}_128x166.jpg 128x166
 mytransparentborder ${base}_2550x3300.jpg ${base}_660x660.png 510x660 75x0
}

 
#
# Create the deriviate files from Len's original works
#
myprocessdnd war_knight_dnd.jpg        whk_dwarf_war
myprocessdnd w_knight_dnd_cap.jpg      whk_dwarf_cap
myprocessdnd w_knight_dnd.jpg          whk_dwarf_sword
myprocessdnd w_knight_dnd_reading.jpg  whk_dwarf_reading
myprocessdnd w_knight_dnd_stnick.jpg   whk_dwarf_stnick
#w_knight_dnd_FF.png       whk_dwarf_FF_1180x1284.png




