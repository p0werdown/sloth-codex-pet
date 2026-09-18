# 树懒 Codex 宠物包

这是可迁移到其他电脑的 sloth v2 宠物包。安装后，在 ChatGPT/Codex 桌面应用的 `Settings > Pets` 中刷新并选择“懒懒”。

## 自动安装

### macOS / Linux

1. 解压本包。
2. macOS 可双击 `install.command`；也可以在终端进入解压目录后运行：

   ```sh
   ./install.command
   ```

3. 打开桌面应用的 `Settings > Pets`，选择 `Refresh`，再选择“懒懒”。

如果脚本没有执行权限，可先运行 `chmod +x install.command`。

### Windows

1. 解压本包。
2. 在解压目录中打开 PowerShell，运行：

   ```powershell
   powershell -File .\install.ps1
   ```

3. 打开桌面应用的 `Settings > Pets`，选择 `Refresh`，再选择“懒懒”。

## 手动安装

把本包中的整个 `sloth` 文件夹复制到宠物目录：

- macOS / Linux：`$CODEX_HOME/pets/sloth`；未设置 `CODEX_HOME` 时为 `~/.codex/pets/sloth`
- Windows：`%CODEX_HOME%\pets\sloth`；未设置 `CODEX_HOME` 时为 `%USERPROFILE%\.codex\pets\sloth`

请保留 `sloth/pet.json` 和 `sloth/spritesheet.png` 的文件名与相对位置。

## 覆盖与备份

自动安装脚本发现已有 `sloth` 时，不会直接删除旧版本，而会把它改名为同目录下带时间戳的 `sloth.backup-...` 后再安装。

## 校验

`SHA256SUMS` 列出了两个宠物文件的 SHA-256。安装脚本会在系统支持时自动核对；Windows 脚本总会核对。

本包的图集规格为 v2、1536×2288、8 列×11 行、单格 192×208。完整结构复验结果见 `QA.md`。

官方说明：[Pets | ChatGPT Learn](https://learn.chatgpt.com/docs/pets)。自定义宠物保存在本机，不会自动同步到其他电脑，所以需要在每台电脑上安装本包。

## 协议

本项目采用 [MIT License](LICENSE)。
