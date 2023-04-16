

resolve-flatpak
===============

This repo allows you to package DaVinci Resolve as a Flatpak for use on Linux Flatpak
based systems, especially e.g. Fedora Silverblue where there aren't easier installation
options. 

It's still a work-in-progress; but "works-for-me[tm]" right now.

Usage
-----

1. `git clone` this repo
By default, com.blackmagic.Resolve.yaml is configured to package the latest version of Resolve Studio (18.1.4 at the time of writing).

3. Build your package, and export to a distributable single file installer:

#### Free
```
flatpak-builder --force-clean --repo=repo build-dir com.blackmagic.Resolve.yaml
flatpak build-bundle repo resolve.flatpak com.blackmagic.Resolve
```
#### Studio
```
flatpak-builder --force-clean --repo=repo build-dir com.blackmagic.ResolveStudio.yaml
flatpak build-bundle repo resolve.flatpak com.blackmagic.ResolveStudio
```

3. Enjoy.

## Finding explicit Download IDs (for download_resolve.sh)
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
