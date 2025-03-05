#!/usr/bin/bash
# [[file:index.org::build-website.sh][build-website.sh]]
# Get location where script is running
#  Ref: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Run the file
emacs --batch --load="~/.emacs.d/init.el" \
      --eval "(org-babel-load-file \"${SCRIPT_DIR}/index.org\")"
# build-website.sh ends here
