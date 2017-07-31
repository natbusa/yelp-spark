#!/bin/bash

#tar -zxf test_photos.tgz
#tar -zxf train_photos.tgz

rm -rf preview/ filelists/ sequencefiles/

mkdir filelists
rm -f filelists/train_*
rm -f filelists/test_*

(cd train_photos; find . -name '*.jpg' | split - -d -a4 -l10000 --additional-suffix= train_photos_group_ ; mv -f train_photos_group_* ../filelists) > /dev/null 2>&1
(cd test_photos;  find . -name '*.jpg' | split - -d -a4 -l10000 --additional-suffix= test_photos_group_ ; mv -f test_photos_group_* ../filelists) > /dev/null 2>&1

for f in $(ls filelists); do
  sed -i 's/\.\///' filelists/$f
done

mkdir preview
mkdir sequencefiles

for g in test_photos train_photos; do
  for f in $(cd filelists; ls ${g}_*); do
    echo processing $g $f
    for i in $(cat filelists/$f); do  python process.py $g/$i preview/; done

    (cd preview; tar -czf ../sequencefiles/$f.tgz -T ../filelists/$f ) > /dev/null 2>&1
    java -jar tar-to-seq.jar sequencefiles/$f.tgz sequencefiles/$f.hsf > /dev/null 2>&1
    rm sequencefiles/$f.tgz
    rm sequencefiles/.*.crc
  done
done

