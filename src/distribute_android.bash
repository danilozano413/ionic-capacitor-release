#!/usr/bin/env bash
release_name=${1:-$(git describe --tags --abbrev=0)}
release_notes_file=./release/${release_name}/release_notes.txt
mkdir -p ./release/${release_name}

if [ ! -f ./release/${release_name}/atum-${release_name}.apk ]; then
# Create apk
echo "Create apk";
cd android
./gradlew task :app:assembleDebug
cd ..

cp ./android/app/build/outputs/apk/debug/app-debug.apk ./release/${release_name}/atum-${release_name}.apk
fi
# Distribute with firebase
echo "Distribute with firebase";

firebase appdistribution:distribute ./release/${release_name}/atum-${release_name}.apk  \
    --app 1:988587561810:android:49ebe9cf13dc565ccae08b  \
    --release-notes-file=${release_notes_file}  --groups-file="./release/groups.txt"
