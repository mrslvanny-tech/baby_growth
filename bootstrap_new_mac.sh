#!/usr/bin/env bash
set -euo pipefail

echo "== 小芽成长新电脑启动脚本 =="

if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew。请先安装 Homebrew: https://brew.sh/"
  exit 1
fi

brew list xcodegen >/dev/null 2>&1 || brew install xcodegen

if [ ! -d "/Applications/Xcode.app" ]; then
  echo "未检测到 /Applications/Xcode.app。"
  echo "请先安装完整 Xcode。macOS 15.x 建议 Xcode 16.4；macOS 26.2+ 可安装 App Store 最新 Xcode。"
else
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
fi

xcodegen generate

echo "工程已生成：XiaoyaGrowth.xcodeproj"
echo "下一步：open XiaoyaGrowth.xcodeproj"
