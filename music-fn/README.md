# Git Music Function Guide
Openwhisk Blackbox Python action to download and convert a Youtube Video to mp3 and tag it 

IBM Cloud Functions can be used to deploy the action or any other `OpenWhisk` based sytem

1. Create Action as a Secured Webaction using the actioncode (`__main__.py`) and the docker image (`lukeroy/music-fn:latest`)
```bash
ibmcloud fn action create gitMusic __main__.py --docker lukeroy/music-fn:latest --web true --web-secure true
```
Default Params that can be set:
`username` Git username
`email` Git email
`key` Private ssh key used for git
`repourl` ssh clone url from git

Download Params that need to be set every time:
`song` The Song Name
`artist` The Artists/Band Name
`album` The Album Name
`url` The Youtube Video URL

2. Get The Key
```bash
ibmcloud fn action get gitMusic
```

3. Get The Url
```bash
ibmcloud fn action get gitMusic --url
```

4. Use Function With curl 
```bash
curl -X POST -H "X-Require-Whisk-Auth: <auth key>" -H "Content-Type: application/json" -d '{"song": "<Song>", "artist": "<Artist>", "album":"<Album>", "url":"<youtube link>"}' <action web url>.json
```

