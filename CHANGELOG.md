# Changelog

All notable changes to Sharp Skills will be documented in this file.

---

## [1.0.0] — 2026-06-22

### Added

- **sharp-tech-writing** — 技术文档品控：主动语态铁律、示例优先、禁用虚词、段落长度上限
- **sharp-dataviz** — 数据可视化品控：图表类型决策树、色彩语义三原则、标题结论前置、反误导检查、中国红涨绿跌
- **sharp-copywriting** — 营销文案品控：禁用虚词黑名单、数字绑定、场景优先、信任信号等级
- **sharp-presentation** — 演示文稿品控：金字塔原理、每页一核心信息、叙事三段式、字体层级、反文字墙
- **sharp-api-design** — API 设计品控：命名一致性、错误响应标准、版本策略、幂等性、分页规范
- **sharp-interview** — 面试设计品控：岗位-题型矩阵、评分锚点、追问策略、反算法题偏见

### Platform Support

- WorkBuddy（SKILL.md + rules.md）
- Claude Code（CLAUDE.md 自动加载）
- Cursor（.cursorrules 自动加载）
- Codex CLI / GitHub Copilot / Windsurf / Aider（通用安装方式）

### Tooling

- Custom CLI: `npx sharp-skills add / list / remove / info`
- Zero-dependency install scripts: `install.sh` + `install.ps1`
- `skills.json` manifest for `npx skills add` compatibility
- ClawHub publish workflow (`.github/workflows/publish.yml`)
- npm package: `sharp-skills`
