#!/bin/bash

# output directory
DIR="/var/services/homes/joel/Photos"

# input directories
INDIR1="/volumeUSB1/usbshare"
INDIR2="/volumeUSB2/usbshare"

process_dir() {
	pushd $1
	pwd

	for f in 9K* ; do
		echo "processing $f"
		CREATED=$(~/ExifTool/exiftool $f | grep -E "Create Date.*\.[0-9]{2}")
		DATE=$(echo $CREATED | grep -Eo "....:..:..")
		YEAR=$(echo $DATE | grep -Eo "^....")
		MONTH=$(echo $DATE | grep -Eo ":..:" | grep -Eo "[0-9]+")
		DAY=$(echo $DATE | grep -Eo "..$")
		echo "created: $CREATED. date:$DATE. year:$YEAR. month:$MONTH. day:$DAY"

		if [ ! -d "$DIR/$YEAR" ]
	        then
        	    echo "Directory $DIR/$YEAR DOES NOT exists."
		    mkdir "$DIR/$YEAR"
        	fi

		case $MONTH in
			"01")
				MNAME="jan"
				;;
			"02")
				MNAME="feb"
				;;
			"03")
				MNAME="mar"
				;;
			"04")
				MNAME="apr"
				;;
			"05")
				MNAME="may"
				;;
			"06")
				MNAME="jun"
				;;
			"07")
				MNAME="jul"
				;;
			"08")
				MNAME="aug"
				;;
			"09")
				MNAME="sep"
				;;
			"10")
			MNAME="oct"
			;;
			"11")
				MNAME="nov"
				;;
			"12")
				MNAME="dec"
				;;
		esac

		if [ ! -d "$DIR/$YEAR/$MONTH-$MNAME" ]
	        then
        	    echo "Directory $DIR/$YEAR/$MONTH-$MNAME DOES NOT exists."
	            mkdir "$DIR/$YEAR/$MONTH-$MNAME"
        	fi

		if [ ! -d "$DIR/$YEAR/$MONTH-$MNAME/$MNAME$DAY" ]
	        then
        	    echo "Directory $DIR/$YEAR/$MONTH-$MNAME/$MNAME$DAY DOES NOT exists."
	            mkdir "$DIR/$YEAR/$MONTH-$MNAME/$MNAME$DAY"
	        fi

		case $(echo $f | grep -c "JPG") in
			"1")
                	        OUTPUTDIR="$DIR/$YEAR/$MONTH-$MNAME/$MNAME$DAY/jpg"
				if [ ! -d "$OUTPUTDIR" ]
	                        then
        	                    echo "Directory $OUTPUTDIR DOES NOT exists."
                	            mkdir "$OUTPUTDIR"
                        	fi
				;;
			"0")
				OUTPUTDIR="$DIR/$YEAR/$MONTH-$MNAME/$MNAME$DAY"
				;;
		esac

		echo "Moved $f to $OUTPUTDIR" >> process.log
		mv $f $OUTPUTDIR

	done

	popd
}

TMPDIR="tmp.$(date "+%s")"
mkdir "$TMPDIR"
pushd "$TMPDIR"
find $INDIR1 -regextype egrep -print -regex ".*9K.*(CR2|JPG)" -exec cp {} . \;
find $INDIR2 -regextype egrep -print -regex ".*9K.*(CR2|JPG)" -exec cp {} . \;

process_dir .

popd

