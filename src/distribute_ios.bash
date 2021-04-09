#!/usr/bin/env bash
release_name=${1:-$(git describe --tags --abbrev=0)}
release_notes_file=./release/${release_name}/release_notes.txt
mkdir -p ./release/${release_name}

if [ ! -f ./release/${release_name}/AtumApp.ipa ]; then
    # Create ipa
    echo "Create ipa";
    cd ios
    archivePath=../release/${release_name}/atum-${release_name}.xcarchive;
    xcodebuild archive -workspace ./App/App.xcworkspace -scheme App -archivePath ${archivePath}
    xcodebuild -exportArchive -archivePath ${archivePath} -exportPath ../release/${release_name} -exportOptionsPlist ../release/exportOptions.plist
    # remove temporal files
    rm -Rf ${archivePath}
    cd ..
fi

# Distribute with Firebase
echo "Distribute with Firebase";
firebase appdistribution:distribute ./release/${release_name}/AtumApp.ipa  \
    --app 1:988587561810:ios:34d4dca7995a8627cae08b  \
    --release-notes-file=${release_notes_file}  --groups-file="./release/groups.txt"

