# screenshot

Grabs a screenshot from a connected Android device over `adb` and copies it straight to your Windows clipboard. No cables to disk, no "where did that file go" — just capture and paste.

## Requirements

- [ADB](https://developer.android.com/tools/adb) installed and on your `PATH`.
- An Android device connected and authorized (`adb devices` should list it).
- PowerShell.

## Usage

```powershell
.\screenshot.ps1
```

Copies the screenshot to the clipboard. Paste it anywhere (Slack, an image editor, a doc...).

To also keep a copy on disk:

```powershell
.\screenshot.ps1 -Save C:\Users\me\Desktop\shot.png
```

Or via the `.cmd` wrapper:

```cmd
screenshot.cmd
screenshot.cmd -Save C:\Users\me\Desktop\shot.png
```

## How it works

1. Runs `adb shell screencap -p` on the device to capture the screen.
2. Pulls the PNG to a temp file with `adb pull`.
3. Cleans up the file on the device.
4. Loads the image and pushes it onto the Windows clipboard via `System.Windows.Forms.Clipboard`.
5. Deletes the local temp file (unless `-Save` was given, in which case a copy is kept).

## Add it to your PATH

Drop this folder somewhere permanent and add it to your `PATH`, then you can run `screenshot` from anywhere.
