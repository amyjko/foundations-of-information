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
    # The binder nests each edition's output under its base path, so this
    # book's root is build/<base>, not build/ itself. Uploading build/ puts the
    # site several directories too deep and 404s every page.
    ROOT="build$(node -p "require('./book.json').base || ''")"
    # Copy the .htaccess file to the book root
    cp .htaccess "$ROOT"
    # Sync the book root to the hosting folder
    rsync -vzripc --delete "$ROOT/" ajko@ovid.u.washington.edu:~/public_html/books/foundations-of-information
fi