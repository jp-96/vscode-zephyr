# vscode-zephyr
python development environment template that combines VSCode and Docker.

https://docs.zephyrproject.org/latest/develop/tools/vscode.html

```bash
west config build.dir-fmt "builds/{board}"
cd ~/dev/zephyrproject
west build -p auto -b bbc_microbit
west build -p auto -b bbc_microbit_v2
```
