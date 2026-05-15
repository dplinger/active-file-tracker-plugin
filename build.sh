#!/usr/bin/env bash
# Build IntelliJ IDEA plugin jar
#
# Usage: edit IDEA_HOME below to point to your IDEA install, then run:
#   bash build.sh
set -e

# ---- CONFIG: 填入你的IDEA安装地址 ----
IDEA_HOME="D:/Java/IntelliJ IDEA 2026.1.1"
# ----------------------------------------------------------------

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$PROJECT_DIR/src/main/java"
OUT_DIR="$PROJECT_DIR/target/classes"
PLUGIN_JAR="$PROJECT_DIR/target/bnep-active-file-tracker.jar"

if [ ! -f "$IDEA_HOME/lib/app.jar" ]; then
    echo "错误: 在 $IDEA_HOME 未找到 IntelliJ IDEA" >&2
    echo "请修改 build.sh 中的 IDEA_HOME 变量，填入你的 IDEA 安装路径。" >&2
    exit 1
fi

echo "Using IDEA_HOME: $IDEA_HOME"

rm -rf "$PROJECT_DIR/target"
mkdir -p "$OUT_DIR"

echo "Compiling..."
javac -d "$OUT_DIR" \
    -cp "$IDEA_HOME/lib/*" \
    "$(find "$SRC_DIR" -name '*.java')"

echo "Packaging plugin jar..."
cd "$OUT_DIR" && jar cf "$PLUGIN_JAR" . && cd "$PROJECT_DIR"
cd "$PROJECT_DIR/src/main/resources" && jar uf "$PLUGIN_JAR" META-INF/plugin.xml && cd "$PROJECT_DIR"

echo ""
echo "Done! Plugin jar: $PLUGIN_JAR"
echo "To install: IntelliJ IDEA → Settings → Plugins → ⚙ → Install Plugin from Disk"
