# https://jsfiddle.net/seport/shrovLgf/embedded/result/

setopt PROMPT_SUBST
autoload colors
colors
# list colors: spectrum_ls
#GIT Status
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[118]%}-%f %{$FG[046]%}(%f"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[046]%})%f"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_UNTRACKED=""          # Displayed when there are untracked files.
ZSH_THEME_GIT_PROMPT_ADDED=""              # Displayed when there are staged changes.
ZSH_THEME_GIT_PROMPT_MODIFIED="M"          # Displayed when there are unstaged changes.
ZSH_THEME_GIT_PROMPT_RENAMED=""            # Displayed when renamed files are staged.
ZSH_THEME_GIT_PROMPT_DELETED=""            # Displayed when there are deleted files.
ZSH_THEME_GIT_PROMPT_STASHED=""            # Displayed when there are stashed changes.
ZSH_THEME_GIT_PROMPT_UNMERGED=""           # Displayed when there are merge conflicts.
ZSH_THEME_GIT_PROMPT_AHEAD=""              # Displayed when the local branch is ahead of remote.
ZSH_THEME_GIT_PROMPT_BEHIND=""             # Displayed when the local branch is behind remote.
ZSH_THEME_GIT_PROMPT_DIVERGED=""           # Displayed when the local and remote branches have diverged.

#PATH:      %{$FG[046]%}[%f%0~/%{$FG[046]%}]%f                                                                                                                                                                                              -> f%0~/
#USER:      %{$fg[cyan]%}%n%f                                                                                                                                                                                                               -> %n
#KUBECTX:   %{$FG[046]%}[%f☁️ : $(kubectl config current-context 2>/dev/null || echo "not set")%{$FG[046]%}]%f %{$FG[046]%}[%f%*%{$FG[046]%}]%f                                                                                              -> $(kubectl config current-context 2>/dev/null || echo "not set")
#TIME:      %{$FG[046]%}[%f%*%{$FG[046]%}]%f                                                                                                                                                                                                -> %*
#LASTCMDS:  %{$FG[046]%}[%f%(?.✔.%{$fg[red]%}✘%f)%{$FG[046]%}]%f                                                                                                                                                                            -> %(?.✔.%{$fg[red]%}✘%f)
#IBMCLOUD:  %{$FG[046]%}[%f$(if ibmcloud account show  2>/dev/null; then ibmcloud account show  2>/dev/null | grep "Account Name:" | sed  "s/Account Name://" | xargs ; else echo "%{$FG[160]%}IBMCLOUD%fIBMCLOUD"; fi)%{$FG[046]%}]%f      ->  if ibmcloud account show  2>/dev/null; then ibmcloud account show  2>/dev/null | grep "Account Name:" | sed  "s/Account Name://" | xargs ; else echo "%{$FG[160]%}IBMCLOUD%fIBMCLOUD"; fi                                                                             
#lLINE:     %{$FG[118]%}-%f
PROMPT='%{$FG[046]%}╭%f%{$FG[046]%}[%f%{$FG[087]%}%0~/%f%{$FG[046]%}]%f$(git_prompt_info) %{$FG[118]%}-%f %{$FG[046]%}[%f$(if ibmcloud account show 1>/dev/null  2>/dev/null; then ibmcloud account show --output JSON  2>/dev/null | grep "\"name\": \"" | sed  "s/ \"name\": \"//" | sed "s/\",//" | tr -s "[:space:]" ; else echo "%{$FG[160]%}IBMCLOUD%f"; fi)%{$FG[046]%}]%f %{$FG[118]%}-%f %{$FG[046]%}[%f🚀 $(kubectl config current-context 2>/dev/null || echo "not set")%{$FG[046]%}]%f %{$FG[118]%}-%f %{$FG[046]%}[%f%*%{$FG[046]%}]%f %{$FG[118]%}-%f %{$FG[046]%}[%f%(?.✔.%{$fg[red]%}✘%f)%{$FG[046]%}]%f
%{$FG[046]%}╰→%f%{$FG[172]%}%n%f 🍻 '
#RPROMPT='%{$FG[046]%}[%f🚀: $(kubectl config current-context 2>/dev/null || echo "not set")%{$FG[046]%}]%f %{$FG[046]%}[%f%*%{$FG[046]%}]%f %{$FG[046]%}[%f%(?.✔.%{$fg[red]%}✘%f)%{$FG[046]%}]%f'