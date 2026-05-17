#!/bin/bash
# pre-tool-use-check.sh
# PreToolUse 钩子：在 Edit/Write 工具使用前执行
# 功能：标记文件变更待审查、自动安装 git pre-commit hook

set -e

echo "📝 PreToolUse 检查..."

# ============ 自动安装 git hooks ============
# 如果项目有 .git 目录但缺少 hook，自动从模板安装

# 安装 pre-commit hook（编译检查）
PRE_COMMIT_HOOK=".git/hooks/pre-commit"
PRE_COMMIT_SOURCE=".claude/hooks/pre-commit-check.sh"

if [ -d ".git" ] && [ ! -f "$PRE_COMMIT_HOOK" ] && [ -f "$PRE_COMMIT_SOURCE" ]; then
    echo "🔧 自动安装 git pre-commit hook..."
    cp "$PRE_COMMIT_SOURCE" "$PRE_COMMIT_HOOK"
    chmod +x "$PRE_COMMIT_HOOK"
    echo "✅ git pre-commit hook 已自动安装"
fi

# 安装 post-commit hook（自动推送）
POST_COMMIT_HOOK=".git/hooks/post-commit"
POST_COMMIT_SOURCE=".claude/hooks/post-commit-push.sh"

if [ -d ".git" ] && [ ! -f "$POST_COMMIT_HOOK" ] && [ -f "$POST_COMMIT_SOURCE" ]; then
    echo "🔧 自动安装 git post-commit hook..."
    cp "$POST_COMMIT_SOURCE" "$POST_COMMIT_HOOK"
    chmod +x "$POST_COMMIT_HOOK"
    echo "✅ git post-commit hook 已自动安装"
fi
# =====================================================

REVIEW_MARKER=".claude/feedback/.review-needed"
FEEDBACK_DIR=".claude/feedback"

# 确保 feedback 目录存在
mkdir -p "$FEEDBACK_DIR"

# 检查当前是否有未提交的代码变更
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null || echo "")
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")

# 合并并去重
ALL_CHANGES=$(echo -e "$CHANGED_FILES\n$STAGED_FILES" | sort -u | grep -v '^$')

if [ -z "$ALL_CHANGES" ]; then
    echo "✅ 没有待标记的代码变更"
    exit 0
fi

# 过滤出代码文件
CODE_FILES=$(echo "$ALL_CHANGES" | grep -E '\.(ts|tsx|js|jsx|py|rs|go|java|kt|swift|c|cpp|h|hpp|cs|rb|php|vue|svelte)$' || true)

if [ -z "$CODE_FILES" ]; then
    echo "ℹ️ 变更不包含代码文件"
    exit 0
fi

# 写入标记文件
echo "$CODE_FILES" > "$REVIEW_MARKER"

echo "✅ 已标记以下文件待审查："
echo "$CODE_FILES"

exit 0
