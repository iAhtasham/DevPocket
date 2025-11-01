# freeport

Frees up a TCP port on Windows by finding whatever process is listening on it and killing it.

Handy when you're restarting a dev server and the old process is still hanging around holding the port open.

## Usage

```powershell
.\freeport.ps1 -Port 3000
# or with the alias
.\freeport.ps1 -f 3000
```

Or via the `.cmd` wrapper (so you can call it as `freeport 3000` from `cmd.exe` too):

```cmd
freeport.cmd 3000
```

## How it works

1. Runs `netstat -ano` and looks for a `LISTENING` entry on the given port.
2. Extracts the owning PID.
3. Runs `taskkill /PID <pid> /F` to kill it.

If nothing is listening on the port, it just tells you the port is already free.

## Add it to your PATH

Drop this folder somewhere permanent and add it to your `PATH`, then you can run `freeport 3000` from anywhere.
