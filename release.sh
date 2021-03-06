#!/bin/sh

git pull origin master

echo -e "\nCompiling and Stripping"
LDFLAGS="$LDFLAGS -static -s -w -no-pie -Wl,--gc-sections"
LDFLAGS="$LDFLAGS $(pkg-config --static --libs gtk+-2.0)"
go build --ldflags "-linkmode external -extldflags '$LDFLAGS'"

echo -e "\nPackaging"
folder="sharenix-$(uname -m)"
mkdir -p "$folder"
mv ./sharenix $folder/sharenix
cp ./sharenix.json $folder/sharenix.json

rm "$folder".tar.xz
tar -cvJf "$folder".tar.xz \
    "$folder"/sharenix \
    "$folder"/sharenix.json

echo -e "\nResult:"
tar tf "$folder".tar.xz

readelf --dynamic "$folder"/sharenix
ldd "$folder"/sharenix

