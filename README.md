# minecraft-start-bat-creator
This bat aims to create a start.bat while optionally installing the latest paper.jar and/or installing a new java 

> ℹ️ Although this is a start.bat creator, it is capable of creating a whole paper server (just choose to download the paper.jar)

> 🔴 Note: If downloading doesn't work, try opening it as administrator, also make sure that your wifi connection isn't set as metered connection.

* * *

<h3 align="center"> <a href="https://github.com/l4zs/minecraft-start-bat-creator/archive/refs/heads/main.zip">Download</a></h3>

* * *

### Features:

create a start.bat for your server, optionally use following features:

Feature | without Administrator | with Administrator
:-- | :-: | :-:
create start.bat | ✔️ | ✔️
search for specified java version | ✔️ | ✔️
set -Xms and -Xmx values | ✔️ | ✔️
use aikar flags | ✔️ | ✔️
automatically accept eula | ✔️ | ✔️
download paper.jar | 🟠 | ✔️
download java | 🟠 | ✔️
set JAVA_HOME | ❌ | ✔️

❌ - doesn't work
🟠 - can cause errors
✔️ - works

* * *

### How to use:

> 🟢 Recommended: **Run as Administrator** as the downloading (paper, jdk) will be much faster and some features don't work without admin perms like setting JAVA_HOME

1. Place this bat in a new folder
2. execute the bat and follow the instructions (if you want just one java version set min and max to the same value)
3. (edit the start.bat to add extra args if you want)
4. execute the start.bat and enjoy playing.

* * *

### Debugging Errors:

If the bat crashes randomly without any further message and you want to help fixing the error, do the following:
- open cmd
- Change the directory to the directory where the bat is located (`cd /path/to/bat`)
- Run the bat with the following command: `cmd.exe \K search-java-minecraft-start.bat`
- try to redo everything you did before it crashed
- instead of crashing you'll now receive an error message
- create an [issue](https://github.com/l4zs/minecraft-start-bat-creator/issues/new) and paste the error message there

* * *

### TODO:
- [ ] Language Selection (German, English)
- [ ] switch to paper api v2
- [ ] switch to dns redirects for jdk urls
