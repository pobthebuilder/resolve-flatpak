resolve-flatpak
===============

This repo allows you to package DaVinci Resolve as a Flatpak for use on Linux Flatpak
based systems, especially e.g. Fedora Silverblue where there aren't easier installation
options. 

It's still a work-in-progress; but "works-for-me[tm]" right now.

Usage
-----

## 1. Clone this repo
```
git clone git@github.com:pobthebuilder/resolve-flatpak.git
git submodule init
git submodule update
```

## 2. Download, Build your package, and export to a distributable single file installer
By default, com.blackmagic.Resolve.yaml is configured to package the latest version of Resolve (18.1.5b2 at the time of writing).

### WIP: Free
```
flatpak-builder --force-clean --repo=repo build-dir com.blackmagic.Resolve.yaml
flatpak build-bundle repo resolve.flatpak com.blackmagic.Resolve # This takes >32 minutes utilizing a single core w/out any vebose output.
$ flatpak install --user resolve.flatpak
```

### Studio
```
flatpak-builder --force-clean --repo=repo build-dir com.blackmagic.ResolveStudio.yaml
flatpak build-bundle repo resolve.flatpak com.blackmagic.ResolveStudio
```

## 3. Enjoy.



# Finding explicit Download IDs
To change to desired version by setting `DOWNLOADID=\'\'` in `download_resolve.sh`.

### Studio:

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
