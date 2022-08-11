import git
import os, sys, stat
import uuid


def main(params):
    # print(params)

    # setup SSH Connection to git 
    print("---> Setting Up Connection to git")
    sshdir = '/root/.ssh'
    if not os.path.exists(sshdir):
        os.mkdir(sshdir)
        print("Create %s", sshdir )
    with open( sshdir + '/id_rsa', 'w') as f:
        f.write(params["key"])
        f.close()
    os.chmod(sshdir + '/id_rsa', 0o600)
    os.system('ssh-keyscan -H gitlab.com >> ' + sshdir + '/known_hosts')

    # Clone the Repository
    print("---> Clone Repository")
    musicdir = '/playlist'
    repoURL = params["repourl"]
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

    # # Add and Commit changes
    print("---> Add and Commit changes")
    repo.git.add('--all')
    repo.git.commit('-m',  f'Add: {params["song"]} from {params["artist"]}')

    # Push changes
    print("---> Push changes")
    repo.git.push('origin', branch)

    # repo.git.push("--set-upstream", "origin", branch)
    
    print("---> Finished")
    return {
        "result": "Success full",
        "song": params["song"],
        "artist": params["artist"],
        "album": params["album"],
        "url": params["url"],
        "branch": branch
    }
