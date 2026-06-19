# NetSpeed

> macOS 菜单栏实时网速显示工具 · 纯 Swift · 零依赖

![swift](https://img.shields.io/badge/Swift-6.0+-orange) ![macos](https://img.shields.io/badge/macOS-13.0+-blue) ![license](https://img.shields.io/badge/license-MIT-green)

## ✨ 效果

菜单栏右上角显示实时网络速度：

```
↓ 12.5K  ↑ 3.2K
```

- **↓** 下载速度
- **↑** 上传速度
- 自动切换单位 B / K / M
- 每秒刷新

## 📦 安装

### 编译运行

```bash
git clone https://github.com/dujianwei521-boop/netspeed.git
cd netspeed
swiftc -o NetSpeed NetSpeed.swift
nohup ./NetSpeed > /dev/null 2>&1 &
```

### 开机自启

```bash
cp com.netspeed.menubar.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.netspeed.menubar.plist
```

## 🛑 退出

点击菜单栏图标 → 选择「退出」

## 🔧 技术

- 使用 `getifaddrs()` 系统调用读取网络接口字节统计
- `NSStatusBar` 原生菜单栏集成
- 单文件，编译后仅 ~200KB
- 内存占用 < 5MB

## 📄 License

MIT
