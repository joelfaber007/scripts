[ ! -d small ] && mkdir small

FILEOUT="small/$(echo $1 | grep -Eo '^[^\.]+').jpg"
convert $1 -resize 2048x2048 "$FILEOUT"

echo "$FILEOUT written"


