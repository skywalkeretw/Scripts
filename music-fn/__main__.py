import git
import os, sys, stat
import uuid
import shutil

# Required Params and their usage 
# key, repourl, username and email can be set as default so they dont need to be sent with every request
#
# params = {
#     "key": "SSH Private Key without password used for git",
#     "repourl": "Git clone ssh url",
#     "username": "Git Username used to identify commiter",
#     "email": "Git email used to identify commiter",
#     "token": "gitlab Token",
#     "music" [{
#           "song": "Song Name",
#           "artist":"Artist Name",
#           "album":"Album Name",
#           "url":"Youtube Video URL"
#     }]
# }

def main(params):
    print("---> Start")
    # Check Keys
    print("---> Checking Params")
    if all (k in params for k in ("key", "repourl", "username", "email", "token", "music")): #"song", "artist", "album", "url",
        print("---> All Keys Are Set")
        key = params["key"]             # SSH Private Key without password used for git
        repoURL = params["repourl"]     # Git clone ssh url
        username = params["username"]   # Git Username used to identify commiter
        email = params["email"]         # Git email used to identify commiter
        token = params["token"]         # Gitlab Token
        music = params["music"]         # Array of Music
        if not isinstance(music, list):
            print("---> Music is not a list")
            return {
                "result": f'Music is not a list'
            }        
    else:
        print("---> Params are missing")
        return {
            "result": f'Params are missing',
        }

    # setup SSH Connection to git 
    print("---> Setting Up Connection to git")
    sshdir = '/root/.ssh'
    if not os.path.exists(sshdir):
        os.mkdir(sshdir)
        print("Create %s", sshdir )
    else:
        print("---> .ssh dir exists")

    with open( sshdir + '/id_rsa', 'w') as f:
        f.write(key)
        f.close()
    
    os.chmod(sshdir + '/id_rsa', 0o600)
    hostname = repoURL.split("@",1)[1].split(":",1)[0]
    add2hosts = f'ssh-keyscan -H {hostname} >>  {sshdir}/known_hosts'
    os.system(add2hosts)


    # Clone the Repository
    musicdir = '/playlist'
    if os.path.exists(musicdir):
        print(f"---> Deleting {musicdir} so clone will work")
        shutil.rmtree(musicdir)

    print(f"---> Clone Repository: {repoURL} into {musicdir}")
    repo = git.Repo.clone_from(repoURL, musicdir)
    os.chdir(musicdir)


    # Set Username and Email
    print("---> Set Git Username and Email")
    repo.config_writer().set_value("user", "name", username).release()
    repo.config_writer().set_value("user", "email", email).release()


    # Create and Checkout new Branch
    branch = uuid.uuid4().hex
    print(f"---> Create and Checkout Branch: {branch}")
    repo.git.branch(branch)
    repo.git.checkout(branch)

    # Download all the songs in the list
    commitStr = "Adding Music to playlist:\n"
    failedStr = ""
    successfulDownloads = 0
    for m in music:
        if not all (k in params for k in ("song", "artist", "album", "url")): 
            print("---> Params are missing")

        song = m["song"]           # Song Name
        artist = m["artist"]       # Artist Name
        album = m["album"]         # Album Name
        url = m["url"]             # Youtube Video URL

        # Download and Tag Song to git repository
        print(f"---> Run music Script for: {song} - {artist} - {album} - {url}")
        cmdString = f'music \"{song}\" \"{artist}\" \"{album}\" \"{url}\"'
        code = os.system(cmdString)

        if code == 0:
            print(f"---> Downloaded and Tagged {song} by {artist}")
            successfulDownloads += 1
            commitStr += f'\nSong: {song}\nArtist: {artist}\nAlbum: {album}\nURL: {url}'
        else:
            print(f"---> Failed to Download and Tag {song} from {url}")
            failedStr += f'Failed to download {song} - {url}'

    # If all Downloads fail end Function
    if successfulDownloads == 0:
        print("---> Failed to Download all Songs")
        return {
            "result": 'Failed to Download all Songs',
            "failed": failedStr,
        }

    # Add and Commit changes
    print("---> Add and Commit changes")
    repo.git.add('--all')
    repo.git.commit('-m',  commitStr)
    
    # Push changes
    print("---> Push changes")
    repo.git.push('origin', branch)

    # Create Merge Request
    if hostname == "gitlab.com":
        print(f"---> Login to {hostname} cli")
        loginStr = f"glab auth login -t {token} -h {hostname}"
        glabCode = os.system(loginStr)
        
        if glabCode == 0: 
            print(f"---> Create Merge Request for {hostname}")
            mTitle = f'Merging {song} from {artist}'
            mDescription = f'Adding {song} - {album} from {artist} '
            mergeRequestStr = f"glab mr create --title \"{mTitle}\" --description \"{mDescription}\" | grep {hostname}"
            mergeOut = os.popen(mergeRequestStr).read()
            

    print("---> Finished")
    return {
        "result": f'Successfully downloaded {song} - {album} by {artist}',
        "failed": failedStr,
        "url": mergeOut.replace("\n", ""),
        "branch": branch
    }
