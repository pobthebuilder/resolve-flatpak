#!/bin/bash
#
# I should probably be a python script.
###
STUDIO='false'

usage()
{
  echo "Usage: $0 [ -s | --studio ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n setup_resolve.sh -o sp: --long studio,prefix: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -s | --studio)  STUDIO='true' ; shift   ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

APP_ID="com.blackmagic.Resolve"
APP_DESCRIPTION="DaVinci Resolve"
APP_TAG="davinci-resolve"
if ${STUDIO}; then
  APP_ID="com.blackmagic.ResolveStudio"
  APP_DESCRIPTION="DaVinci Resolve Studio"
  APP_TAG="davinci-resolve-studio"
fi

mkdir -p /app/share/metainfo
chmod 755 /app/share/metainfo
cat > /app/share/metainfo/${APP_ID}.metainfo.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright 2013 First Lastname <your@email.com> -->
<component type="desktop-application">
  <id>${APP_ID}</id>
  <metadata_license>FSFAP</metadata_license>
  <project_license>LicenseRef-proprietary</project_license>
  <name>${APP_DESCRIPTION}</name>
  <summary>Professional Editing, Color, Effects and Audio Post!</summary>

  <description>
    <p>
      DaVinci Resolve is the world’s only solution that combines editing, color correction, visual effects, motion graphics and audio post production all in one software tool! Its elegant, modern interface is fast to learn and easy for new users, yet powerful for professionals. DaVinci Resolve lets you work faster and at a higher quality because you don’t have to learn multiple apps or switch software for different tasks. That means you can work with camera original quality images throughout the entire process. It’s like having your own post production studio in a single app! Best of all, by learning DaVinci Resolve, you’re learning how to use the exact same tools used by Hollywood professionals!
    </p>
  </description>

  <launchable type="desktop-id">${APP_ID}.desktop</launchable>

  <screenshots>
    <screenshot type="default">
      <caption>DaVinci Resolve 18 Cut Page</caption>
      <image>https://images.blackmagicdesign.com/images/products/davinciresolve/overview/onesolution/carousel/cut.jpg</image>
    </screenshot>
    <screenshot>
      <caption>DaVinci Resolve 18 Edit Page</caption>
      <image>https://images.blackmagicdesign.com/images/products/davinciresolve/overview/onesolution/carousel/edit.jpg</image>
    </screenshot>
    <screenshot>
      <caption>DaVinci Resolve 18 Color Page</caption>
      <image>https://images.blackmagicdesign.com/images/products/davinciresolve/overview/onesolution/carousel/color.jpg</image>
    </screenshot>
    <screenshot>
      <caption>DaVinci Resolve 18 Fusion Page</caption>
      <image>https://images.blackmagicdesign.com/images/products/davinciresolve/overview/onesolution/carousel/fusion.jpg</image>
    </screenshot>
    <screenshot>
      <caption>DaVinci Resolve 18 Fairlight Page</caption>
      <image>https://images.blackmagicdesign.com/images/products/davinciresolve/overview/onesolution/carousel/fairlight.jpg</image>
    </screenshot>
  </screenshots>

  <url type="homepage">https://www.blackmagicdesign.com/products/davinciresolve</url>
  <project_group>Blackmagicdesign</project_group>

  <provides>
    <binary>resolve</binary>
  </provides>

  <releases>
EOF
curl -o- https://www.blackmagicdesign.com/api/support/nz/downloads.json | 
	jq --arg APP_TAG "${APP_TAG}" -r '
                def url_linux: .urls["Linux"][0];
		.downloads[] | 
		select(.urls["Linux"] != null) | 
		select(.urls["Linux"][0]["product"] == $APP_TAG) | 
    "    <release version=\"" + (.urls["Linux"][0].major|tostring) + "." + (.urls["Linux"][0].minor|tostring) + "." + (.urls["Linux"][0].releaseNum|tostring) + "~" + (.numericDate|tostring) + "\" date=\"" + (.numericDate / 1000|strftime("%Y-%m-%d")) + "\">",
		"      <description>",
		.desc, 
		"      </description>", 
		"    </release>"
	' >> /app/share/metainfo/${APP_ID}.metainfo.xml

cat >> /app/share/metainfo/${APP_ID}.metainfo.xml <<EOF
  </releases>
</component>
EOF
