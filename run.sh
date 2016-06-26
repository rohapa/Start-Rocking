echo "Copying Start rocking app to Applications .."
cp -r Start\ Rocking.app /Applications
echo "Copy success"

echo "Copying apple script to desktop"
cp spotify-notify.scpt ~/Desktop

echo "copying plist to library"
cp com.startrocking.plist ~/Library/LaunchAgents
echo "starting app.."
launchctl load ~/Library/LaunchAgents/com.startrocking.plist
echo "app started .."
echo "click the icon in menu bar to control apple script"
