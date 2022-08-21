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

## [Git Music](music/)
A script used to manage your music on a Android, Linux or Mac
Used to clone your git repo where your Music (or other data) is stored. 

Docker image is also provided to download convert and tag Music run this command inside the folder where your music is stored for best result will count mp3 files and use that as track number :
```bash
    docker run -v $(pwd):/out lukeroy/youtube2mp3 <Song Name> <Artist> <Album Name> <URL>
```

[Termux](https://github.com/termux/termux-app/releases) is required to run the script on Android. All dependencies are automatically installed. Use the the `universal apk`.
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
## [IBM Cloud Functions and Code Engine](IBM-FN-CE/README.md)
 
## [Hacker](hacker.sh)
Use this powerfull script to make you look like you hacked into the Pentagon or any other organisations you want
```bash
hacker.sh <Target>
```

## [Crypt](crypt.sh)
Encrypt Files using Public & Private Key Methode or with Key and IV

**Using Key & IV**
Generate Key and IV and store them in the specified file
```bash
./crypt.sh enc g <file>
```
Encrypt File using Key and IV
```bash
./crypt.sh enc e <file_to_encrypt> <key> <iv>
```
Decrypt File using Key and IV
```bash
./crypt.sh enc e <file_to_decrypt> <key> <iv>
```
**Using RSA Public & Private Key**
Generate Key and IV and store them in the specified file
```bash
./crypt.sh rsa g <file.pem>
```
Encrypt File using Key and IV
```bash
./crypt.sh rsa e <public_key.pem> <file_to_encrypt> 
```
Decrypt File using Key and IV
```bash
./crypt.sh rsa d <private_key.pem> <file_to_decrypt>
```

## [Lenovo MIIX 320 10ICR Fixes](lenovo)
Selection of scripts to help setup Lenovo Miix 320 running Linux

## [ZSH Themes](ZSH_themes)
