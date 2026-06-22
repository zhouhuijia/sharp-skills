# Sharp Skills

> AI 输出不烂，只是太「糊弄」。Sharp 系列把每个领域的品控标准编码成可执行的规则，让 AI 的输出真正可交付。

## 这是什么

Sharp Skills 是一组 AI Agent 品控规则，每个模块针对一个 AI 输出质量最差的领域，内置专家级规则、反模式清单和检查流程。

**支持平台：** WorkBuddy · Claude Code · Cursor · Codex (OpenAI) · GitHub Copilot · Windsurf · Aider

灵感来自 [taste-skill](https://github.com/nextlevelbuilder/taste-skill)，但 sharp 不只是「品味」——更强调**精度、克制、可交付**。

## 六个模块

| 模块 | 触发场景 | 解决什么 |
|---|---|---|
| **sharp-tech-writing** | README、API 文档、开发指南 | 空话连篇、被动语态泛滥、缺真实示例 |
| **sharp-dataviz** | 图表、数据可视化、统计图 | 误导性图表、颜色乱用、标题无结论 |
| **sharp-copywriting** | 营销文案、产品描述、广告语 | 虚词轰炸、零具体信息、场景感缺失 |
| **sharp-api-design** | REST API、接口设计、错误规范 | 命名不一致、错误码混乱、分页方案混搭 |
| **sharp-interview** | 面试题设计、技术评估、招聘 | 纯 LeetCode 原题、缺评分标准、无追问策略 |
| **sharp-presentation** | PPT、演示文稿、汇报材料 | 文字墙、无叙事线、图表标注看不清 |

## 快速安装

### 方式一：npx skills add（推荐，兼容 skills.sh）

```bash
# 安装全部 6 个 skill
npx skills add https://github.com/zhouhuijia/sharp-skills

# 按需安装单个 skill
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-dataviz"
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-copywriting"
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-api-design"
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-interview"
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-presentation"
```

兼容 [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) 的 `skills` CLI，自动识别 `skills/` 目录结构。

### 方式二：npx sharp-skills（自带 CLI）

```bash
# 交互式安装（推荐新手）
npx sharp-skills

# 安装全部 6 个 skill（自动检测平台）
npx sharp-skills add

# 指定目标平台
npx sharp-skills add --platform claude,cursor

# 安装单个 skill
npx sharp-skills add --skill sharp-tech-writing

# 同时指定 skill 和平台
npx sharp-skills add --skill sharp-tech-writing,sharp-api-design --platform claude

# 查看已安装状态
npx sharp-skills info

# 列出可用 skill
npx sharp-skills list

# 卸载
npx sharp-skills remove
npx sharp-skills remove --skill sharp-tech-writing
```

### 方式三：一行脚本安装

```bash
# macOS / Linux / Git Bash
curl -fsSL https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main/install.sh | bash

# 安装指定 skill
curl -fsSL https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main/install.sh | bash -s -- --skill sharp-tech-writing

# 指定平台
bash install.sh --platform claude,cursor --skill sharp-tech-writing
```

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main/install.ps1' -OutFile install.ps1; .\install.ps1"

# 安装指定 skill
.\install.ps1 -Skill sharp-tech-writing -Platform claude,cursor
```

### 方式四：单文件复制

将 `SHARP.md` 复制或重命名为你所用平台的入口文件：

```bash
# Claude Code — 放项目根目录自动加载
cp SHARP.md CLAUDE.md

# Cursor
cp SHARP.md .cursorrules

# Windsurf
cp SHARP.md .windsurfrules

# GitHub Copilot
cp SHARP.md .github/copilot-instructions.md

# Aider
cp SHARP.md CONVENTIONS.md
```

### 方式五：按模块手动复制

```bash
# Claude Code — 按模块加载
cp skills/sharp-tech-writing/rules.md .claude/rules/sharp-tech-writing.md
cp skills/sharp-api-design/rules.md .claude/rules/sharp-api-design.md

# Cursor — 按模块加载
cp skills/sharp-tech-writing/rules.md .cursor/rules/sharp-tech-writing.md

# WorkBuddy — 安装为 Skill
cp -r skills/sharp-tech-writing ~/.workbuddy/skills/
cp -r skills/sharp-dataviz ~/.workbuddy/skills/
```

### 方式六：Git Submodule

```bash
git submodule add https://github.com/zhouhuijia/sharp-skills.git .sharp
```

然后在 `CLAUDE.md` 或 `.cursorrules` 中引用：
```
Always follow the rules in .sharp/SHARP.md when generating output.
```

## CLI 命令速查

```
npx sharp-skills                       交互式安装（推荐）
npx sharp-skills add                   安装全部 6 个 skill
npx sharp-skills add --skill <name>    安装指定 skill
npx sharp-skills add --platform <p>    指定目标平台
npx sharp-skills list                  列出全部 skill
npx sharp-skills info                  查看安装状态
npx sharp-skills remove                卸载全部
npx sharp-skills remove --skill <n>    卸载指定 skill
npx sharp-skills --help                帮助信息
```

## 平台自动检测

CLI 和脚本会自动检测当前项目使用的平台：

| 检测条件 | 平台 |
|---|---|
| `.claude/` 目录存在 | Claude Code |
| `.cursor/` 或 `.cursorrules` 存在 | Cursor |
| `.codex/` 目录存在 | Codex (OpenAI) |
| `.github/` 目录存在 | GitHub Copilot |
| `.windsurf/` 目录存在 | Windsurf |
| `.aider/` 目录存在 | Aider |
| `.workbuddy/` 或 `~/.workbuddy/` 存在 | WorkBuddy |

未检测到时默认安装到 `claude,cursor`。

## 文件说明

```
sharp-skills/
├── SHARP.md                  ← 单文件聚合版，跨平台通用
├── CLAUDE.md                 ← Claude Code 自动加载版本
├── .cursorrules              ← Cursor 自动加载版本
├── README.md
├── package.json              ← npm 包配置（支持 npx）
├── skills.json               ← skills.sh 兼容清单
├── install.sh                ← Shell 安装脚本（零依赖）
├── install.ps1               ← PowerShell 安装脚本（零依赖）
├── bin/
│   └── cli.js                ← Node.js CLI 入口
└── skills/
    ├── sharp-tech-writing/
    │   ├── SKILL.md          ← WorkBuddy 格式（含 frontmatter）
    │   └── rules.md          ← 纯规则，无 frontmatter，多平台通用
    ├── sharp-dataviz/
    ├── sharp-copywriting/
    ├── sharp-api-design/
    ├── sharp-interview/
    └── sharp-presentation/
```

## 设计哲学

1. **规则要可执行，不要讲道理。** "要写好文档"不是规则。"每段不超过 4 句话"才是。
2. **反模式清单比最佳实践更重要。** AI 最需要的是知道什么不该做。
3. **分级触发，不滥用。** 只在相关场景激活，不给无关任务添乱。
4. **检查清单是底线。** 每条规则都通往一个可勾选的 checklist item。

## 与 taste-skill 的关系

taste-skill 专注前端视觉设计（落地页、排版、动效、配色）。Sharp 覆盖其余六个领域。两者互补，可以同时使用。

```bash
# 同时安装 taste-skill 和 sharp-skills
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"
```

## 贡献

欢迎提 issue 和 PR。新增模块请遵循现有格式：
- `SKILL.md`：含 YAML frontmatter（WorkBuddy 格式）
- `rules.md`：纯规则内容（多平台通用）
- 同步更新 `SHARP.md`、`CLAUDE.md`、`skills.json`

## License

MIT
