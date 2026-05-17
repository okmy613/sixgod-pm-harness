#!/bin/bash
# pre-commit-check.sh
# 每次 commit 前自动跑编译检查
# 编译不过，直接阻止提交

set -e

echo "🔍 运行 pre-commit 编译检查..."

# 检测项目类型并执行对应编译命令
if [ -f "package.json" ]; then
    # Node.js 项目
    if [ -f "pnpm-lock.yaml" ]; then
        pnpm build
    elif [ -f "yarn.lock" ]; then
        yarn build
    else
        npm run build
    fi
elif [ -f "Cargo.toml" ]; then
    # Rust 项目
    cargo build
elif [ -f "go.mod" ]; then
    # Go 项目
    go build ./...
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    # Python 项目（语法检查）
    python -m compileall .
else
    echo "⚠️ 未检测到已知项目类型，跳过编译检查"
    exit 0
fi

if [ $? -eq 0 ]; then
    echo "✅ 编译检查通过"
    exit 0
else
    echo "❌ 编译失败，阻止提交"
    echo "请修复编译错误后再提交"
    exit 1
fi
