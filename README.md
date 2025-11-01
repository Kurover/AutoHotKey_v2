![Tray image](/tray-image.webp)
# AutoHotKey_v2
AHK scripts with compiler setup. Mainly for v2 and has limited support for v1. These are made for myself at first, to discover what I can do with AHK, but I decided to share it and definitely because I didn't lose my scripts due to HDD failure with no backup, yes.

## What is This?
On the surface, it's a bunch of script that does its own thing once it's called via hotkey.

You may notice the comments inside the file use 3rd person noun like "we" "our". TLDR it's a roleplay. This whole shenanigan is primarily directed for a group of mine to explain or teach them what any of these text doing there. The "person" who's explaining it is a mob character from Touhou Project universe, the kappas. They have relatively advanced technology and the script / modules in this repository are their "gadget" that they are making. It's only relevant with the separate, non-public, writings that goes along with it.

## Credits
### Graphics
- `cursor.png` and any `*.ico` are made by me. Feel free to use, modify, and distribute these.

### Scripts used/modified in this project
- Lexikos / G33kDude [Vista Audio Control](https://github.com/ahkscript/VistaAudio?tab=License-1-ov-file) and [Volume.ahk](https://gist.github.com/G33kDude/5b7ba418e685e52c3e6507e5c6972959). Add custom hotkey and remove global audio control function.
- lblb's [Cursor Highlighter](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=78701). Stripped down to only include picture on cursor functionality and no GUI. Ctrl + P to terminate by default.

If you are the owner of the script and don't want it redistributed here, contact me and I will squash it ASAP.

### Related Software
Optional and relevant script is disabled by default. Install these yourself.
- Nirsoft [nircmd](https://www.nirsoft.net/utils/nircmd.html) for `Toggle Mute Program.ahk`.
- pukkandan [YTDL GUI](https://github.com/pukkandan/YDL) for `myShortcut.ahk`.
- [gallery-dl](https://github.com/mikf/gallery-dl) and [yt-dlp](https://github.com/yt-dlp/yt-dlp) for `GalleryDL.ahk` and `YouTube Clipper.ahk`. Install as environment variable or set its path in the setting.

### Other
- [bfxr](https://github.com/increpare/bfxr) for sound effects.
- [Notepad++](https://notepad-plus-plus.org) with [AHK syntax highlighting](https://github.com/jNizM/ahk_notepad-plus-plus) for development.
- The AutoHotKey community to accompany me scratching my head off on why xyz doesn't work.

## Feature Lists
### Overview
- A compiler to merge the content of each scripts into a single file, divided into 3 version - Main, Elevated (run as admin), and Legacy (v1 scripts).
- Compiler only parse `.txt` and `.ahk` file inside `Modules` folder. Other version use their own sub-directory, `Elevated` and `Version1`. `Disabled` is to dump any script you don't want without deleting. `Program` is to contain program-specific script so it doesn't clutter `Modules` folder, it's merged to main script.
- Compiler remove comments and any line before `;compileremoveme` for script inside the modules. It saves a few kilobytes off of your drive.
- Settings to change script easily, for example hotkeys, using iniread. The entry is not automatic, so you have to write with it in mind (or ignore and write normally without including hotkey iniread blabla).
- Merge default settings into user generated one after compile. This prevent modified entry from being replaced if there's any modification from the source, this repository. Who knows, maybe I'll expand the script modules more.
- Script template creator `== Create Script.ahk` created after first compiler run, to easily create new one with cheat sheet attached. Input the name and create. It will open it on notepad immediately so you can work with it.
- Script created with above entry uses `.include` created after first compiler run, to simulate it as a compiled script. It points to the root folder and hotkeys to exit & reload the script. This is true to all premade script in the modules.
- `.core.txt` for the tray settings and variables for their respective version. It's text format to prevent accidental run.

### Compiler
Once run, it will create necessary files for modules to work (mainly settings.ini and local variable of script location paths). Then it will compile module script into one, `Run-Gadget.ahk` and other 2 that will compile it to run as admin and v1 ahk script. Definitely, absolutely, do not run the `Run-Gadget.ahk` provided by the repository, you might get.. well moving on.

Upon finishing, it will run `Run-Gadget.ahk`. You can change what's run upon completion in the freshly baked settings.ini file in the compiler folder.

Settings should be modified in `settings.ini`. Anything on `settings_default.ini` is only applied when `settings.ini` doesn't exist or has missing entry during compiling.

### Modules
List of modules and what they do. Each type has their own icon tray and variables except `Disabled`. This is editable in respective `.core.txt`. Text format to prevent user to run these accidentaly.

#### Main
Default script and is run after compile.
- **Adjust Audio Globally** | Win + Scroll to adjust volume, Win + M.Click to toggle mute. 
- **Adjust Audio on Taskbar** | Scroll on taskbar to adjust main volume. Ctrl + Left click on taskbar to toggle speaker mute. The scroll script is straight from the official documentation. This key isn't modifiable in the settings (skill issue on my part).
- **Admin Permission Administrator** | Win + B to open a GUI to apply registry hack on an executable. It can prevent it from running as administrator (via RunAsInvoker) or vice versa (why not).
- **Center Window on Screen** | Win + H to center active window on your screen. No effect on full-screen window.
- **Link Paste Redirect** | Convert and paste a Twitter/Reddit/Youtube link in your clipboard to a redirect proxy with Win + V, mainly for embedding in Discord and such. Works as Ctrl + V and will output warning tooltip if the content is unchanged.
- **Open Directory of Focused Program** | Win + Shift + O to open directory of active window process.
- **Toggle Cursor Pointer** | Win + P to summon big cursor below your cursor. This is an object on screen so OBS "display capture" will show them despite your cursor visibility setting. This uses [Cursor Highlighter](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=78701) script.
- **Toggle Hidden Files** | F3 + H on windows explorer explorer to show/hide system hidden files.
- **Toggle Mute Sound Device** | Win + M to mute microphone. Win + N to mute speaker. Might have to configure this in `settings.ini` to point to your device {NAME}.
- **Toggle Pin Window to Top** | Win + A to pin active window. Straight out of the docs, with added flavor of sfx and tooltip.
- **Windows App Shortcut** | Win + C to open calculator, press it again after it run to open notepad. Win + Q to open volume mixer, press it again after it run to open audio device properties.

#### Elevated (run as admin)
None! Because I'm not (and don't want to be) responsible for any damage to your possession when a script is running with administrator privilege and I'd like to prevent that by default either way. Put any script module here or develop your own to run them as admin upon auto/run. Useful for pesky program that requires admin run and has garbage automation function as these can render your hotkey non-functional when its window is active.

#### Legacy (v1 scripts)
Version 1 instance of scripts.
- **Program Volume Control** | Win + Scroll to adjust active window volume (via windows audio mixer). Press Ctrl alongside to increment the audio by 10. Win + M.Click to mute active window. This utilize [Lexikos's](https://gist.github.com/G33kDude/5b7ba418e685e52c3e6507e5c6972959) script and its libraries.

#### Disabled by default
Disabled either to overlapping feature or requiring you to install the relevant software first.
- **Adjust Audio on Taskbar Hotkey-Version** | Title. Might be bad for performance as scrolling can be quite fast.
- **GalleryDL** | Invoke [gallery-dl](https://github.com/mikf/gallery-dl) (default) or [yt-dlp](https://github.com/yt-dlp/yt-dlp) (depending on filter) on your clipboard with Ctrl + Alt + D. Alternatively with Ctrl + Shift + D, macro right click => copy link => gallery-dl on your browser. Point and click download basically.
- **GalleryDL Vivaldi** | Invoke the script from GalleryDL when Vivaldi is active.
- **Toggle Mute Program** | Win + S to mute active window using nircmd. Also not needed if you use v1 script, `Program Volume Control` due to overlap.
- **Link Paste Redirect 2** | A dupe with the first one with different hotkey so you can essentially add multiple target.
- **ShareX Reset Increment** | Win + J to reset ShareX timelapse counter. [Standalone version](https://gist.github.com/Kurover/1154a441738434c810922617c85e1075).
- **myShortcut** | A small sample of specific / niche scripts, may or may not be expanded.
- **YouTube Clipper** | Win + Shift + Y open GUI to quickly clip a section of video via copying video link at x time. Requires ytdlp and is still WIP.