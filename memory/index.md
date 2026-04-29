# 项目记忆索引

<!-- SUMMARY
本文件是记忆系统的路标。Claude 启动时只读本文件（~150 行），
根据任务按需加载下方具体文件，不要预读全部记忆。
-->

## 文件清单

| 文件 | 何时读取 | 何时写入 |
|------|---------|---------|
| `requirements.md` | 用户提新需求 / 讨论功能范围 | 需求变更、功能增删 |
| `decisions.md` | 用户问"为什么" / 做技术选型 | 确定技术方案、架构决策 |
| `gotchas.md` | 调试 bug / 修改敏感模块前 | 遇到非显而易见的坑 |
| `conventions.md` | 写新代码 / 用户纠正风格时 | 用户明确指出项目约定 |
| `glossary.md` | 遇到陌生术语 | 用户使用项目特定名词 |

## 快速索引（按模块）

<!-- 示例，按项目实际情况填写，使用完整锚点格式
- 认证鉴权 → decisions.md#2026-01-15-选择-jwt-认证方案, gotchas.md#2026-02-03-中间件顺序导致认证失败
- 数据库访问 → conventions.md#2026-01-20-统一使用-repository-模式, gotchas.md#2026-03-10-rocksdb-并发写入死锁
- API 设计 → decisions.md#2026-01-18-restful-api-设计规范, conventions.md#2026-01-25-路由命名约定
-->

## 标签索引

<!-- 倒排索引，写入新记忆时同步更新
- `#auth` → decisions.md, gotchas.md
- `#storage` → decisions.md, conventions.md
-->

## 最近热点

<!-- 最近写入的 10 条记忆，按写入顺序倒序排列
格式：- YYYY-MM-DD 标题 → 文件名
写入新记忆时自动更新此列表，超过 10 条则移除最旧的
-->

## 归档规则

- 单个记忆文件超过 500 行时，归档最旧的 100 行到 `archive/<year>/<filename>`
  - 示例：`decisions.md` 超限时 → `archive/2026/decisions.md`
- 标记为 `[DEPRECATED]` 的条目（标题或状态字段包含此标记）在文件超限时优先归档
- 读取时默认不加载 `archive/`，除非用户明确要求
