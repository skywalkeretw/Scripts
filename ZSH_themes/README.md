# ZSH Themes

Custom ZSH prompt themes for Oh My Zsh showing path, git status, kubectl context, clock, and last command status.

## Requirements

- [Oh My Zsh](https://ohmyz.sh/) installed
- ZSH as your shell

## Themes

### skywalker-etw-beer-kube.zsh-theme
A colorful prompt with:
- Current directory path
- Git branch and status
- Kubernetes context (cached for performance)
- Current time
- Last command status (✔/✘)
- Beer emoji 🍻

### skywalker-etw-ibm.zsh-theme
Extended version with IBM Cloud support:
- All features from beer-kube theme
- IBM Cloud account name
- Rocket emoji 🚀 for kubectl context

## Installation

1. Copy the theme file to your Oh My Zsh themes directory:
```bash
cp skywalker-etw-beer-kube.zsh-theme ~/.oh-my-zsh/themes/
# or
cp skywalker-etw-ibm.zsh-theme ~/.oh-my-zsh/themes/
```

2. Edit your `~/.zshrc` file and set the theme:
```bash
ZSH_THEME="skywalker-etw-beer-kube"
# or
ZSH_THEME="skywalker-etw-ibm"
```

3. Reload your shell:
```bash
source ~/.zshrc
```

## Performance Notes

Both themes cache the kubectl context to avoid calling `kubectl` on every prompt render, which significantly improves performance. The cache updates every 5 seconds.

## Dependencies

- **Oh My Zsh**: Required for `git_prompt_info` function and color helpers
- **kubectl**: Optional, for Kubernetes context display
- **ibmcloud CLI**: Optional, only for skywalker-etw-ibm theme
