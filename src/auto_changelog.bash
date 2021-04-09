#!/usr/bin/env bash
echo "Auto generate Changelog file";

previous_tag=0
remote_url=$(git config --get remote.origin.url)
commit_url=${remote_url};

printf "# CHANGELOG  \n\n" > CHANGELOG.md


for tag in $(git tag --sort=creatordate)
do

if [ "$tag" != 0 ];then

    tag_date=$(git log -1 --pretty=format:'%ad' --date=short ${tag})
    tag_descripton=$(git tag -n999 ${tag})
    printf "## ${tag} (${tag_date})  \n\n" >> CHANGELOG.md
    if [ "$tag_descripton" != null ];then
        printf "\`\`\` \n ${tag_descripton} \n\`\`\`  \n\n" >> CHANGELOG.md
    fi


    if [ "$previous_tag" != 0 ];then
        git log ${tag}...${previous_tag} --pretty=format:"* %s [View](${commit_url}/commits/%H)" --reverse | grep -v Merge  >> CHANGELOG.md
    fi
    

    printf "\n ---  \n\n"  >> CHANGELOG.md
fi

previous_tag=${tag}
done



