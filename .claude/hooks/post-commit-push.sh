#!/bin/bash
# post-commit-push.sh
# PostToolUse 钩子：在 git commit 成功后执行
# 功能：自动推送到远程仓库

set -e

echo "🚀 检查是否需要自动推送..."

# 检查当前分支是否有远程跟踪分支
if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    echo "ℹ️ 当前分支没有远程跟踪分支，跳过自动推送"
    exit 0
fi

# 检查是否有未推送的提交
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ 本地与远程同步，无需推送"
    exit 0
fi

echo "🚀 自动推送到远程仓库..."
git push

if [ $? -eq 0 ]; then
    echo "✅ 推送成功"
else
    echo "❌ 推送失败，请手动处理"
    exit 1
fi
