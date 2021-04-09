#!/usr/bin/env bash
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY] | [sS][iI]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

previous_tag=$(git describe --tags --abbrev=0)
current_branch=$(git rev-parse --abbrev-ref HEAD)
new_tag=$(semver ${previous_tag} -i ${1:-"prerelease"} )
echo " New ${current_branch} ${1:-"prerelease"} version: ${new_tag}";
mkdir -p ./release/${new_tag}

# check clean status

# auto translate
# simpleen translate
# simpleen lock

# git commit -m "Auto translate langs files"

# replace version
bash ./scripts/increment_version.bash ${previous_tag} ${new_tag};

release_notes_file=./release/${new_tag}/release_notes.txt
if [ -f "$release_notes_file" ]; then
    if $(confirm "You want to regenerate release notes?[N]") ; then
        bash ./scripts/last_commits.bash
    fi
else 
    bash ./scripts/last_commits.bash
fi


git tag -a ${new_tag} -m "$(<${release_notes_file})"

bash ./scripts/auto_changelog.bash
git add ./changelog.md
git commit -m "Update Changelog"

bash ./scripts/translate_changelog.bash
git add ./src/assets/i18n/en/changelog.json
git commit -m "Update app Changelog"

# Bulid app
echo "Bulid app";
ionic cap sync -c develop

echo "Make app and upload to firebase"
bash ./scripts/distribute_android.bash
bash ./scripts/distribute_ios.bash

git push && git push --tags
