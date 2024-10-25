# 🌟️星空键道输入方案

配方：℞ jiandao ([在线试用](https://my-rime.vercel.app/?plum=amorphobia/rime-jiandao@release:jiandao))

🌟️星空键道：自由的顶功输入方案

原作者：吅吅大山，官方仓库（[GitHub](https://github.com/xkinput/Rime_JD)，[Gitee](https://gitee.com/xkinput/Rime_JD)）

## 动机

旨在提供一份配置有优化、文件去冗余的键道配方仓库。初期词库将和官方一致，之后会根据需要[修改](#与官方方案不同之处)。

## 安装

多种方式可以使用，前两种可用补丁形式对 cizu 进行修改，后三种方式无法对 cizu 词典进行非覆盖式的修改，请自行选择，注意有可能需要手动在 `default.custom.yaml` 里添加本方案 (jiandao)。

### 1. 使用 Github Actions 自动生成方案文件

Fork 本仓库后，可以把需要添加、删除、修改权重的词语按需要的格式放到 `dicts` 目录下的 `cizu_append.txt`, `cizu_delete.txt`, 和 `cizu_modify.txt` 文件中，当推送到 Github 的时候，可以自动生成方案文件，生成的文件可以在 Actions 里面找到。

### 2. 克隆并在本地生成词库

> Windows 用户请使用 WSL 运行

克隆仓库后，执行以下命令（详情请看[词典生成脚本说明](scripts/README.md)）

```bash
scrips/make_dicts.sh --append <cizu_append.txt> --delete <cizu_delete.txt> --modify <cizu_modify.txt> [--deweight]
```

需要修改为你自己的对应文件名，也可省略选项。生成的方案在 `schema` 目录中。

### 3. 不同平台的安装脚本 / 快捷指令

#### My RIME 网页版

可直接访问[链接](https://my-rime.vercel.app/?plum=amorphobia/rime-jiandao@release:jiandao)，等待部署完成即可试用。

#### 小狼毫：PowerShell 小工具（内含于批处理脚本中）

**方式一** 在发布页面（[GitHub](https://github.com/amorphobia/rime-jiandao/releases)，[Gitee](https://gitee.com/amorphobia/rime-jiandao/releases)）下载 `weasel-installer.bat` 到本地，双击运行。

**方式二** 在 PowerShell 中执行以下命令，然后按照提示安装即可。

```PowerShell
irm 0xa.nl/get-jd-win | iex
```

#### 小小输入法

> [!NOTE]
> 本仓库不会主动打包小小输入法的主程序，请在小小输入法的[官方网站](http://yong.dgod.net/download/)或者[官方网盘](http://yongim.ysepan.com/)下载

在发布页面（[GitHub](https://github.com/amorphobia/rime-jiandao/releases)，[Gitee](https://gitee.com/amorphobia/rime-jiandao/releases)）下载最新版的 `jiandao-xiaoxiao-<version>.zip`，将压缩包全部内容解压到输入法目录下的 `.yong` 里，注意文件夹名字由英文半角句点开头，若无此文件夹请新建。

如果遇到错误，运行一次 `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` 再试。

#### 仓输入法：快捷指令

<a href="https://www.icloud.com/shortcuts/d0bf2707206342af998bf17d84eba232" style="display: inline-block; overflow: hidden; width: 250px; height: 87px;"><img src="img/shortcut.png" alt="获取快捷指令" style="width: 250px; height: 87px; overflow: hidden; display: inline-block; vertical-align: middle;"></a>

在 iOS / iPadOS 上点击即可下载快捷指令，或者在其他设备上从这里（[GitHub](https://github.com/amorphobia/rime-jiandao/raw/master/scripts/shortcut/%E9%94%AE%E9%81%93%E5%AE%89%E8%A3%85.shortcut), [Gitee](https://gitee.com/amorphobia/rime-jiandao/raw/master/scripts/shortcut/%E9%94%AE%E9%81%93%E5%AE%89%E8%A3%85.shortcut)）下载，并分享给 iOS / iPadOS 并打开。

> 可[点此查看](https://html-preview.github.io/?url=https://github.com/amorphobia/rime-jiandao/blob/master/scripts/shortcut/%E9%94%AE%E9%81%93%E5%AE%89%E8%A3%85.html)快捷指令“源代码”的网页视图，使用 [Shortcut Source Tool](https://routinehub.co/shortcut/5256/) 生成；若已经在使用 Shortcut Source Tool，也可以用它导入 JSON 格式的“源代码”（[GitHub](https://github.com/amorphobia/rime-jiandao/raw/master/scripts/shortcut/%E9%94%AE%E9%81%93%E5%AE%89%E8%A3%85.json), [Gitee](https://gitee.com/amorphobia/rime-jiandao/raw/master/scripts/shortcut/%E9%94%AE%E9%81%93%E5%AE%89%E8%A3%85.json)）。

### 4. 下载 Zip 包

请在发布页面（[GitHub](https://github.com/amorphobia/rime-jiandao/releases)，[Gitee](https://gitee.com/amorphobia/rime-jiandao/releases)）下载打包好的方案，解压文件到对应的目录。

### 5. 东风破

```bash
bash rime-install amorphobia/rime-jiandao@release
```

## 与官方方案不同之处

### 配置的不同

- 微调了开关菜单，不再提供关闭630全码词的开关（取而代之的是在构建词库时把630全码词权重降低）
- 关闭了自动上屏，默认使用顶功上屏
- 次选使用分号键，单引号用作三选
- 一些开关的快捷键修改
- 将 lua 脚本统一放入 `jiandao` 子目录，避免冲突
- 提供了一个统一码翻译器（Unicode Translator），可以通过 `uu` 引导统一码来输入
- 简繁转换使用中国大陆标准（[opencc-tonggui](https://github.com/amorphobia/opencc-tonggui)）

### 词典的不同

详见[词典说明](dicts/README.md)

## 开源许可

原有的内容无开源许可声明，遵循[《中华人民共和国著作权法》](http://www.npc.gov.cn/npc/c30834/202011/848e73f58d4e4c5b82f69d25d46048c6.shtml)

本仓库新增内容使用 [AGPL-3.0](LICENSE) 许可
