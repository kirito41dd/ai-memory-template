#!/usr/bin/env nu

# 仅替换唯一、成对且独占行的托管块；块外文本逐字保留。
# 未标记的旧版规则需要人工确认边界，不能猜测应删除哪些项目指令。
def update-entry [content: string, snippet: string]: nothing -> string {
    let start = '<!-- ai-memory:start -->'
    let end = '<!-- ai-memory:end -->'
    let starts = ($content | split row $start)
    let ends = ($content | split row $end)
    let newline = if ($content | str contains "\r\n") { "\r\n" } else { "\n" }
    let block = ($snippet | str replace --all "\r\n" "\n" | str trim --right | str replace --all "\n" $newline)

    if ($starts | length) == 1 and ($ends | length) == 1 {
        # 旧安装用 cat >> 追加，标题可能粘连前文或 BOM，不能要求位于行首。
        if $content =~ '(?m)#{1,6}[\t ]+项目记忆机制[\t ]*\r?$' {
            error make {msg: '发现未标记的旧版项目记忆机制。请将该段替换为 CLAUDE.md.snippet，保留其他指令后重试。'}
        }
        let separator = if ($content | is-empty) {
            ''
        } else if ($content | str ends-with ($newline + $newline)) {
            ''
        } else if ($content | str ends-with $newline) {
            $newline
        } else {
            $newline + $newline
        }
        return ($content + $separator + $block + $newline)
    }

    if ($starts | length) != 2 or ($ends | length) != 2 {
        error make {msg: '入口标记缺失或重复；请保留一组成对的 ai-memory:start / ai-memory:end 后重试。'}
    }
    let after_start = ($starts.1 | split row $end)
    if ($after_start | length) != 2 {
        error make {msg: '入口结束标记位于开始标记之前，请修正顺序后重试。'}
    }
    let prefix = $starts.0
    let body = $after_start.0
    let suffix = $after_start.1
    let start_on_line = (($prefix | is-empty) or ($prefix | str ends-with "\n"))
    let body_on_lines = (
        (($body | str starts-with "\n") or ($body | str starts-with "\r\n"))
        and ($body | str ends-with "\n")
    )
    let end_on_line = (
        ($suffix | is-empty) or ($suffix | str starts-with "\n") or ($suffix | str starts-with "\r\n")
    )
    if not ($start_on_line and $body_on_lines and $end_on_line) {
        error make {msg: '入口标记必须各自独占一行；未修改项目文件。'}
    }
    $prefix + $block + $suffix
}

# 初始化项目记忆；已有模板文件不覆盖，所选入口仅更新托管块。
def main [
    project: path
    --agent-file: string = 'CLAUDE.md' # 可选 CLAUDE.md 或 AGENTS.md
] {
    if $agent_file not-in ['CLAUDE.md' 'AGENTS.md'] {
        error make {msg: '--agent-file 仅支持 CLAUDE.md 或 AGENTS.md。'}
    }
    let project_root = ($project | path expand)
    if ($project_root | path type) != 'dir' {
        error make {msg: '目标项目必须是已存在的目录。'}
    }
    const template_root = path self ..
    let entry_path = ([$project_root $agent_file] | path join)
    let entry_type = ($entry_path | path type)
    if $entry_type != null and $entry_type != 'file' {
        error make {msg: $'入口必须是普通文件，不能是目录或符号链接：($entry_path)'}
    }
    let content = if $entry_type == 'file' { open --raw $entry_path } else { '' }
    let snippet = (open --raw ([$template_root 'CLAUDE.md.snippet'] | path join))
    let updated = (update-entry $content $snippet)
    let memory_root = ([$project_root '.ai' 'memory'] | path join)
    let files = [
        'index.md' 'policy.md' 'requirements.md' 'decisions.md'
        'gotchas.md' 'conventions.md' 'glossary.md' 'archive/README.md'
    ]

    # 先检查所有路径和入口格式，再开始写入，避免可预知的错误留下半套配置。
    for relative in ['.ai' '.ai/memory' '.ai/memory/archive'] {
        let directory = ([$project_root $relative] | path join)
        let kind = ($directory | path type)
        if $kind != null and $kind != 'dir' {
            error make {msg: $'记忆目录路径已被其他对象占用：($directory)'}
        }
    }
    for relative in $files {
        let source = ([$template_root 'memory' $relative] | path join)
        let target = ([$memory_root $relative] | path join)
        if ($source | path type) != 'file' {
            error make {msg: $'模板文件缺失或不是普通文件：($source)'}
        }
        let kind = ($target | path type)
        if $kind != null and $kind != 'file' {
            error make {msg: $'记忆文件路径已被其他对象占用：($target)'}
        }
    }

    mkdir ([$memory_root 'archive'] | path join)
    for relative in $files {
        let source = ([$template_root 'memory' $relative] | path join)
        let target = ([$memory_root $relative] | path join)
        if not ($target | path exists --no-symlink) {
            cp --no-clobber $source $target
        }
    }
    if $updated != $content {
        $updated | save --raw --force $entry_path
    }
    print $'已初始化 ($memory_root)；已有记忆文件已保留，入口：($agent_file)。'
}
