#!/usr/bin/env bash
current_tag=$(git describe --tags)
previous_tag=$(git describe --tags --abbrev=0)
new_tag=$(semver ${previous_tag} -i ${1:-"prerelease"} )


mkdir -p ./release/${new_tag}

echo ${new_tag} > ./release/${new_tag}/release_notes.txt

git log ${current_tag}...${previous_tag} --pretty=format:"- %s " --reverse >> ./release/${new_tag}/release_notes.txt
# description=$(git log ${current_tag}...${previous_tag} --pretty=format:"- %s " --reverse)

# echo ${new_tag};
# echo ${description};
echo "Edit release notes"
nano ./release/${new_tag}/release_notes.txt
