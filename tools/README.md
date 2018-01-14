# Proofreading tools

## Tools

Mind the slash before * in command line

	ruby process.rb capitalize_heading ../text/i/\*.txt

Commands

- get_dash_dict - outputs list of words with dashes

## After first stage

* Normalise whitespace:
	
	* Remove trailing whitespace
	* Normalise lineendings (\n)
	* Add empty line at end of file

* Replace CAPS WORDS with normal case
* Merge hyphen words (with dictionary)
* Replace double chars on line break (—, =, +, -)
* Fix quotation marks („…“ to «…») in Book II and Franko

## After second stage

* Normalise whitespace
* Escape % (with \%)

## Command line commands

add new line to the end of file

	sed -i -e '$a\' file

replace tabs with spaces

	sed -i $'s/\t/    /g' *.txt

remove trailing spaces:

	sed -i 's/[ \t]*$//' "$1"
	
Rename files:

    find -name '*.txt' | sort | gawk 'BEGIN{ a=61 }{ printf "mv %s %04d.txt\n", $0, a++ }' | bash

Test rename:

    find -name '*.tif' | sort | gawk 'BEGIN{ a=1 }{ printf "echo %s !%04d.tif\n", $0, a++ }' | bash 

Replace char in filenames:

	rename 's/\:/-/g' *.txt -vn

Mass file convert

	mogrify -type Grayscale -format jpg -resize 50% -auto-level -quality 80 *.tif

	mogrify -type Grayscale -format jpg -auto-level -quality 80 *.tif

