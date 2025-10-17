#!/bin/bash

set -e  # 遇到错误时退出

#############################################
# tmux 配置
#############################################
echo "========================================="
echo "开始安装和配置 tmux"
echo "========================================="

# 检查是否已安装 tmux
if command -v tmux &> /dev/null; then
    echo "✓ tmux 已安装，版本: $(tmux -V)"
else
    echo "正在安装 tmux..."
    if sudo apt update && sudo apt install -y tmux; then
        echo "✓ tmux 安装成功"
    else
        echo "✗ tmux 安装失败，跳过配置"
        exit 1
    fi
fi

# 确认安装成功后进行配置
if command -v tmux &> /dev/null; then
    echo ""
    echo "开始配置 tmux..."

    # 创建 ~/.config 目录（如果不存在）
    mkdir -p ~/.config

    # 复制 tmux 配置文件
    if [ -f "dotfiles/home/wayne/.config/.tmux.conf" ]; then
        cp -f dotfiles/home/wayne/.config/.tmux.conf ~/.config/.tmux.conf
        echo "✓ 已复制 .tmux.conf 到 ~/.config/"
    else
        echo "✗ 找不到源配置文件: dotfiles/home/wayne/.config/.tmux.conf"
    fi

    # 复制 tmux 目录（包含 powerline 等插件）
    if [ -d "dotfiles/home/wayne/.config/tmux" ]; then
        cp -rf dotfiles/home/wayne/.config/tmux ~/.config/
        echo "✓ 已复制 tmux 目录到 ~/.config/"
    else
        echo "✗ 找不到源目录: dotfiles/home/wayne/.config/tmux"
    fi

    # 创建符号链接到 ~/.tmux.conf（兼容传统配置位置）
    if [ ! -f ~/.tmux.conf ]; then
        ln -sf ~/.config/.tmux.conf ~/.tmux.conf
        echo "✓ 已创建符号链接 ~/.tmux.conf -> ~/.config/.tmux.conf"
    else
        echo "! ~/.tmux.conf 已存在，跳过创建符号链接"
    fi

    echo ""
    echo "✓ tmux 配置完成！"

    # 安装 tmux 插件
    echo ""
    echo "开始安装 tmux 插件..."

    # 创建插件目录
    mkdir -p ~/.tmux/plugins

    # 安装 TPM (Tmux Plugin Manager)
    if [ -d ~/.tmux/plugins/tpm ]; then
        echo "! TPM 已存在，更新中..."
        cd ~/.tmux/plugins/tpm && git pull
        echo "✓ TPM 更新成功"
    else
        echo "正在克隆 TPM..."
        if git clone ${GITPROXY}https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; then
            echo "✓ TPM 安装成功"
        else
            echo "✗ TPM 安装失败"
        fi
    fi

    # 安装 rainbarf
    if [ -d ~/.tmux/plugins/rainbarf ]; then
        echo "! rainbarf 已存在，更新中..."
        cd ~/.tmux/plugins/rainbarf && git pull
        echo "✓ rainbarf 更新成功"
    else
        echo "正在克隆 rainbarf..."
        if git clone ${GITPROXY}https://github.com/creaktive/rainbarf ~/.tmux/plugins/rainbarf; then
            echo "✓ rainbarf 安装成功"
        else
            echo "✗ rainbarf 安装失败"
        fi
    fi

    # 返回原目录
    cd - > /dev/null

    echo ""
    echo "✓ tmux 插件安装完成！"
    echo ""
    echo "提示：启动 tmux 后，按 prefix + I 安装配置文件中的其他插件"
else
    echo "✗ tmux 未正确安装，配置失败"
    exit 1
fi

echo ""
echo "========================================="
echo "tmux 安装和配置完成"
echo "========================================="
