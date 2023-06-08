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
By default, `download_resolve.sh` is hardoced to package the latest stable version of Resolve (18.1.4 as of time of writing). 'build-bundle' takes >32 minutes utilizing a single core w/out any vebose output.

### Free
```
flatpak-builder --force-clean --repo=repo build-dir com.blackmagic.Resolve.yaml
flatpak build-bundle repo resolve.flatpak com.blackmagic.Resolve
```

### Studio
```
flatpak-builder --force-clean --repo=repo build-dir com.blackmagic.ResolveStudio.yaml
flatpak build-bundle repo resolve.flatpak com.blackmagic.ResolveStudio
```

## 3. Enjoy
```
flatpak install --user resolve.flatpak
```


## Manual Version Selection
To change to desired version by setting `DOWNLOADID=\'\'` in `download_resolve.sh`. Instructions on how to get ID are in `download_resolve.sh`.
