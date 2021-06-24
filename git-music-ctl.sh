#! /bin/bash
# set the name of your git repo you are cloning
#GLPDIR="repo-folder"
GLPDIR=
# set git ssh url for cloning
#GLPREPO="git@github.com:user-name/your-repo.git"
GLPREPO=

ROOTDIR="~"
OS=$( uname -o || uname )
echo "OS: $OS"
if [[ $OS == "Android" ]]; then
    ROOTDIR="/sdcard"
fi
echo "Root dir: $ROOTDIR"

# SSH VARS
SSHPATH="${ROOTDIR}/.ssh/"
SSHNAME="id_rsa"

# check if git is installed
# install git if not installed
git --version 1> /dev/null 2>&1
GIT_INSTALLED=$? 
echo "git code: $GIT_INSTALLED"
if [[ $GIT_INSTALLED -ne 0 ]]; then
    case $OS in
        Android)
            pkg install git -y
        ;;
        GNU/Linux)
            sudo apt install git -y
        ;;
        Darwin)
            brew install git -y
        ;;
    esac
else
    echo "git is installed"
fi

# check if ssh-keygen is available
ssh-keygen --version > /dev/null 2>&1
OPENSSH_INSTALLED=$?
echo "ssh-keygen code: $OPENSSH_INSTALLED"
if [[ $OPENSSH_INSTALLED -eq 127 ]]; then
    pkg install openssh -y
# elif [[ $OPENSSH_INSTALLED ]]; then    
else
    echo "openssh is installed"
fi


giterror () {
    echo "Upload your Public Key to Gitlab and run the script again!"
    clear
    echo
    cat "${SSHPATH}${SSHNAME}.pub"
    exit 1
}

# check if ssh key exist
# if ssh key doesnt generate ssh key and display it
# add this key to github/gitlab
if [[ ! -f "${SSHPATH}${SSHNAME}" ]] || [[ ! -f "${SSHPATH}${SSHNAME}.pub" ]] ; then
    echo "SSH Keys doesn't exist!"
    echo "Generating SSH Key"
    ssh-keygen -f "${SSHPATH}${SSHNAME}" -t rsa -b 4096 -P "" -N ""
    giterror
else
    echo "SSH Public and Privat Key Exist!"
    echo
fi

if ! ssh -T git@gitlab.com; then
    echo "SSH Key not added to SSH-Agent"
    eval $(ssh-agent -s)
    ssh-add "${SSHPATH}${SSHNAME}"
    if ! ssh -T git@gitlab.com; then 
        giterror
    fi
fi

# clone git repo if doesnt already exist
# pull latest changes from master if repo exists
if [[ ! -d "${GLPPATH}${GLPDIR}" ]] ; then 
    echo "${GLPDIR} doesnt exist in ${GLPPATH}"
    echo "Cloning ${GLPREPO} into ${GLPPATH}"
    cd $GLPPATH
    git clone ${GLPREPO}
else
    echo "Pulling new Music into ${GLPPATH}${GLPDIR}"
    cd "${GLPPATH}${GLPDIR}"
    git pull origin master
    GIT_RESPONSE=$?
    
    if [[ $GIT_RESPONSE -ne 0 ]] ; then 
        echo "An error Accured while trying to pull Changes From Master"
        exit 1
    fi
fi
echo
echo "Run Successful"
exit 0