DIST=/home/$USER/$REPOSITORY/src

inotifywait -qmr -e create -e modify -e close_write -e delete "$DIST" | while read -r EVENT
do
    echo $EVENT
    timeout 3 cat | tee

    # TODO ...
done
