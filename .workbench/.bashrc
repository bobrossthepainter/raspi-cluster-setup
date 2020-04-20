git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="docker@\[\033[32m\]\w\[\033[33m\]\$(git_branch)\[\033[00m\]\$ "
