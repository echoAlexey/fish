#  Functions useful for developers  
#
#  Author: [Dmitry](http://dmi3.net) [Source](https://github.com/dmi3/fish)

alias git-show-unpushed-commits='git cherry -v' 

function git-revert-file --description "Revert single file in git"
  git reset HEAD $argv; git checkout $argv
end

function gradle --description "Use ./gradlew if exists"
  if test -e ./gradlew
    ./gradlew $argv
  else
    eval (which gradle) $argv
  end
end