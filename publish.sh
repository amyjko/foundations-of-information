#!/bin/zsh
# Exit when commands fail.
set -e
# Delete the reader if it's sitting around.
if [ -d "bookish-reader" ]
then
    rm -rf bookish-reader
fi
# Clone the reader.
git clone https://github.com/amyjko/bookish-reader
cd bookish-reader
# Bind the book, moving the build here.
zsh bind.sh

if [ "$1" = "preview" ]
then
    npx vite preview
else
    # Back to root
    cd ..
    # Delete the reader
    rm -rf bookish-reader
    # Copy the .htaccess file to the build
    cp .htaccess build
    # Sync the build folder to the hosting folder
    rsync -vzripc --delete build/ ajko@ovid.u.washington.edu:~/public_html/books/foundations-of-information
fi