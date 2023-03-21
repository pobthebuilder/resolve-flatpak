

resolve-flatpak
===============

This repo allows you to package DaVinci Resolve as a Flatpak for use on Linux Flatpak
based systems, especially e.g. Fedora Silverblue where there aren't easier installation
options. 

It's still a work-in-progress; but "works-for-me[tm]" right now.

Usage
-----

 1. `git clone` this repo
 2. Edit the Flatpak manifest, `com.blackmagic.Resolve.yaml` to select the version:
By default, com.blackmagic.Resolve.yaml is configured to package the latest version of Resolve Studio (18.1.4 at the time of writing).

To change from Studio to Free:

#### Studio:

```
        _product="davinci-resolve-studio"
```

#### Free:

```
        _product="davinci-resolve"
```
#### Explicit Release:
Alternatively, you can specify an explicit downloadId:

Do this by overriding the _downloadid:
```
        # Uncomment this to hard code the download if you want a specific version
        # _downloadid='44be7e694b4e440db5d2f70ad732d3b2'
```
See below for code to find explicit Download IDs.

 3. Build (& install) your package:
```
flatpak-builder --user --install --force-clean build-dir com.blackmagic.Resolve.yaml
```
 4. Enjoy.

## Finding explicit Download IDs
#### Studio:

```
curl -o- https://www.blackmagicdesign.com/api/support/nz/downloads.json |
    jq -r '.downloads[]
            | select(.urls["Linux"] != null)
            | select(.urls["Linux"][0]["product"] == "davinci-resolve-studio")
            | [.urls["Linux"][0].downloadTitle, .urls["Linux"][0].downloadId]
            | @tsv'
```

#### Free:

```
curl -o- https://www.blackmagicdesign.com/api/support/nz/downloads.json |
    jq -r '.downloads[]
            | select(.urls["Linux"] != null)
            | select(.urls["Linux"][0]["product"] == "davinci-resolve")
            | [.urls["Linux"][0].downloadTitle, .urls["Linux"][0].downloadId]
            | @tsv'
```
