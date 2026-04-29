# 归档

超过 500 行的记忆文件，或 6 个月未被引用的条目，归档至本目录。

## 结构

```
archive/
├── 2025/
│   ├── decisions.md
│   ├── requirements.md
│   └── gotchas.md
└── 2026/
    └── ...
```

## 读取规则

Claude 默认不读取本目录，除非：
- 用户明确要求查询历史记忆
- 任务涉及历史决策回溯
- 在当前记忆中发现 `见 archive/YYYY/xxx.md` 引用
