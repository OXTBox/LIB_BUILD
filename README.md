# LIB_BUILD

Collects every part of the **xt3d games bench** and the **Vibecode3D standalone** into one
folder you can carry to another Windows computer.

1. Open `collector.livecodescript` in LiveCode (an empty IDE is enough); press **Collect**; pick an
   empty folder. (Or from WSL: the LIB_MCP standalone, `Build.Collect "C:/LIB_DEMO"`.)
2. What it copies is `parts.txt` (source, destination). It **copies**, it doesn't move: the
   parts stay in their projects so the repos and tools keep working. Edit `parts.txt` to add parts.
3. The folder keeps the `projects/...` layout, because the games and benches find their
   libraries by searching the folders above themselves.
4. On the other computer: `README_FIRST.txt` in the demo folder (copy `xt3d\extension` to
   `C:\xt3d\extension`, then run the bench or Vibecode3D).

Tested 2026-11-13: 3,146 files, 311 MB into `C:\LIB_DEMO` (most of it LIB_MOCAP's library).
Not yet tested: running the collected copy on a second computer.

## Licence

GPL-3.0 (see `LICENSE`), because the xTalk work here is built on the GPL-licensed LiveCode Community 9 engine. Copyright (c) 2026 xAction.
