# vscode-zephyr

This repository provides a **setup guide for developing micro:bit v1/v2 applications using Zephyr RTOS in a Windows + WSL2 + Docker environment**. Flashing and debugging via CMSIS-DAP is also supported through `usbipd-win`.

## 📦 Target Environment

| Component         | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| Boards            | `bbc_microbit` (v1), `bbc_microbit_v2` (v2)                                 |
| OS                | Windows 11 with WSL2                                                        |
| IDE               | Visual Studio Code                                                          |
| Container Runtime | Docker Desktop for Windows                                                  |
| USB Bridge        | [usbipd-win](https://github.com/dorssel/usbipd-win)                         |
| Debug Probe       | CMSIS-DAP (micro:bit built-in support)                                      |

---

## 🔧 Setup Instructions

Install the following tools on your Windows 11 system:

- Git  
- Docker Desktop for Windows  
- usbipd-win  
- Visual Studio Code  

Open this project in VS Code and connect to the container environment.

---

## ⚙️ Building the Sample Code

From VS Code, open the menu:  
**Terminal → Run Build Task...**  
Select `Generate micro:bit universal hex`.

This builds for both v1 and v2 boards, producing a single `microbit-universal.hex` file.

To flash the sample code, drag and drop this file onto the micro:bit drive using Windows File Explorer.

---

## 🐞 Flashing and Debugging via CMSIS-DAP

You can flash or debug directly from VS Code without manually generating a hex file.

### 🔗 Binding the USB Device

1. Connect the micro:bit via USB.  
2. Run Command Prompt as Administrator.  
3. List USB devices:
   ```bash
   usbipd list
   ```
4. Identify the micro:bit by its `VID:PID` value: `0d28:0204`.  
5. Bind the device using its BUSID:
   ```bash
   usbipd bind --busid <BUSID>
   ```

### 📎 Attaching the USB Device

After binding, the micro:bit must be attached each time it is reconnected via USB.

Run the included `microbit_attach.bat` on Windows to make the device accessible from the container via CMSIS-DAP.

---

### ⚡ Build and Flash

From VS Code:  
**Terminal → Run Build Task... → Build and Flash**

This will build the project and automatically flash it to the connected micro:bit via CMSIS-DAP.

---

### 🧪 Debugging

From VS Code:  
**Run and Debug (Ctrl + Shift + D) → (GDB) micro:bit**

You can set breakpoints and step through the code execution in the debugger.

---

Let me know if you'd like to include example output, add troubleshooting notes, or introduce task.json customization tips. I’ve got your back!




# vscode-zephyr

このリポジトリは、**Zephyr RTOSを使って micro:bit v1/v2 の開発を Windows + WSL2 + Docker 環境で行うためのセットアップガイド**です。CMSIS-DAP経由での書き込み／デバッグも usbipd-win を介して可能です。

## 📦 対象環境

| 項目                  | 内容                                       |
|-----------------------|--------------------------------------------|
| 対象ボード             | `bbc_microbit`（v1）, `bbc_microbit_v2`（v2） |
| OS                    | Windows 11 + WSL2               |
| IDE                   | Visual Studio Code                         |
| コンテナランタイム     | Docker Desktop for Windows                 |
| USBブリッジ           | [usbipd-win](https://github.com/dorssel/usbipd-win) |
| デバッグプローブ      | CMSIS-DAP（micro:bit標準対応）             |

---

## 🔧 セットアップ手順

次のツールをWindows11にインストールします。

- git
- docker desktop for windows
- usbipd-win
- vscode

vscodeで本プロジェクトを開き、コンテナーに接続します。

## サンプルコードのビルド

vscodeのメニュー Terminal > Run Build Task... で、`Generate micro:bit universal hex`を実行します。
v1/v2のビルドが行われ、`microbit-universal.hex`ファイルが生成されます。

この`microbit-universal.hex`ファイルをWindows上のエクスプローラーで、micro:bitドライブへ書き込むとmicro:bit本体でサンプルプログラムが実行されます。

## サンプルコードの書き込みとデバッグ

hexファイルを生成せずに、`CMSIS-DAP`によりVSCODE上で直接書き込んだり、デバッグしたりすることが可能です。

### USBデバイスのBIND

micro:bitをUSB接続し、Windowsのコマンドプロンプトを管理者として実行します。

接続されているUSBデバイスを一覧表示します。
```bash
usbipd list
```

`VID:PID`が`0d28:0204`であるmicro:bitの`BUSID`を確認し、次のコマンドで`BUSID`を指定してバインドします。
```bash
usbipd bind --busid <BUSID>
```

### USBデバイスのATTACH

Windows上で、本プロジェクトの`microbit_attach.bat`を実行し、micro:bitをアタッチします。
成功すると、コンテナ内から、`CMSIS-DAP`経由で、micro:bitへの接続が可能になります。

### ビルドと書き込み

vscodeのメニュー Terminal > Run Build Task... で、`Build and Flash`を実行します。
ビルド後、接続されているmicro:bitデバイスへ`CMSIS-DAP`経由で書き込みが行われます。

### デバッグ

vscodeの`Run and Debug (Ctrl + Shift + D)`で、`(GDB) micro:bit`を開始すると、サンプルコードをデバッグ実行できます。
ブレークポイントを設定しておけば、そこで実行を一時停止することが可能です。



## 🛠 Zephyr Development for micro:bit

- `Generate micro:bit universal hex`: Builds a HEX file compatible with both micro:bit v1 and v2  
- `Build and flash`: Compiles firmware and flashes it to the device  
- `(GDB) micro:bit`: Launches GDB debugger for firmware inspection and debugging

## 🔧 Setting Up usbipd-win for micro:bit Access via WSL2

**1. Install usbipd-win**  
- Open **PowerShell (Administrator)** and run:

```bash
winget install --id=Usbipd.UsbipdWin
```

**2. List Available USB Devices**  
- Open **Command Prompt (Administrator)** and run:

```bash
usbipd list
```

- Identify your micro:bit and note the `BUSID` (e.g., `1-1`, `3-2`)

**3. Bind the Device to WSL2**  
- Run:

```bash
usbipd bind --busid <BUSID>
```

- Replace `<BUSID>` with the actual value from step 2  
💡 Once bound, the device remains shared across WSL sessions

**4. Attach the Device in WSL**  
- Run `microbit_attach.bat`



---



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

**udev**

```bash
sudo apt install udev
```

https://github.com/pyocd/pyOCD/blob/main/udev/50-cmsis-dap.rules

```py
# 0d28:0204 DAPLink
SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
```

https://qiita.com/yagshi/items/0e1f31036c9ef430a99a

```py
KERNEL=="ttyACM[0-9]*",MODE="0666"
ATTRS{product}=="*CMSIS-DAP*", MODE="660", GROUP="plugdev", TAG+="uaccess"
```

https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules

```py

# AIR32F103
ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"


# CMSIS-DAP compatible adapters
ATTRS{product}=="*CMSIS-DAP*", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

```

```bash
sudo cp 99-microbit.rules /etc/udev/rules.d/

sudo udevadm control --reload
```

docker:

```bash
sudo apt install udev

sudo apt install usbutils
sudo apt install usbip

```


## デバッガー

https://blog.savoirfairelinux.com/en-ca/2025/easy-debugging-zephyr-with-vscode/
