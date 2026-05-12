# ActiveFileTracker
> 此为自定义IDEA插件，完全由本地jar驱动

跟踪 IntelliJ IDEA 中当前打开的文件，实时写入 `~/.claude/active_file.txt`，供 Claude Code 读取。
可直接将此README.md丢给AI让其理解并引导安装配置

## 作用

在 Claude Code 自定义状态栏中显示当前打开的文件，状态栏样式示例：
> **如何自定义状态栏:** 直接将样式丢给CC即可，他可以根据样式自己写脚本来实现自定义状态栏的展示

```shell
# 使用API启动Claude时 推荐状态栏样式
# 上下文进度条 | 缓存命中率 | 当前对话token用量 | API地址及当日消耗费用 | 当前模型 | 项目名称 | 当前打开的文件
CTX ███░░░░░░░░░░░░░░░░░ 18% | 🎯 99.6% | 175k | $17.99 <api.deepseek.com> | Opus 4.7 | bnep-cloud | ⧉ CurrentFile.java

# 使用账号订阅启动时 推荐状态栏样式
# 上下文进度条 | 缓存命中率 | 当前对话token用量 | 订阅配额及套餐刷新时间 | 当前模型 | 项目名称 | 当前打开的文件
CTX ████████░░░░░░░░░░░░ 42% | ⚡100.0% | 6k | 10% ↻ 3h6m | Sonnet 4.6 | bnep-cloud | ⧉ CurrentFile.java
```

## 安装
先使用以下命令将代码打包为jar包
```bash
cd active-file-tracker-plugin
bash build.sh
```
然后在IDEA自定义插件中安装此jar包<br>
IDEA → Settings → Plugins → ⚙ → Install Plugin from Disk → 选择 `target/bnep-active-file-tracker.jar` → 重启

## Claude Code 状态栏配置

在 `~/.claude/settings.json` 中：

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0,
    "refreshInterval": 1
  }
}
```

`refreshInterval: 1` 使状态栏每秒刷新一次，切换文件后立即更新（纯本地操作，不消耗 tokens）。

## 原理

- 监听 `FileEditorManagerListener` 事件
- 编辑器切换文件时自动写入 `~/.claude/active_file.txt`
- 零 UI、零额外开销

## 构建

依赖 JDK，无需 Maven/Gradle。运行 `bash build.sh` 即可。
