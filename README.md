# Scripts
Useful  and  useless bash scripts for all use cases 

## [Bash Drinking](bash-drinking.sh)
Terminal drinking game programmed in BASH

Start Game:
```bash
./bash-drinking.sh Player1 Player2 Player...
```

Change between diffrent Modes using the following flags:
- Never have i ever: -n | --never
- The drinking game: -d | --drink
- Ring of Fire: -r | --ring
- Most Likely: -m | --most

IF yo dont specify a mode all modes are used

swich to german: -l | --lang

## [IBM Cloud Functions](ibmcloudFN.sh)
Generates sinple IBM cloud Functions Snippets
- go
- php
- python
- ruby
- swift
- node
```bash
./ibmcloudFN.sh <Programming_language>
```

## [Tic Tac Toe](tic-tac-toe.sh)
Terminal Tic Tac Toe
use the letters to select the field or the numbers on the numberpad (a = 1 ...)

## [Git Music](git-music-ctl.sh)
A script used to manage your music on a Android, Linux or Mac
Used to clone your git repo where your Music (or other data) is stored
[Termux](https://play.google.com/store/apps/details?id=com.termux) is required to run the script on Android. All dependencies are automatically installed.
[BlackPlayer EX](https://play.google.com/store/apps/details?id=com.kodarkooperativet.blackplayerex&hl=en&gl=US) Is the Used Music Player app For Android

Execute on Android
Pull new music from Repo
```bash
bash git-music-ctl.sh pull
```
Push Music Changes to Repo
```bash
bash git-music-ctl.sh push
```

 