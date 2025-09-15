# LiveSplit Linux Install

This project provides scripts and configuration to easily install and run [LiveSplit](https://livesplit.org/) on Linux using Wine or Proton, with optional global hotkey support.

## Features

- Automated installation of LiveSplit and required dependencies.
- Optional global hotkey support via a custom Rust binary.
- Desktop shortcuts for easy launching.
- Scripts for running LiveSplit with Wine, Proton for AutoSplit support.

## Installation

1. **Install Dependencies**

Make sure you have the following packages installed:

- `cargo`
- `wine`
- `winetricks`
- `unzip`
- `git`
- `wget`
- `desktop-file-utils` (for `desktop-file-install`)

On Ubuntu/Debian, you can install them with:

```sh
sudo apt install cargo wine winetricks unzip git wget desktop-file-utils
```

2. **Run the Installer**

Clone this repository and run the install script:

```sh
git clone https://github.com/yourusername/livesplit-linux-install.git
cd livesplit-linux-install
./install.sh
```

This will:

- Download and extract the latest LiveSplit build.
- Build and install the hotkey listener.
- Install required Wine dependencies.
- Set up desktop shortcuts and icons.
- Copy launch scripts to `/usr/local/bin`.

## Usage

After installation, you can launch LiveSplit from your application menu.

### Scripts

The following scripts are installed to `/usr/local/bin`:

- `livesplit` -- Run LiveSplit with prepared wine prefix.
- `livesplitwine` -- Same as above, but using the wineprefix of the launcher.
- `livesplitproton` -- Run LiveSplit with Proton (for Steam integration and AutoSplit Support).

Both `livesplitwine` and `livesplitproton` will automatically ensure gdiplus is installed via winetricks so that LiveSplit displays correctly when running under a different prefix.

### Enabling Global Hotkeys

To enable global hotkeys, set the environment variable `LIVESPLIT_HOTKEYS_ENABLED=1` before running the script. For example:

```sh
LIVESPLIT_HOTKEYS_ENABLED=1 livesplitwine
```

Or, for Steam Proton integration, set your game's launch options to:

```
livesplitproton %command%
```

To enable hotkeys in this mode:

```
LIVESPLIT_HOTKEYS_ENABLED=1 livesplitproton %command%
```

### Other Important Information

This uses the latest development build which allows for the TCP server to run at startup. As a consequence of this, if multiple LiveSplits are running, subsequent ones will crash as it will fail to open the TCP port.

With global hotkeys enabled, because of how difficult it is to differentiate if LiveSplit is in focus or not, hotkeys will get double sent.

### Configuration

- The LiveSplit configuration and binaries are installed to `~/LiveSplit`.
- The hotkey listener binary is installed as `~/LiveSplit/live-split-hotkeys`.
- Settings can be adjusted in `~/LiveSplit/settings.cfg` or in LiveSplit itself (Changes aren't saved until the application is closed.).

## Uninstallation

To remove LiveSplit and its scripts:

```sh
rm -rf ~/LiveSplit
sudo rm /usr/local/bin/livesplit /usr/local/bin/livesplitwine /usr/local/bin/livesplitproton
rm ~/.local/share/applications/LiveSplit.desktop
rm ~/.local/share/applications/LiveSplitNoGlobals.desktop
```

## Troubleshooting

- Make sure all dependencies are installed.
- If you encounter issues with Wine or Proton, consult their documentation.
- For hotkey issues, ensure `LIVESPLIT_HOTKEYS_ENABLED=1` is set.

## Credits

- [LiveSplit](https://livesplit.org/)
- [live-split-hotkeys](https://github.com/descawed/live-split-hotkeys) (using my fork for comparison hotkeys and key deduplication, linking to upstream for credit)

Enjoy!