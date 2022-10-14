#!/bin/sh

# Remove contents of public directory
if [ -d "docs" ]
then
    if [ "$(ls -A docs)" ]; then
        rm -r docs/*
        echo "Directory \"docs\" successfully emptied."
    else
        echo "Directory \"docs\" is already empty."
    fi
else
    echo "Directory \"docs\" not found."
fi

# Execute Emacs Lisp file to build site
emacs -Q --script build-site.el

