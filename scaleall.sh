for f in *.jpg
do 
	convert $f -resize 2048x2048 $f
done
