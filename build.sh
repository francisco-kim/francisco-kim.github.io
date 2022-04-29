#!/bin/sh

# Remove contents of public directory
if [ -d "public" ]
then
    if [ "$(ls -A public)" ]; then
        rm -r public/*
        echo "Directory \"public\" successfully emptied."
    else
        echo "Directory \"public\" is already empty."
    fi
else
    echo "Directory \"public\" not found."
fi

# Execute Emacs Lisp file to build site
emacs -Q --script build-site.el

