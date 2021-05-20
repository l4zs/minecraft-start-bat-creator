# minecraft-start-bat-creator
This bat aims to create a start.bat while optionally installing the latest paper.jar and/or installing a new java 

*Although this is a start.bat creator, it is capable of creating a whole paper server (just choose to download the paper.jar)*

***Notice:*** If downloading doesn't work, try opening it as administrator, also make sure that your wifi connection isn't set as metered connection.

* * *

### [Download](https://github.com/l4zs/minecraft-start-bat-creator/archive/refs/heads/main.zip)

* * *

### Features:

- easily create a start.bat for your server
- download the latest paper.jar (*may require* the bat to be run as administrator)
- even download java if you don't have it installed / need a different version (*may require* the bat to be run as administrator)
  - set the downloaded java as JAVA_Home (***requires*** the bat to be run as administrator)

* * *

### How to use:

Recommended: **Run as Administrator** as the downloading will be much faster and some features don't work without admin perms like setting JAVA_HOME

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
