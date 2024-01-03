DIST=/home/$USER/$REPOSITORY/dist

inotifywait -qmr -e create -e modify -e close_write "$DIST" | while read -r EVENT
do
    echo $EVENT
    timeout 3 cat | tee

    if test -f "$DIST/book.epub"; then
        java -jar epubcheck-5.1.0/epubcheck.jar "$DIST/book.epub"
    fi
done
