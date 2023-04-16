#!/bin/sh
#
# By default, the script in here will download the latest version of DaVinci Resolve.
#
# Use the following to get a full list of download IDs from Blackmagic:
#curl -o- https://www.blackmagicdesign.com/api/support/nz/downloads.json | jq -r '.downloads[] | select(.urls["Linux"] != null) | select(.urls["Linux"][0]["product"] == "davinci-resolve-studio") | [.urls["Linux"][0].downloadTitle, .urls["Linux"][0].downloadId] | @tsv'
# or:
#curl -o- https://www.blackmagicdesign.com/api/support/nz/downloads.json | jq -r '.downloads[] | select(.urls["Linux"] != null) | select(.urls["Linux"][0]["product"] == "davinci-resolve") | [.urls["Linux"][0].downloadTitle, .urls["Linux"][0].downloadId] | @tsv'
#DaVinci Resolve 18.1.4 6449dc76e0b845bcb7399964b00a3ec4
#DaVinci Resolve 18.1.3 44be7e694b4e440db5d2f70ad732d3b2
#DaVinci Resolve 18.1.2 4755b7bd2d924c0db1980824edb84a20
#DaVinci Resolve 18.1.1 e09749f2de1d4c20a2b707c405d243fd
####
PRODUCT='davinci-resolve'
SITEURL='https://www.blackmagicdesign.com/api/support/latest-version'
REFERID='77ef91f67a9e411bbbe299e595b4cfcc'
USERAGENT="User-Agent: Mozilla/5.0 (X11; Linux ${CARCH}) \
            AppleWebKit/537.36 (KHTML, like Gecko) \
            Chrome/77.0.3865.75 \
            Safari/537.36"
# e.g. DOWNLOADID='44be7e694b4e440db5d2f70ad732d3b2'
DOWNLOADID=''

####
#
# Process arguments
#
####
usage()
{
  echo "Usage: $0 [ -p | --product PRODUCT ] [ -d | --downloadid DOWNLOADID ]"
  echo ""
  echo "PRODUCT is davinci-resolve or davinci-resolve-studio"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n download_resolve.sh -o d:p: --long download:,product: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -p | --prefix)     PRODUCT="$2"    ; shift 2 ;;
    -d | --downloadid) DOWNLOADID="$2" ; shift 2 ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

####
#
# Find a download link
#
####
USERAGENT="$(printf '%s' "$USERAGENT" | sed 's/[[:space:]]\+/ /g')"

# The following will find the latest version of Resolve/Resolve Studio.
REQJSON="{ \
    \"product\": \"${PRODUCT}\", \
    \"platform\": \"linux\" \
}"
REQJSON="$(  printf '%s' "$REQJSON"   | sed 's/[[:space:]]\+/ /g')"
if [ -z "${DOWNLOADID}" ]; then
    DOWNLOADID="$(curl \
                -s \
                -H 'Host: www.blackmagicdesign.com' \
                -H 'Accept: application/json, text/plain, */*' \
                -H 'Origin: https://www.blackmagicdesign.com' \
                -H "$USERAGENT" \
                -H 'Content-Type: application/json;charset=UTF-8' \
                -H "Referer: https://www.blackmagicdesign.com/support/download/${REFERID}/Linux" \
                -H 'Accept-Encoding: gzip, deflate, br' \
                -H 'Accept-Language: en-US,en;q=0.9' \
                -H 'Authority: www.blackmagicdesign.com' \
                -H 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
                --data-ascii "$REQJSON" \
                --compressed \
                "$SITEURL" | jq -r '.["linux"]["downloadId"]')"
fi

REQJSON="{ \
    \"firstname\": \"Flatpak\", \
    \"lastname\": \"Builder\", \
    \"email\": \"someone@flathub.org\", \
    \"phone\": \"202-555-0194\", \
    \"country\": \"us\", \
    \"state\": \"New York\", \
    \"city\": \"FPK\", \
    \"product\": \"DaVinci Resolve\" \
}"
REQJSON="$(  printf '%s' "$REQJSON"   | sed 's/[[:space:]]\+/ /g')"
SITEURL="https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}"
SRCURL="$(curl \
            -s \
            -H 'Host: www.blackmagicdesign.com' \
            -H 'Accept: application/json, text/plain, */*' \
            -H 'Origin: https://www.blackmagicdesign.com' \
            -H "$USERAGENT" \
            -H 'Content-Type: application/json;charset=UTF-8' \
            -H "Referer: https://www.blackmagicdesign.com/support/download/${REFERID}/Linux" \
            -H 'Accept-Encoding: gzip, deflate, br' \
            -H 'Accept-Language: en-US,en;q=0.9' \
            -H 'Authority: www.blackmagicdesign.com' \
            -H 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
            --data-ascii "$REQJSON" \
            --compressed \
            "${SITEURL}")"

FNAME="$(curl \
            --no-clobber \
            -gqb '' -C - --retry 3 --retry-delay 3 \
            -H 'Host: sw.blackmagicdesign.com' \
            -H 'Upgrade-Insecure-Requests: 1' \
            -H "${USERAGENT}" \
            -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
            -H 'Accept-Language: en-US,en;q=0.9' \
            -w '%{filename_effective}' \
            --compressed \
            -O \
            ${SRCURL})"
unzip -x "${FNAME}"
