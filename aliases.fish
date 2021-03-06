#
#  Useful aliases
#
#  Author: [Dmitry](http://dmi3.net) [Source](https://github.com/dmi3/fish)

# Show 3 (next and prev) months in cal, start week on monday
alias cal="ncal -bM3"

# Create missing directories in path
alias mkdir='mkdir -pv'

# Print full file path
alias path='readlink -e'

# Remove directories but ask nicely
alias rmm='rm -rvI'

# Copy directories but ask nicely
alias cpp='cp -R'

# add current directory to path
alias add-to-path='set -U fish_user_paths (pwd) $fish_user_paths'

# Human readable sizes (i.e. Mb, Gb etc)
alias df='df -h'
alias du='du -ch'
alias free='free -m'

alias xs='cd'

alias ...='cd ../..'

alias sizeof="du -hs"

function ll --description "Scroll ll if theres more files that fit on screen"
  ls -l $argv --color=always | less -R -X -F
end  

function mkcd --description "Create and cd to directory"
  mkdir $argv
  and cd $argv
end

function open --description "Open file in new process"
  xdg-open $argv & 
end

function amount --description "Mount archive"
  /usr/lib/gvfs/gvfsd-archive file=$argv 2>/dev/null &
  sleep 1
  cd $XDG_RUNTIME_DIR/gvfs  
  cd (ls -p | grep / | tail -1) # cd last created dir
end

function aumount --description "Unmount all mounted archive (and gvfs locations)"
  gvfs-mount --unmount $XDG_RUNTIME_DIR/gvfs/*
end

# Useful for piping, i.e. `cat ~/.ssh/id_rsa.pub | copy`
# If arguments are given, copies it to clipboard
function copy --description "Copy pipe or argument"
  if [ "$argv" = "" ]
    xclip -sel clip
  else
    printf "$argv" | xclip -sel clip
  end    
end

function copypath --description "Copy full file path"
  readlink -e $argv | xclip -sel clip
end

function color --description "Print color"
  echo (set_color (string trim -c '#' "$argv"))"██"
end

function reset_windows --description  "Reset all windows size and bring it to main monitor. Useful if DE messes up in multiple monitor configuration"
  for f in (wmctrl -l | cut -d' ' -f 1)
    wmctrl -i -r $f -e 0,0,0,800,600
    wmctrl -i -a $f
  end
end

# Prepend `sudo` to `nano` command if file is not editable by current user
# Warn if file does no exist
function nano
  if not test -e "$argv"
    read -p "echo 'File $argv does not exist. Ctrl+C to cancel'" -l confirm
    touch "$argv" 2>/dev/null
  end

  if test -w "$argv"    
    /bin/nano -mui $argv
  else
    echo "Editing $argv requires root permission"
    sudo /bin/nano -mui $argv
  end
end

function run --description "Make file executable, then run it"
  chmod +x "$argv"
  eval "./$argv"
end

function b --description "Exec command in bash. Useful when copy-pasting commands with imcompatible syntax to fish "
  bash -c "$argv"
end

# If Sublime Text installed - use it instead of Gedit
if type -q subl
  alias gedit=subl
end

# If [sssh](https://github.com/dmi3/bin/blob/master/sssh) installed - use it instead of ssh
if type -q sssh
  alias ssh=sssh
end

function subl --description "Starts Sublime Text. Additionally supports piping (i.e. `ls | subl`) and urls (i.e. `subl http://jenkins/logs`)"
  if [ (expr substr "$argv[1]" 1 4) = "http" ]
    curl $argv[1] | subl
  else if not tty >/dev/null
    set FILENAME (tempfile)
    cat >"$FILENAME"
    /opt/sublime_text/sublime_text "$FILENAME" "$argv"
  else
    /opt/sublime_text/sublime_text "$argv"
  end
end