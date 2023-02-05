
resolve-flatpak
===============

This repo allows you to package DaVinci Resolve as a Flatpak for use on Linux Flatpak
based systems, especially e.g. Fedora Silverblue where there aren't easier installation
options. 

It's still a work-in-progress; but "works-for-me[tm]" right now.

Usage
-----

1) git clone this repo
2) Put your:
DaVinci_Resolve_18.1.2_Linux.zip
or:
DaVinci_Resolve_Studio_18.1.2_Linux.zip
in this directory.

3) Uncomment the correct part of the com.blackmagic.Resolve.yaml for Free or Studio.
4)
```
flatpak-builder --user --install --force-clean build-dir com.blackmagic.Resolve.yaml
```
5) Enjoy.

