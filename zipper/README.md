# zipper

Zips up a folder while skipping the junk you never want in the archive — `node_modules`, `bin`, `dist`, build logs, etc. Works from PowerShell, Git Bash, or as a right-click "Zip with Ignore" context menu entry on Windows.

## Usage

### PowerShell

```powershell
.\zip_with_ignore.ps1 -TargetDir "C:\path\to\folder"
```

Creates `folder.zip` next to the target folder.

### Git Bash

```bash
./zip_with_ignore.sh /c/path/to/folder
```

### Right-click "Zip with Ignore" (Windows Explorer)

Add a context menu entry so you can right-click any folder and zip it directly:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\add_zip_with_ignore_context.ps1
```

Then restart Explorer if the menu entry doesn't show up right away:

```powershell
Stop-Process -Name explorer -Force; Start-Process explorer.exe
```

## Ignoring files

By default, `node_modules` and `bin` are always skipped. To ignore more, drop a `.ignore` file in the folder you're zipping — one pattern per line, `#` for comments. See [`.ignore.example`](./.ignore.example):

```
node_modules
bin
dist
*.log
```

## How it works

- **PowerShell version**: recursively copies everything except ignored names into a temp folder, compresses that with `Compress-Archive`, then cleans up.
- **Bash version**: builds an exclude list from `.ignore` and pipes it straight into `zip -x@`.
- **Context menu installer**: registers a `HKEY_CLASSES_ROOT\Directory\shell\ZipWithIgnore` entry that runs the PowerShell script against whatever folder you right-clicked.
