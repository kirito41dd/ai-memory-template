# AI Memory Template

项目级 AI coding agent 长期记忆系统模板，采用渐进式披露（progressive disclosure）避免上下文膨胀。

## 使用方式

### 方式一：单项目初始化

```bash
# 从本模板复制到目标项目
cp -r ai-memory-template/memory /path/to/your-project/.ai/memory

# 将 CLAUDE.md.snippet 的内容追加到项目 CLAUDE.md
cat ai-memory-template/CLAUDE.md.snippet >> /path/to/your-project/CLAUDE.md
```

### 方式二：全局默认（推荐）

**步骤 1：安装模板**
```bash
# 复制模板到 Claude 配置目录（或你喜欢的位置）
mkdir -p ~/.claude/templates
cp -r ai-memory-template ~/.claude/templates/ai-memory
```

**步骤 2：配置全局规则**
将 `global-CLAUDE.md.snippet` 的内容追加到 `~/.claude/CLAUDE.md`：
```bash
cat ai-memory-template/global-CLAUDE.md.snippet >> ~/.claude/CLAUDE.md
```

**步骤 3：使用**
进入新项目时，让 Claude 执行初始化：
> "初始化本项目的 AI 记忆系统"

Claude 会询问模板位置（默认 `~/.claude/templates/ai-memory/memory/`），确认后复制到当前项目的 `.ai/memory/`。

**注意**：如果你将模板放在其他位置，初始化时告诉 Claude 实际路径即可。

## 设计原则

1. **渐进式披露**：启动时只读 `index.md`（~150 行），按需加载具体记忆
2. **硬性行数上限**：CLAUDE.md ≤ 100 行，index.md ≤ 150 行，单记忆文件 ≤ 500 行
3. **追加不删除**：过时记忆标记 `[DEPRECATED]`，超限归档到 `archive/`
4. **用户在回路**：写入前必须询问确认，不偷偷记忆

## 目录结构

```
memory/
├── index.md            # 路标（必读）
├── requirements.md     # 需求演进史
├── decisions.md        # 技术决策记录（ADR 风格）
├── gotchas.md          # 踩坑与注意事项
├── conventions.md      # 项目内约定
├── glossary.md         # 术语表
└── archive/            # 归档目录（默认不读）
```

## 文件清单

| 文件 | 用途 |
|------|------|
| `CLAUDE.md.snippet` | 单项目使用：追加到项目根的 CLAUDE.md 或 AGENTS.md |
| `global-CLAUDE.md.snippet` | 全局使用：追加到 ~/.claude/CLAUDE.md |
| `memory/*.md` | 记忆文件模板 |
