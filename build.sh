#!/usr/bin/env bash
# 使用 IntelliJ 自带的 jar 编译插件，无需 Maven/Gradle

set -e

IDEA_HOME="C:/Program Files/JetBrains/IntelliJ IDEA 2026.1.1"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$PROJECT_DIR/src/main/java"
OUT_DIR="$PROJECT_DIR/target/classes"
PLUGIN_JAR="$PROJECT_DIR/target/bnep-active-file-tracker.jar"

rm -rf "$PROJECT_DIR/target" 2>/dev/null
mkdir -p "$OUT_DIR" "$PROJECT_DIR/target"

echo "Compiling..."
javac -d "$OUT_DIR" \
  -cp "$IDEA_HOME/lib/*" \
  $(find "$SRC_DIR" -name "*.java")

echo "Packaging plugin jar..."
cd "$OUT_DIR" && jar cf "$PLUGIN_JAR" . && cd "$PROJECT_DIR"
cd "$PROJECT_DIR/src/main/resources" && jar uf "$PLUGIN_JAR" META-INF/plugin.xml && cd "$PROJECT_DIR"

echo ""
echo "Done! Plugin jar: $PLUGIN_JAR"
echo "To install: IntelliJ IDEA → Settings → Plugins → ⚙ → Install Plugin from Disk"
