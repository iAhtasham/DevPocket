# winget packaging

This folder holds the [winget](https://learn.microsoft.com/windows/package-manager/winget/) manifest for DevPocket, ready to submit to the community [`winget-pkgs`](https://github.com/microsoft/winget-pkgs) repository.

- `manifests/i/iAhtasham/DevPocket/1.0.0/` — the three manifest files (version, installer, locale) winget-pkgs expects.
- The installer points at the `devpocket-1.0.0-win-x64.zip` asset on the [v1.0.0 release](https://github.com/iAhtasham/DevPocket/releases/tag/v1.0.0), which bundles standalone `freeport.exe`, `adbshot.exe`, and `zipper.exe` (compiled from the scripts in this repo with [ps2exe](https://www.powershellgallery.com/packages/ps2exe)) as a winget "portable" package.

## Publishing this to winget

Submitting a new package to winget means opening a pull request against Microsoft's `winget-pkgs` repo — a public, one-way action on someone else's repository, so it isn't done automatically as part of this repo's own release process. To publish:

1. Validate the manifest locally (requires the [Windows App SDK / winget-create tool](https://github.com/microsoft/winget-create) or the `winget validate` command):
   ```powershell
   winget validate --manifest "manifests/i/iAhtasham/DevPocket/1.0.0"
   ```
2. Fork [microsoft/winget-pkgs](https://github.com/microsoft/winget-pkgs) and copy the `manifests/i/iAhtasham/DevPocket/1.0.0/` folder into the same path in your fork.
3. Open a pull request. Their automated pipeline validates the installer URL/hash and a human moderator reviews it before it merges.

Once merged, anyone can run:

```powershell
winget install iAhtasham.DevPocket
```

## Bumping a version

1. Rebuild the exes (`Invoke-ps2exe` on each `.ps1`), zip them, and attach the zip to a new GitHub release.
2. Copy the `1.0.0` manifest folder to a new version folder, bump `PackageVersion`, and update `InstallerUrl` / `InstallerSha256`.
3. Repeat the PR process above.
