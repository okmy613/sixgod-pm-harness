#!/bin/bash
# mark-review-needed.sh
# 代码文件被编辑或创建后，自动标记为"需要 review"

set -e

echo "📝 标记代码变更待审查..."

REVIEW_MARKER=".claude/feedback/.review-needed"
FEEDBACK_DIR=".claude/feedback"

# 确保 feedback 目录存在
mkdir -p "$FEEDBACK_DIR"

# 获取本次变更的文件列表（未提交的变更）
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null || echo "")
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")

# 合并并去重
ALL_CHANGES=$(echo -e "$CHANGED_FILES\n$STAGED_FILES" | sort -u | grep -v '^$')

if [ -z "$ALL_CHANGES" ]; then
    echo "ℹ️ 没有检测到代码变更"
    exit 0
fi

# 过滤出代码文件（排除文档、配置等非代码文件）
CODE_FILES=$(echo "$ALL_CHANGES" | grep -E '\.(ts|tsx|js|jsx|py|rs|go|java|kt|swift|c|cpp|h|hpp|cs|rb|php)$' || true)

if [ -z "$CODE_FILES" ]; then
    echo "ℹ️ 变更文件不包含代码文件"
    exit 0
fi

# 写入标记文件
echo "$CODE_FILES" > "$REVIEW_MARKER"

echo "✅ 已标记以下文件待审查："
echo "$CODE_FILES"

# 同时记录到 review log
REVIEW_LOG="$FEEDBACK_DIR/review-log.md"
echo -e "\n## $(date '+%Y-%m-%d %H:%M:%S')" >> "$REVIEW_LOG"
echo "$CODE_FILES" >> "$REVIEW_LOG"

echo "✅ Review 标记完成"
