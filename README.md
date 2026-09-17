# DevPocket

A growing collection of small, single-purpose dev tools — the kind of thing you write once, use daily, and never want to lose. Each tool lives in its own folder and does one job well.

## Tools

| Tool | Description |
|---|---|
| [`freeport`](./freeport) | Frees a TCP port by killing whatever process is listening on it. |
| [`adbshot`](./adbshot) | Captures a screenshot from a connected ADB (Android) device straight to the clipboard. |
| [`zipper`](./zipper) | Zips a folder while skipping junk like `node_modules`, `bin`, `dist` — with an optional right-click context menu entry. |

More tools will be added here over time as they come up.

## Installation

The easiest way to get all three tools on your `PATH` is via a package manager:

**Chocolatey**

```powershell
choco install devpocket
```

**winget**

```powershell
winget install iAhtasham.DevPocket
```

Either one installs `freeport`, `adbshot`, and `zipper` as standalone commands, no cloning required. See [`packaging/`](./packaging) for how these packages are built and published.

## Usage

Once installed, just run the commands directly:

```powershell
freeport -Port 3000
adbshot
zipper -TargetDir C:\some\folder
```

Or, running from source instead of a package manager, each tool is self-contained — see its own README for details. In general:

```powershell
cd <tool-name>
.\<tool-name>.ps1 [args]
```

Add the folder(s) you use to your `PATH` to run them from anywhere.

## Philosophy

- Small and focused — one tool, one job.
- No dependencies beyond what's already on a typical Windows dev machine (PowerShell, adb, etc.).
- Incremental — new tools get added as the need arises.

## License

MIT — see [LICENSE](./LICENSE).
