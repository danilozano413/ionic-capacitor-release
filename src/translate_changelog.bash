#!/usr/bin/env bash
echo "Generate changelog translation";


file=./src/assets/i18n/en/changelog.json
tmpFile=./changelog.tmp.json;
translation=${file}| jq -rS ."versions";


versions=$(jq -rS ".versions" ${file} | jq -rS "keys | .[]");

cp  ${file}  ${tmpFile}

for tag in $(git tag --sort=creatordate)
do
    if [ "$tag" != 0 ];then
        if [[ "$versions" != *"$tag"* ]]; then
        echo "Add ${tag}"

            tag_descripton=$(git tag -n999 ${tag});

            mv  ${file}  ${tmpFile}
            jq ".versions.\"${tag}\".title = \"$tag\"" ${tmpFile}  | jq ".versions.\"${tag}\".content = \"${tag_descripton}\""  > ${file} 

        fi
    fi
done
rm  ${tmpFile}



