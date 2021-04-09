#!/usr/bin/env bash
echo "Increment version";

# replace version
sed -i '' "s/${1}/${2}/g" capacitor.config.json 
sed -i '' "s/${1}/${2}/g" package.json 

# set commit
git add ./capacitor.config.json;
git add ./package.json;

git commit -m "Increment version";

# increment platform versions
MANIFEST_FILE='android/app/build.gradle';
echo  $1 $2;
currentVersionName=`awk '/versionName/ {print $2}' $MANIFEST_FILE`;
sed -i '' "s/versionName $currentVersionName/versionName '${2}'/" $MANIFEST_FILE;
echo `awk '/versionName/ {print $2}' $MANIFEST_FILE`;

currentVersionCode=`awk '/versionCode/ {print $2}' $MANIFEST_FILE`
sed -i '' 's/versionCode [0-9a-zA-Z -_]*/versionCode '$(($currentVersionCode + 1))'/' $MANIFEST_FILE;


cd ios/App;
agvtool new-marketing-version $2;
agvtool new-version -all $2;
cd ../..;