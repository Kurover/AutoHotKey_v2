# AutoHotKey_v2
AHK scripts with compiler setup. Mainly for v2 and has limited support for v1. These are made for myself at first, to discover what I can do with AHK, but I decided to share it and definitely because I didn't lose my scripts due to HDD failure with no backup, yes.

## What is This?
You may notice the comments inside the file use 3rd person noun like "we" "our". TLDR it's a roleplay. That's because it's primarily directed for a group of mine to explain or teach them what any of these text doing there. The "person" who's explaining it is a mob character from Touhou Project universe, the kappas. They have relatively advanced technology and the script / modules in this repository are their "gadget" that they are making. It's only relevant with the separate, non-public, writings that goes along with it.

## Credits
### Scripts used/modified in this project
- Lexikos / G33kDude [Vista Audio Control](https://github.com/ahkscript/VistaAudio?tab=License-1-ov-file) and [Volume.ahk](https://gist.github.com/G33kDude/5b7ba418e685e52c3e6507e5c6972959)
- lblb's [Cursor Highlighter](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=78701)

### Related Software
Optional and disabled by default. Install these yourself.
- Nirsoft [nircmd](https://www.nirsoft.net/utils/nircmd.html) for `Toggle Mute Program.ahk`.
- pukkandan [YTDL GUI](https://github.com/pukkandan/YDL) for `myShortcut.ahk`.
- [gallery-dl](https://github.com/mikf/gallery-dl) and [yt-dlp](https://github.com/yt-dlp/yt-dlp) for `GalleryDL.ahk`. Install as environment variable.

https://github.com/increpare/bfxr
## Feature Lists
- A compiler to merge the content of each scripts into a single file, divided into 3 version - Main, Elevated (run as admin), and Legacy (v1 scripts).
- Compiler only parse `.txt` and `.ahk` file inside `Modules` folder. Other version use their own sub-directory, `Elevated` and `Version1`. `Disabled` is to dump any script you don't want without deleting. `Program` is to contain program-specific script so it doesn't clutter `Modules` folder, it's merged to main script.
- Compiler remove comments and any line before `;compileremoveme` for script inside the modules. It saves a few kilobytes off of your drive.
- Settings to change script easily, for example hotkeys, using iniread. The entry is not automatic, so you have to write with it in mind (or ignore and write normally without including hotkey iniread blabla).
- Merge default settings into user generated one after compile. This prevent modified entry from being replaced if there's any modification from the source, this repository. Who knows, maybe I'll expand the script modules more.
- Script template creator `== Create Script.ahk` created after first compiler run, to easily create new one with cheat sheet attached. Input the name and create. It will open it on notepad immediately so you can work with it.
- Script created with above entry uses `.include` created after first compiler run, to simulate it as a compiled script. It points to the root folder and hotkeys to exit & reload the script. This is true to all premade script in the modules.
- `.core.txt` for the tray settings and variables for their respective version. It's text format to prevent accidental run.

### Modules
WIP