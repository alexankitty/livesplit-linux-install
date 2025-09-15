#! /usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
livesplit_artifact=https://raw.githubusercontent.com/LiveSplit/LiveSplit.github.io/artifacts/LiveSplitDevBuild.zip
livesplit_install_path="$HOME/LiveSplit"
livesplit_hotkeys=https://github.com/alexankitty/live-split-hotkeys/
export WINEPREFIX="$HOME/.local/share/livesplit"

EXEC_LINE="Exec=env LIVESPLIT_HOTKEYS_ENABLED=1 WINEPREFIX=$WINEPREFIX "
EXEC_LINE+="/usr/local/bin/livesplit %u"
EXEC_LINE_NO_GLOBALS="Exec=env LIVESPLIT_HOTKEYS_ENABLED=1 WINEPREFIX=$WINEPREFIX "
EXEC_LINE_NO_GLOBALS+="/usr/local/bin/livesplit %u"
PATH_LINE="Path=$livesplit_install_path"
DESKTOP_PATH="$HOME/.local/share/applications"
ICON_PATH=~/.local/share/icons/hicolor/256x256/apps/

if [[ -z $(which cargo) ]]; then
    echo "Cargo is not installed. Please install cargo from your distro's package manager."
    exit 1
fi

if [[ -z $(which wine) ]]; then
    echo "Wine is not installed. Please install wine from your distro's package manager."
    exit 1
fi

if [[ -z $(which unzip) ]]; then
    echo "Unzip is not installed. Please install unzip from your distro's package manager."
    exit 1
fi

if [[ -z $(which git) ]]; then
    echo "Git is not installed. Please install git from your distro's package manager."
    exit 1
fi

if [[ -z $(which wget) ]]; then
    echo "Wget is not installed. Please install wget from your distro's package manager."
    exit 1
fi

git clone -b remove-global-hotkey-setting $livesplit_hotkeys /tmp/live-split-hotkeys || {
    echo "Failed to clone LiveSplit hotkeys repository."
    exit 1
}

cargo build --release --manifest-path /tmp/live-split-hotkeys/Cargo.toml || {
    echo "Failed to build LiveSplit hotkeys."
    exit 1
}
mkdir -p $livesplit_install_path || {
    echo "Failed to create LiveSplit installation directory."
    exit 1
}

cp /tmp/live-split-hotkeys/target/release/live-split-hotkeys $livesplit_install_path || {
    echo "Failed to copy LiveSplit hotkeys binary."
    exit 1
}

rm -rf /tmp/live-split-hotkeys

cp $SCRIPT_DIR/settings.cfg $livesplit_install_path || {
    echo "Failed to copy settings.cfg."
    exit 1
}

wget -O /tmp/LiveSplitDevBuild.zip $livesplit_artifact || {
    echo "Failed to download LiveSplit artifact."
    exit 1
}
unzip -o /tmp/LiveSplitDevBuild.zip -d $livesplit_install_path || {
    echo "Failed to unzip LiveSplit artifact."
    exit 1
}
rm /tmp/LiveSplitDevBuild.zip
echo "LiveSplit installed to $livesplit_install_path"
echo "LiveSplit hotkeys binary installed to $HOME/LiveSplit/live-split-hotkeys"

winetricks gdiplus || {
    echo "Failed to install gdiplus via winetricks."
    exit 1
}

cp "$SCRIPT_DIR/livesplit.png" "$ICON_PATH/livesplit.png"
sed -i "s|^Exec=.*|$EXEC_LINE|" "$SCRIPT_DIR/LiveSplit.desktop"
sed -i "s|^Path=.*|$PATH_LINE|" "$SCRIPT_DIR/LiveSplit.desktop"
sed -i "s|^Exec=.*|$EXEC_LINE_NO_GLOBALS|" "$SCRIPT_DIR/LiveSplitNoGlobals.desktop"
sed -i "s|^Path=.*|$PATH_LINE|" "$SCRIPT_DIR/LiveSplitNoGlobals.desktop"
desktop-file-install --dir="$DESKTOP_PATH" "$SCRIPT_DIR/LiveSplit.desktop"
desktop-file-install --dir="$DESKTOP_PATH" "$SCRIPT_DIR/LiveSplitNoGlobals.desktop"
update-desktop-database "$DESKTOP_PATH" || {
    echo "Failed to update desktop database."
    exit 1
}

echo "Requesting admin rights to copy scripts to /usr/local/bin"
sudo cp "$SCRIPT_DIR/scripts"/* /usr/local/bin/ || {
    echo "Failed to copy scripts to /usr/local/bin."
    exit 1
}

echo ""
echo "LiveSplit shortcut installed to $DESKTOP_PATH"
echo "You can now launch LiveSplit from your application menu."
echo "For autosplitting in steam proton, prefix your launch options with: livesplitproton"
echo "For example: livesplitproton %command%"
echo "To enable global hotkeys, set LIVESPLIT_HOTKEYS_ENABLED=1 in your environment variables or before livesplitwine/livesplitproton."
echo "For example: LIVESPLIT_HOTKEYS_ENABLED=1 livesplitproton %command%"
echo "Enjoy! :)"