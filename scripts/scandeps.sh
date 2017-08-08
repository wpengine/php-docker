#!/bin/bash

DEPTH=6

rm -f .rundeps.*
cp .rundepscore .rundeps.sorted.0

function scan {
  scanelf -nBR --use-ldpath --format '%n' $1 | sed "s/,/\n/g" | sed "s/ /\n/g" >> .rundeps.pass.$2;
}

for p in $(seq 1 $DEPTH)
do
        for i in `cat .rundeps.sorted.$((p-1))`
        do
                scan $i $p
        done
        sort -u .rundeps.pass.$p > .rundeps.sorted.$p
done

comm .rundeps.sorted.$DEPTH <(sort .rundepscore) -3 > .rundeps
rm .rundeps.*