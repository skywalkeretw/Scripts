import git
import os, sys, stat
import uuid

# Required Params and their usage 
# key, repourl, username and email can be set as default so they dont need to be sent with every request
#
# params = {
#     "key": "SSH Private Key without password used for git",
#     "repourl": "Git clone ssh url",
#     "username": "Git Username used to identify commiter",
#     "email": "Git email used to identify commiter",
#     "song": "Song Name",
#     "artist":"Artist Name",
#     "album":"Album Name",
#     "url":"Youtube Video URL"
# }

def main(params):
    print("---> Start")
    
    # Check Keys
    print("---> Checking Param Keys")
    if all (k in params for k in ("key", "repourl", "username", "email", "song", "artist", "album", "url")):
        print("---> All Keys Are Set")
    else:
        print("---> Keys are missing")

    # setup SSH Connection to git 
    print("---> Setting Up Connection to git")
    sshdir = '/root/.ssh'
    if not os.path.exists(sshdir):
        os.mkdir(sshdir)
        print("Create %s", sshdir )
    else:
        print("---> .ssh dir exists")

    with open( sshdir + '/id_rsa', 'w') as f:
        f.write(params["key"])
        f.close()
    
    os.chmod(sshdir + '/id_rsa', 0o600)
    repoURL = params["repourl"]

    add2hosts = f'ssh-keyscan -H {repoURL.split("@",1)[1].split(":",1)[0]} >>  {sshdir}/known_hosts'
    os.system(add2hosts)


    # Clone the Repository
    print("---> Clone Repository")
    musicdir = '/playlist'
    if os.path.exists(musicdir):
        os.rmdir(musicdir)
        print(f"---> Deleting {musicdir} so clone will work")

    repo = git.Repo.clone_from(repoURL, musicdir)
    os.chdir(musicdir)


    # Set Username and Email
    print("---> Set Username and Email")
    repo.config_writer().set_value("user", "name", params["username"]).release()
    repo.config_writer().set_value("user", "email", params["email"]).release()


    # Create and Checkout new Branch
    print("---> Create and Checkout Branch")
    branch = uuid.uuid4().hex
    repo.git.branch(branch)
    repo.git.checkout(branch)

    
    # Download and Tag Song to git repository
    print("---> Run music Script")
    cmdString = f'music \"{params["song"]}\" \"{params["artist"]}\" \"{params["album"]}\" \"{params["url"]}\"'
    print("--->", cmdString)
    os.system(cmdString)

    # Add and Commit changes
    print("---> Add and Commit changes")
    repo.git.add('--all')
    repo.git.commit('-m',  f'Add: {params["song"]} from {params["artist"]}')

    # Push changes
    print("---> Push changes")
    repo.git.push('origin', branch)
    
    print("---> Finished")
    return {
        "result": f'Successfully downloaded {params["song"]} - {params["album"]} by {params["artist"]}',
        "url": params["url"],
        "branch": branch
    }
