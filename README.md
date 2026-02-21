

resolve-flatpak
===============

This repo allows you to package DaVinci Resolve as a Flatpak for use on Linux Flatpak
based systems, especially e.g. Fedora Silverblue where there aren't easier installation
options. 

It's still a work-in-progress; but "works-for-me[tm]" right now.

Usage
-----

1. If you have appimagelauncherd (the AppImage Launcher daemon) installed and enabled, you NEED to temporarely disable it (either through systemctl or through the AppImage Launcher GUI) as it conflicts with flatpak-builder during the .run file repackaging process.

2. Clone this repo with: `git clone https://github.com/pobthebuilder/resolve-flatpak.git --recursive`
By default, com.blackmagic.Resolve.yaml is configured to package the latest version of Resolve (18.5 Beta 3 at the time of writing).

3. Build your package, and export to a distributable single file installer:

#### Free
```
flatpak-builder --install-deps-from=flathub --force-clean --repo=.repo .build-dir com.blackmagic.Resolve.yaml
```

To simply install the built version:
```
flatpak --user remote-add --no-gpg-verify resolve-repo .repo
flatpak --user install resolve-repo com.blackmagic.Resolve
```

To build a redistruble single file package:
```
flatpak build-bundle .repo resolve.flatpak com.blackmagic.Resolve --runtime-repo=https://flathub.org/repo/flathub.flatpakrepo
```

#### Studio
```
flatpak-builder --install-deps-from=flathub --force-clean --repo=.repo .build-dir com.blackmagic.ResolveStudio.yaml
```

To simply install the built version:
```
flatpak --user remote-add --no-gpg-verify resolve-repo .repo
flatpak --user install resolve-repo com.blackmagic.ResolveStudio
```

To build a redistruble single file package:
```
flatpak build-bundle .repo resolve.flatpak com.blackmagic.ResolveStudio --runtime-repo=https://flathub.org/repo/flathub.flatpakrepo
```

4. Enjoy.

## udev rules (Resolve Studio)
On some distros, you may need to add udev rules to enable Resolve Studio to access your USB licence key, otherwise Resolve will segfault at the "Checking Licences..." splash screen. An example udev rule is below:

```
# Allow Flatpak apps to access USB devices with vendor ID 096e (Feitan Technologies), needed by DaVinci Resolve Studio when using USB licence keys
# Place this file in /etc/udev/rules.d/
# Recommended file name: 99-davinci-usb.rules

SUBSYSTEM=="usb", ATTR{idVendor}=="096e", TAG+="uaccess"
SUBSYSTEM=="usb", ATTR{idVendor}=="096e", MODE="0664", GROUP="plugdev"
```

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

## Licensing
The icon in logo.png is licensed under the Creative [Commons Attribution-Share Alike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/deed.en) and fetched from [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DaVinci_Resolve_Studio.png). It was only cropped afterwards.

## Related

- [Flathub forum : DaVinci Resolve Feature Requests](https://discourse.flathub.org/t/davinci-resolve-flatpak-request/842)
- [blackmagicdesign forum : DaVinci Resolve Flatpak request](https://forum.blackmagicdesign.com/viewtopic.php?f=33&t=186259)
