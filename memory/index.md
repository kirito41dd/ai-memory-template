# 项目记忆索引

<!-- SUMMARY
本文件是记忆系统的路标。Claude 启动时只读本文件（~80 行），
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

<!-- 示例，按项目实际情况填写
- 认证鉴权 → decisions.md#auth, gotchas.md#middleware-order
- 数据库访问 → conventions.md#db-access, gotchas.md#rocksdb
- API 设计 → decisions.md#api-design, conventions.md#routing
-->

## 标签索引

<!-- 倒排索引，写入新记忆时同步更新
- `#auth` → decisions.md, gotchas.md
- `#storage` → decisions.md, conventions.md
-->

## 最近热点

<!-- 最近 7 天写入/更新的记忆，方便快速定位
- YYYY-MM-DD 标题 → 文件名
-->

## 归档规则

- 单个记忆文件超过 500 行时，归档最旧条目到 `archive/<year>/`
- 超过 6 个月未被引用的条目自动归档
- 读取时默认不加载 `archive/`，除非用户明确要求
