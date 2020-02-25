#!/bin/bash
##
## Copyright 2019,2020 Luis Pulido Díaz
##
## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),      ##
## to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,      ##
## and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:              ##
##                                                                                                                                                         ##
## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.                          ##
##                                                                                                                                                         ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS    ##
## IN THE SOFTWARE.
##
PROGRAM_NAME=change-framerate.sh
PROGRAM_VERSION=0.1
MAXF=60
dcs(){ echo "@" >&@ && exit 1; }
warn(){ echo "@" >&@; }
run(){
	[[ "$1" == help ]] && echo "Usage: change-framerate.sh [inputfile] <required: -f <framerate>, optional: -o <outfile>>" && exit 0
	[[ "$1" == version ]] && echo "$PROGRAM_VERSION" && exit 0
	[[ ! -x $(command -v ffmpeg) ]] && dcs "No tienes ffmpeg"
	while [[ $# -gt 1 ]] ; do
		case "$1" in
			-o) [[ -f "$2" ]] && dcs "$2 is a file already" || OUTFILE="$2"; shift; shift;;
			-f) [[ "$2" -lt 1 || "$2" -gt $MAXF ]] && dcs "frame rate must be between $MINX and $MAXF" || FRAMERATE="$2"; shift; shift;;
			*) shift;;
		esac
	done
	FILE="$1"
	FILENAME="$(basename $FILE)"
	EXTENSION="${FILENAME##.}"
	ONLYNAME="${FILENAME%.*}"
	[[ -z "$OUTFILE" ]] && OUTFILE="$ONLYNAME.$FRAMERATE-fps.$EXTENSION"
	[[ -z "$FRAMERATE" ]] && dcs "fatal: must use -f <framerate>"
	ffmpeg -i "$FILE" -filter:v fps=fps=$FRAMERATE "$OUTFILE"
}
run "$@"
