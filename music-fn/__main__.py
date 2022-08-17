import git # https://gitpython.readthedocs.io/en/stable/
import gitlab # https://python-gitlab.readthedocs.io/en/stable/index.html
import os, sys, stat
import uuid
import shutil

# Create SSH KEY and connect to git returns error object or false if succesful
def setupSSH(key, hostname):
    print("---> Setting Up Connection to git")
    sshdir = '/root/.ssh'
    if not os.path.exists(sshdir):
        os.mkdir(sshdir)
        print(f"---> Create {sshdir} dir")
    else:
        print("---> .ssh dir exists")

    with open( sshdir + '/id_rsa', 'w') as f:
        f.write(key)
        f.close()
    
    os.chmod(sshdir + '/id_rsa', 0o600)
    add2hosts = f'ssh-keyscan -H {hostname} >>  {sshdir}/known_hosts'
    sshcode = os.system(add2hosts)
    if sshcode != 0:
        r["message"] = f"Failed to Connect to {hostname}"
        print(f"---> {r['message']}")
        return r
    
    print("---> Connection to gitlab confirmed")
    return False

# gitlab function to create Merge Request
def gitlab(hostname, token, repoURL, branch, merge):
    # Login to Gitlab
    print(f"---> Login to {hostname}")
    gl = gitlab.Gitlab(private_token=token)
    print(f"---> Get Project ID")
    projects = gl.projects.list(search=repoURL.split("/",1)[1].split(".",1)[0])
    
    # Connect to Gitlab Project
    projectid = projects[len(projects)-1].id
    print(f"---> Connect to Project: {projectid}")
    project = gl.projects.get(projectid)
    
    # Create Merge Request
    mTitle = f'Merging new Music into branch {branch}'
    mDescription = f'Adding Music into master branch from {branch}'
    print(f"---> Create Merge Request for Project: {projectid} on Branch: {branch} ")
    mr = project.mergerequests.create({'source_branch': branch, 'target_branch': 'master', 'title': mTitle, 'description': mDescription})
    print(f"---> Merge URL: {mr.web_url}")

    # If params is set Merge Pull/Merge request
    if merge != False or merge != "false":
        mr.merge()
        r["message"] = "Successfully downloaded Music, Created Pull/Merge request and merge it automatically"
        r["error"] = False
        print(f"---> {r['message']}")
        return r

    # Downloaded Music and Create Pull/Merge request
    r["message"] = "Successfully downloaded Music and Created Pull/Merge request"
    r["error"] = False
    r["url"] = mr.web_url
    print(f"---> {r['message']}")
    return r

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

# Return Structure Data
r = {
    "message": "Action Failed!",
    "error": True,
    "url": "",
    "branch": ""
}

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
            r["message"] = "Music is not a list and cant be processed"
            print(f"---> {r['message']}")
            return r
    else:
        r["message"] = "Required Parameters are missing!"
        print(f"---> {r['message']}")
        return r

    # Optional Parma to auto merge the merge request
    # merge = params["merge"] if 'merge' in params else False
    if 'merge' in params:
        merge = params["merge"]
    else:
        merge = False

    hostname = repoURL.split("@",1)[1].split(":",1)[0]

    # setup SSH Connection to git 
    returnValue = setupSSH(key, hostname)
    if returnValue != False:
        return returnValue

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
    r["branch"] = branch
    print(f"---> Create and Checkout Branch: {branch}")
    repo.git.branch(branch)
    repo.git.checkout(branch)

    # Download all the songs in the list
    commitStr = "Adding Music to playlist:"
    failedStr = "Failed to add Songs:\n"
    successfulDownloads = 0
    for m in music:
        if not all (k in m for k in ("song", "artist", "album", "url")): 
            r["message"] = "Required Music Parameters are missing!"
            print(f"---> {r['message']}")
            return r

        print("---> Setting Music Variables")
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
            failedStr += f'{song}-{artist} = {url} |\n'

    # If all Downloads fail end Function
    if successfulDownloads == 0:
        print("---> Failed to Download all Songs")
        r["message"] = f"{failedStr}"
        print(f"---> {r['message']}")
        return r

    if len(music) == successfulDownloads:
        print("---> All Songs have been downloaded!")

    # Add and Commit changes
    print("---> Add and Commit changes")
    repo.git.add('--all')
    repo.git.commit('-m',  commitStr)
    
    # Push changes
    print("---> Push changes")
    repo.git.push('origin', branch)

    # Create Merge Request
    if hostname == "gitlab.com":
        return gitlab(hostname, token, repoURL, branch, merge)

    # Downloaded music without creating a Pull/Merge request
    r["message"] = "Successfully downloaded Music"
    r["error"] = False
    print(f"---> {r['message']}")
    return r


    