#!/usr/bin/env bash

rm proj*.flp
rm -rf render out samples

to_hex () {
  echo "$(sed 's/./&\\x00/g' <<< $1)"
}

MIDI_PATH="/home/apiersa/MUSIC/MIDI/grooves"
BPM=90
mkdir out
mkdir render
mkdir samples

produce.sh ./music/$(ls music |shuf -n1) 9 90

drums.sh $MIDI_PATH/$(ls $MIDI_PATH | shuf -n1) 9

PHRASE_LENGTH=`bc <<< "scale=10; 60/"$BPM" * 4"`
for d in $(ls render); do
  echo $d
  echo $PHRASE_LENGTH
  ecasound -i select,0,$PHRASE_LENGTH,render/$d -o render/_$d
  rm render/$d
  mv render/_$d render/$d
done;

# PATTERN_1 = \xc4\x48 | \x25\x00

# PATTERN1="P\x00R\x00E\x00S\x00E\x00T\x00S\x00\\\x00a\x00u\x00t\x00o\x00\\\x00b\x00e\x00a\x00t\x00.\x00w\x00a\x00v"
PATTERN2=$(to_hex "PROJEKTY")'\\\x00'$(to_hex "test")'\\\x00'$(to_hex "render")'\\\x00'$(to_hex "$(ls $PWD/render | shuf -n1)")
# PATTERN2=$(to_hex "PRESETS")'\\\x00'$(to_hex "auto")'\\\x00'$(to_hex "beat.wav")

LEN=91 # ~/MUSIC (28) + PATH (80) + 3 null bytes


for i in `seq 1 5`;
do
  PATTERN2=$(to_hex "PROJEKTY")'\\\x00'$(to_hex "test")'\\\x00'$(to_hex "render")'\\\x00'$(to_hex "$(ls $PWD/render | shuf -n1)")
  bbe -e 's/P\x00R\x00E\x00S\x00E\x00T\x00S\x00\\\x00a\x00u\x00t\x00o\x00\\\x00b\x00e\x00a\x00t\x00.\x00w\x00a\x00v/'$PATTERN2'/' ~/MUSIC/PRESETS/auto/original.flp > tmp$i.flp
  PATTERN2=$(to_hex "PROJEKTY")'\\\x00'$(to_hex "test")'\\\x00'$(to_hex "render")'\\\x00'$(to_hex "$(ls $PWD/render | shuf -n1)")
  bbe -e 's/P\x00R\x00E\x00S\x00E\x00T\x00S\x00\\\x00a\x00u\x00t\x00o\x00\\\x00b\x00e\x00a\x00t\x002\x00.\x00w\x00a\x00v/'$PATTERN2'/' tmp$i.flp > tmp2$i.flp
  PATTERN2=$(to_hex "PROJEKTY")'\\\x00'$(to_hex "test")'\\\x00'$(to_hex "render")'\\\x00'$(to_hex "$(ls $PWD/render | shuf -n1)")
  bbe -e 's/P\x00R\x00E\x00S\x00E\x00T\x00S\x00\\\x00a\x00u\x00t\x00o\x00\\\x00b\x00e\x00a\x00t\x003\x00.\x00w\x00a\x00v/'$PATTERN2'/' tmp2$i.flp > tmp3$i.flp
  PATTERN2=$(to_hex "PROJEKTY")'\\\x00'$(to_hex "test")'\\\x00'$(to_hex "out")'\\\x00'$(to_hex "$(ls $PWD/out | shuf -n1)")
  bbe -e 's/P\x00R\x00E\x00S\x00E\x00T\x00S\x00\\\x00a\x00u\x00t\x00o\x00\\\x00s\x00a\x00m\x00p\x00l\x00e\x00.\x00w\x00a\x00v/'$PATTERN2'/' tmp3$i.flp > tmp4$i.flp
  PATTERN2=$(to_hex "PROJEKTY")'\\\x00'$(to_hex "test")'\\\x00'$(to_hex "out")'\\\x00'$(to_hex "$(ls $PWD/out | shuf -n1)")
  bbe -e 's/P\x00R\x00E\x00S\x00E\x00T\x00S\x00\\\x00a\x00u\x00t\x00o\x00\\\x00s\x00a\x00m\x00p\x00l\x002\x00.\x00w\x00a\x00v/'$PATTERN2'/' tmp4$i.flp > tmp4_i_5$i.flp
  bbe -e 's/\xc4\x48/\xc4\x5b/' tmp4_i_5$i.flp > tmp5$i.flp # 5b = 91
  bbe -e 's/\xc4\x4a/\xc4\x5b/g' tmp5$i.flp > tmp6$i.flp # 5b = 91
  bbe -e 's/\xc4\x4c/\xc4\x55/g' tmp6$i.flp > project$i.flp # 55 = 85

  rm tmp*$i.flp
done;
