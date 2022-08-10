# Git Music Function Guide

1. Create Action as Secured Webaction
```bash
ibmcloud fn action create gitMusic __main__.py --docker lukeroy/music-fn:latest --web true --web-secure true
```
Default Params:
`username` Git username
`email` Git email
`key` Private ssh key used for git
`repourl` ssh clone url from git

2. Get The Key
```bash
ibmcloud fn action get gitMusic
```

2. Get The Url
```bash
ibmcloud fn action get gitMusic --url
```

4. Use Function With curl
```bash
curl -X POST -H "X-Require-Whisk-Auth: <auth key>" -H "Content-Type: application/json" -d '{"song": "<Song>", "artist": "<Artist>", "album":"<Album>", "url":"<youtube link>"}' <action web url>.json
```

