# NetSpeed

> macOS 菜单栏实时网速显示工具 · 纯 Swift · 零依赖

![swift](https://img.shields.io/badge/Swift-6.0+-orange) ![macos](https://img.shields.io/badge/macOS-13.0+-blue) ![license](https://img.shields.io/badge/license-MIT-green)

## 📸 效果

<p align="center">
  <img src="https://raw.githubusercontent.com/dujianwei521-boop/netspeed/main/screenshot.png" alt="NetSpeed 菜单栏效果" width="460">
</p>

## 🚀 安装

```bash
git clone https://github.com/dujianwei521-boop/netspeed.git
cd netspeed
chmod +x install.sh && ./install.sh
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
