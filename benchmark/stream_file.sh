#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

set -eo pipefail

# Uses: 'hyperfine', available with 'conda install -y  -c conda-forge hyperfine'

command -v hyperfine || (echo "Missing hyperfine"; exit 1)

if [ ! -e "$DIR"/../TE/example1.bam ]; then
    echo "Download the input datasets first"
    exit
fi


FILE=$1

if [ ! -e "$FILE" ]; then
	echo "$FILE not found"
	exit
fi

	TAG=$(basename $FILE | cut -f1 -d.)

	echo "$TAG [$FILE]"
	hyperfine --warmup 2 --min-runs 6 --cleanup 'rm *.bed || true' \
		--export-markdown stream_$TAG.md \
		"samtools depth -a $FILE > /dev/null" \
		"samtools depth $FILE > /dev/null" \
		"covtobed $FILE > /dev/null" \
		"bedtools genomecov -bga -ibam $FILE > /dev/null"
