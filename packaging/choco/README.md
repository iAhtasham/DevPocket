# Chocolatey packaging

This folder holds the [Chocolatey](https://chocolatey.org/) package for DevPocket.

- `devpocket.nuspec` — package metadata.
- `tools/` — the payload: standalone `freeport.exe`, `adbshot.exe`, and `zipper.exe` (compiled from the scripts in this repo with [ps2exe](https://www.powershellgallery.com/packages/ps2exe)), plus the install script and verification notes. Chocolatey automatically creates PATH shims for every `.exe` in `tools/`, so installing the package puts `freeport`, `adbshot`, and `zipper` on your PATH — no extra install logic needed.

## Build the package

```powershell
choco pack devpocket.nuspec
```

This produces `devpocket.1.0.0.nupkg`.

## Test it locally

From an elevated (Run as Administrator) PowerShell:

```powershell
choco install devpocket -s "." -y
freeport -Port 3000
adbshot
zipper -TargetDir C:\some\folder
```

## Publish to the community repository

Publishing puts the package on [community.chocolatey.org](https://community.chocolatey.org/packages) for anyone to `choco install devpocket` — a public, one-way action tied to your own Chocolatey.org account, so it isn't done automatically as part of this repo's release process. To publish:

1. Create a [chocolatey.org](https://chocolatey.org/) account and grab your API key from your profile.
2. Register it once: `choco apikey --key <your-key> --source https://push.chocolatey.org/`
3. Push: `choco push devpocket.1.0.0.nupkg --source https://push.chocolatey.org/`
4. The package goes through Chocolatey's automated + moderator review before it's listed publicly.

## Bumping a version

1. Rebuild the exes and drop them into `tools/`.
2. Bump `<version>` in `devpocket.nuspec`.
3. `choco pack` and `choco push` again.
