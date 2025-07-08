# vscode-zephyr
python development environment template that combines VSCode and Docker.

https://docs.zephyrproject.org/latest/develop/tools/vscode.html

```bash
west config build.dir-fmt "builds/{board}"
cd ~/dev/zephyrproject
west build -p auto -b bbc_microbit
west build -p auto -b bbc_microbit_v2
```

## usb

https://qiita.com/as-hasegawa/items/790cc503a3296ded8b73

https://learn.microsoft.com/ja-jp/windows/wsl/connect-usb

**コマンドプロンプト（管理者）**

1. 管理者権限でコマンドプロンプトを開く
2. `usbipd list` でmicro:bitの `BUSID` を確認する
3. `usbipd bind --busid <BUSID>` でバインドする(Shared)

一度バインドすれば、記憶される

```bash
Microsoft Windows [Version 10.0.26100.4484]
(c) Microsoft Corporation. All rights reserved.

C:\Windows\System32>usbipd list
Connected:
BUSID  VID:PID    DEVICE                                                        STATE
1-2    0d28:0204  USB 大容量記憶装置, USB シリアル デバイス (COM3), USB 入 ...  Not shared
1-6    04f2:b71a  HD Webcam, IR Camera                                          Not shared
1-10   8087:0026  インテル(R) ワイヤレス Bluetooth(R)                           Not shared
3-1    0bda:0316  USB 大容量記憶装置                                            Not shared

Persisted:
GUID                                  DEVICE


C:\Windows\System32>usbipd bind --busid 1-2

C:\Windows\System32>usbipd list
Connected:
BUSID  VID:PID    DEVICE                                                        STATE
1-2    0d28:0204  USB 大容量記憶装置, USB シリアル デバイス (COM3), USB 入 ...  Shared
1-6    04f2:b71a  HD Webcam, IR Camera                                          Not shared
1-10   8087:0026  インテル(R) ワイヤレス Bluetooth(R)                           Not shared
3-1    0bda:0316  USB 大容量記憶装置                                            Not shared

Persisted:
GUID                                  DEVICE


C:\Windows\System32>
```

**コマンドプロンプト（通常）**

1. コマンドプロンプトを開く
2. `usbipd attach --wsl --busid <BUSID>` で、アタッチする
3. Docker 側で、usbを使う
4. 使い終わったら、物理的にUSBを抜くか、 `usbipd detach --busid <BUSID>` で、デタッチする

```bash
Microsoft Windows [Version 10.0.26100.4484]
(c) Microsoft Corporation. All rights reserved.

C:\Users\dev>usbipd attach --wsl --busid 1-2
usbipd: info: Using WSL distribution 'docker-desktop' to attach; the device will be available in all WSL 2 distributions.
usbipd: info: Loading vhci_hcd module.
usbipd: info: Detected networking mode 'nat'.
usbipd: info: Using IP address 172.25.176.1 to reach the host.
usbipd: info: Firewall check not possible with this distribution (no bash, or wrong version of bash).

C:\Users\dev>usbipd list
Connected:
BUSID  VID:PID    DEVICE                                                        STATE
1-2    0d28:0204  USB 大容量記憶装置, USB シリアル デバイス (COM3), USB 入 ...  Attached
1-6    04f2:b71a  HD Webcam, IR Camera                                          Not shared
1-10   8087:0026  インテル(R) ワイヤレス Bluetooth(R)                           Not shared
3-1    0bda:0316  USB 大容量記憶装置                                            Not shared

Persisted:
GUID                                  DEVICE


C:\Users\dev>usbipd detach --busid 1-2

C:\Users\dev>usbipd list
Connected:
BUSID  VID:PID    DEVICE                                                        STATE
1-2    0d28:0204  USB 大容量記憶装置, USB シリアル デバイス (COM3), USB 入 ...  Shared
1-6    04f2:b71a  HD Webcam, IR Camera                                          Not shared
1-10   8087:0026  インテル(R) ワイヤレス Bluetooth(R)                           Not shared
3-1    0bda:0316  USB 大容量記憶装置                                            Not shared

Persisted:
GUID                                  DEVICE


C:\Users\dev>
```

docker:

```bash
sudo apt install usbutils
sudo apt install usbip
```