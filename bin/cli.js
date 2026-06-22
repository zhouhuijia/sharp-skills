#!/usr/bin/env node

/**
 * Sharp Collection — 跨平台 AI Agent 品控规则安装 CLI
 *
 * Usage:
 *   npx sharp-skills                              # Interactive mode
 *   npx sharp-skills add                          # Install all 6 skills
 *   npx sharp-skills add --skill sharp-tech-writing  # Install specific skill
 *   npx sharp-skills add --platform claude        # Target specific platform
 *   npx sharp-skills add --skill sharp-tech-writing --platform claude,cursor
 *   npx sharp-skills list                         # List available skills
 *   npx sharp-skills remove                       # Remove all installed skills
 *   npx sharp-skills remove --skill sharp-tech-writing
 *   npx sharp-skills info                         # Show installation status
 *
 * Compatible with: Claude Code, Cursor, Codex, GitHub Copilot, Windsurf, Aider, WorkBuddy
 *
 * Also compatible with `npx skills add` from vercel-labs/agent-skills:
 *   npx skills add https://github.com/zhouhuijia/sharp-skills
 *   npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const os = require('os');
const readline = require('readline');

// ── Config ────────────────────────────────────────────────────────

const REPO_RAW = 'https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main';

const SKILLS = {
  'sharp-tech-writing': {
    name: 'sharp-tech-writing',
    display: '技术文档品味',
    desc: 'README、API 文档、开发指南 — 主动语态铁律、示例优先、反废话',
    installName: 'sharp-tech-writing',
  },
  'sharp-dataviz': {
    name: 'sharp-dataviz',
    display: '数据可视化品味',
    desc: '图表、统计图 — 图表选择决策树、色彩语义、标题结论前置、中国红涨绿跌',
    installName: 'sharp-dataviz',
  },
  'sharp-copywriting': {
    name: 'sharp-copywriting',
    display: '营销文案品味',
    desc: '产品描述、广告语 — 禁用虚词、数字铁律、用户场景驱动',
    installName: 'sharp-copywriting',
  },
  'sharp-api-design': {
    name: 'sharp-api-design',
    display: 'API 设计品味',
    desc: 'REST API、接口规范 — 命名一致性、错误响应标准、分页分拣',
    installName: 'sharp-api-design',
  },
  'sharp-interview': {
    name: 'sharp-interview',
    display: '面试设计品味',
    desc: '面试题、技术评估 — 岗位-题型矩阵、评分锚点、追问策略',
    installName: 'sharp-interview',
  },
  'sharp-presentation': {
    name: 'sharp-presentation',
    display: '演示文稿品味',
    desc: 'PPT、汇报材料 — 金字塔原理、每页一核心、反文字墙',
    installName: 'sharp-presentation',
  },
};

const PLATFORMS = {
  claude: {
    name: 'Claude Code',
    dir: '.claude/rules',
    fileExt: '.md',
    singleFile: null,
    desc: '复制 rules.md 到 .claude/rules/ 目录',
  },
  cursor: {
    name: 'Cursor',
    dir: '.cursor/rules',
    fileExt: '.md',
    singleFile: '.cursorrules',
    desc: '复制 rules.md 到 .cursor/rules/ 目录',
  },
  codex: {
    name: 'Codex (OpenAI)',
    dir: '.codex/rules',
    fileExt: '.md',
    singleFile: null,
    desc: '复制 rules.md 到 .codex/rules/ 目录',
  },
  copilot: {
    name: 'GitHub Copilot',
    dir: '.github',
    fileExt: null,
    singleFile: 'copilot-instructions.md',
    desc: '追加到 .github/copilot-instructions.md',
  },
  windsurf: {
    name: 'Windsurf',
    dir: '.windsurf/rules',
    fileExt: '.md',
    singleFile: null,
    desc: '复制 rules.md 到 .windsurf/rules/ 目录',
  },
  aider: {
    name: 'Aider',
    dir: '.aider/rules',
    fileExt: '.md',
    singleFile: null,
    desc: '复制 rules.md 到 .aider/rules/ 目录',
  },
  workbuddy: {
    name: 'WorkBuddy',
    dir: '.workbuddy/skills',
    fileExt: null,
    singleFile: null,
    subdir: true,
    desc: '复制 SKILL.md 到 .workbuddy/skills/sharp-{skill}/ 目录',
  },
};

// ── Helpers ───────────────────────────────────────────────────────

function bold(s) {
  return `\x1b[1m${s}\x1b[22m`;
}

function dim(s) {
  return `\x1b[2m${s}\x1b[22m`;
}

function green(s) {
  return `\x1b[32m${s}\x1b[39m`;
}

function yellow(s) {
  return `\x1b[33m${s}\x1b[39m`;
}

function red(s) {
  return `\x1b[31m${s}\x1b[39m`;
}

function cyan(s) {
  return `\x1b[36m${s}\x1b[39m`;
}

function header(text) {
  console.log(`\n  ${bold(cyan('◆'))} ${bold(text)}`);
}

function step(text) {
  console.log(`  ${dim('→')} ${text}`);
}

function ok(text) {
  console.log(`  ${green('✓')} ${text}`);
}

function warn(text) {
  console.log(`  ${yellow('!')} ${text}`);
}

function err(text) {
  console.log(`  ${red('✗')} ${text}`);
}

function httpGet(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, { headers: { 'User-Agent': 'sharp-skills-cli' } }, (res) => {
        if (res.statusCode === 301 || res.statusCode === 302) {
          return httpGet(res.headers.location).then(resolve).catch(reject);
        }
        if (res.statusCode !== 200) {
          return reject(new Error(`HTTP ${res.statusCode} for ${url}`));
        }
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => resolve(data));
      })
      .on('error', reject);
  });
}

function detectPlatform() {
  const cwd = process.cwd();
  const detected = [];

  if (fs.existsSync(path.join(cwd, '.claude'))) detected.push('claude');
  if (fs.existsSync(path.join(cwd, '.cursor')) || fs.existsSync(path.join(cwd, '.cursorrules')))
    detected.push('cursor');
  if (fs.existsSync(path.join(cwd, '.codex'))) detected.push('codex');
  if (fs.existsSync(path.join(cwd, '.github'))) detected.push('copilot');
  if (fs.existsSync(path.join(cwd, '.windsurf'))) detected.push('windsurf');
  if (fs.existsSync(path.join(cwd, '.aider'))) detected.push('aider');
  if (
    fs.existsSync(path.join(os.homedir(), '.workbuddy')) ||
    fs.existsSync(path.join(cwd, '.workbuddy'))
  )
    detected.push('workbuddy');

  return detected;
}

function ensureDir(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

// ── Actions ───────────────────────────────────────────────────────

async function listSkills() {
  header('Available Skills (6)');
  console.log('');
  for (const [key, skill] of Object.entries(SKILLS)) {
    console.log(`  ${bold(skill.name)}`);
    console.log(`    ${dim(skill.desc)}`);
    console.log(`    install: ${dim(`--skill ${skill.installName}`)}`);
    console.log('');
  }
}

function listPlatforms() {
  header('Supported Platforms (7)');
  console.log('');
  for (const [key, plat] of Object.entries(PLATFORMS)) {
    console.log(`  ${bold(plat.name)}  ${dim(`--platform ${key}`)}`);
    console.log(`    ${dim(plat.desc)}`);
    console.log('');
  }
}

async function fetchSkillContent(skillName, forWorkbuddy = false) {
  const baseUrl = REPO_RAW;
  if (forWorkbuddy) {
    return httpGet(`${baseUrl}/skills/${skillName}/SKILL.md`);
  }
  // Try rules.md first (platform-agnostic), fallback to SKILL.md stripped
  try {
    return await httpGet(`${baseUrl}/skills/${skillName}/rules.md`);
  } catch {
    const skillMd = await httpGet(`${baseUrl}/skills/${skillName}/SKILL.md`);
    // Strip YAML frontmatter
    if (skillMd.startsWith('---')) {
      const parts = skillMd.split('---', 3);
      return parts.length >= 3 ? parts[2].trimStart() : skillMd;
    }
    return skillMd;
  }
}

async function installSkill(skillName, platforms) {
  for (const platKey of platforms) {
    const plat = PLATFORMS[platKey];
    if (!plat) {
      err(`Unknown platform: ${platKey}`);
      continue;
    }

    const cwd = process.cwd();
    const isWorkbuddy = platKey === 'workbuddy';
    let targetDir = path.join(cwd, plat.dir);
    
    // WorkBuddy skills go in home dir
    if (isWorkbuddy) {
      targetDir = path.join(os.homedir(), '.workbuddy/skills', skillName);
    }

    const content = await fetchSkillContent(skillName, isWorkbuddy);

    if (isWorkbuddy && plat.subdir) {
      // WorkBuddy: create skill subdirectory with SKILL.md
      ensureDir(targetDir);
      const filePath = path.join(targetDir, 'SKILL.md');
      fs.writeFileSync(filePath, content, 'utf-8');
      ok(`${skillName} → ${plat.name}  ${dim(filePath)}`);
    } else if (plat.singleFile) {
      // Single-file platforms (Copilot)
      const filePath = path.join(cwd, plat.dir, plat.singleFile);
      ensureDir(path.join(cwd, plat.dir));
      const header = `\n\n## ${skillName}\n\n`;
      if (fs.existsSync(filePath)) {
        fs.appendFileSync(filePath, header + content, 'utf-8');
      } else {
        fs.writeFileSync(filePath, content, 'utf-8');
      }
      ok(`${skillName} → ${plat.name}  ${dim(filePath)}`);
    } else {
      // Multi-file platforms (Claude, Cursor, Codex, Windsurf, Aider)
      ensureDir(targetDir);
      const fileName = `${skillName}${plat.fileExt || '.md'}`;
      const filePath = path.join(targetDir, fileName);
      fs.writeFileSync(filePath, content, 'utf-8');
      ok(`${skillName} → ${plat.name}  ${dim(filePath)}`);
    }
  }
}

async function installAll(platforms) {
  header(`Installing all 6 skills for: ${platforms.map((p) => PLATFORMS[p]?.name || p).join(', ')}`);
  for (const skillName of Object.keys(SKILLS)) {
    step(`Installing ${skillName}...`);
    await installSkill(skillName, platforms);
  }
  console.log('');
  ok(bold('All 6 skills installed!'));
}

async function installSpecific(skillNames, platforms) {
  header(
    `Installing: ${skillNames.join(', ')} for ${platforms.map((p) => PLATFORMS[p]?.name || p).join(', ')}`
  );
  for (const name of skillNames) {
    if (!SKILLS[name]) {
      err(`Unknown skill: ${name}`);
      console.log(`  Use ${cyan('npx sharp-skills list')} to see available skills.`);
      continue;
    }
    step(`Installing ${name}...`);
    await installSkill(name, platforms);
  }
  console.log('');
  ok(bold('Done!'));
}

function removeSkill(skillName, platforms) {
  for (const platKey of platforms) {
    const plat = PLATFORMS[platKey];
    if (!plat) continue;

    const cwd = process.cwd();
    const isWorkbuddy = platKey === 'workbuddy';
    let targetDir = path.join(cwd, plat.dir);

    if (isWorkbuddy) {
      targetDir = path.join(os.homedir(), '.workbuddy/skills', skillName);
      if (fs.existsSync(targetDir)) {
        fs.rmSync(targetDir, { recursive: true, force: true });
        ok(`Removed ${skillName} from ${plat.name}`);
      }
    } else if (plat.singleFile) {
      const filePath = path.join(cwd, plat.dir, plat.singleFile);
      if (fs.existsSync(filePath)) {
        const content = fs.readFileSync(filePath, 'utf-8');
        const escaped = skillName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        const regex = new RegExp(`\\n?## ${escaped}\\n\\n[\\s\\S]*?(?=\\n## |$)`, 'g');
        const cleaned = content.replace(regex, '').trimEnd();
        fs.writeFileSync(filePath, cleaned || '', 'utf-8');
        ok(`Removed ${skillName} from ${plat.name}`);
      }
    } else {
      const fileName = `${skillName}${plat.fileExt || '.md'}`;
      const filePath = path.join(targetDir, fileName);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        ok(`Removed ${skillName} from ${plat.name}  ${dim(filePath)}`);
      }
    }
  }
}

function removeAll(platforms) {
  header(`Removing all skills from: ${platforms.map((p) => PLATFORMS[p]?.name || p).join(', ')}`);
  for (const skillName of Object.keys(SKILLS)) {
    step(`Removing ${skillName}...`);
    removeSkill(skillName, platforms);
  }
  console.log('');
  ok(bold('All skills removed.'));
}

async function showInfo() {
  const detected = detectPlatform();
  header('Sharp Collection Info');
  console.log('');
  console.log(`  ${bold('Working dir:')}  ${process.cwd()}`);
  console.log(`  ${bold('Home dir:')}     ${os.homedir()}`);
  console.log(`  ${bold('Detected:')}    ${detected.length > 0 ? detected.map((p) => PLATFORMS[p].name).join(', ') : dim('none')}`);
  console.log('');

  // Check each platform for installed skills
  for (const platKey of Object.keys(PLATFORMS)) {
    const plat = PLATFORMS[platKey];
    const cwd = process.cwd();
    const isWorkbuddy = platKey === 'workbuddy';
    const installed = [];

    for (const skillName of Object.keys(SKILLS)) {
      let checkPath;
      if (isWorkbuddy) {
        checkPath = path.join(os.homedir(), '.workbuddy/skills', skillName, 'SKILL.md');
      } else if (plat.singleFile) {
        checkPath = path.join(cwd, plat.dir, plat.singleFile);
        if (fs.existsSync(checkPath)) {
          const content = fs.readFileSync(checkPath, 'utf-8');
          if (content.includes(skillName)) installed.push(skillName);
        }
        continue;
      } else {
        checkPath = path.join(cwd, plat.dir, `${skillName}${plat.fileExt || '.md'}`);
      }
      if (fs.existsSync(checkPath)) installed.push(skillName);
    }

    if (installed.length > 0) {
      console.log(`  ${bold(plat.name)}: ${green(installed.length + '/6 installed')}`);
      console.log(`    ${dim(installed.join(', '))}`);
    } else {
      console.log(`  ${bold(plat.name)}: ${dim('not installed')}`);
    }
  }
  console.log('');
}

// ── Interactive ───────────────────────────────────────────────────

async function interactiveMode() {
  console.log(`
  ${bold(cyan('◆ Sharp Collection'))}  ${dim('v1.0.0')}
  ${dim('AI Agent 品控规则 — 6 个模块，7 个平台')}
  `);

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  const question = (q) => new Promise((resolve) => rl.question(q, resolve));

  // List skills
  console.log(`  ${bold('Available skills:')}`);
  for (const [key, skill] of Object.entries(SKILLS)) {
    console.log(`    ${bold(skill.name)}  ${dim('—')}  ${dim(skill.desc)}`);
  }

  // Choose skills
  console.log('');
  const skillAnswer = await question(
    `  ${cyan('?')} Install which? ${dim('[all / skill names comma-separated]')} `
  );
  let skillNames;
  if (!skillAnswer.trim() || skillAnswer.trim().toLowerCase() === 'all') {
    skillNames = Object.keys(SKILLS);
  } else {
    skillNames = skillAnswer
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
    const invalid = skillNames.filter((s) => !SKILLS[s]);
    if (invalid.length > 0) {
      err(`Unknown skills: ${invalid.join(', ')}`);
      rl.close();
      return;
    }
  }

  // Choose platform
  const detected = detectPlatform();
  let platformHint = '';
  if (detected.length > 0) {
    platformHint = dim(` [detected: ${detected.join(', ')}]`);
  }

  console.log(`\n  ${bold('Supported platforms:')}`);
  for (const [key, plat] of Object.entries(PLATFORMS)) {
    console.log(`    ${bold(key)}  ${dim('—')}  ${plat.name}`);
  }
  const platAnswer = await question(
    `\n  ${cyan('?')} Target platform?${platformHint} ${dim('[default: claude,cursor]')} `
  );

  let platforms;
  if (!platAnswer.trim()) {
    platforms = detected.length > 0 ? detected : ['claude', 'cursor'];
  } else {
    platforms = platAnswer
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
    const invalid = platforms.filter((p) => !PLATFORMS[p]);
    if (invalid.length > 0) {
      err(`Unknown platforms: ${invalid.join(', ')}`);
      rl.close();
      return;
    }
  }

  rl.close();

  // Confirm
  console.log('');
  console.log(`  ${bold('Summary:')}`);
  console.log(`    Skills:    ${skillNames.join(', ')}`);
  console.log(`    Platforms: ${platforms.map((p) => PLATFORMS[p].name).join(', ')}`);

  // Install
  if (skillNames.length === Object.keys(SKILLS).length) {
    await installAll(platforms);
  } else {
    await installSpecific(skillNames, platforms);
  }
}

// ── CLI ────────────────────────────────────────────────────────────

function parseArgs() {
  const args = process.argv.slice(2);
  const result = {
    command: null,
    skills: [],
    platforms: [],
    help: false,
    version: false,
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--help' || arg === '-h') {
      result.help = true;
    } else if (arg === '--version' || arg === '-v') {
      result.version = true;
    } else if (arg === '--skill') {
      if (args[i + 1]) {
        result.skills = args[i + 1].split(',').map((s) => s.trim());
        i++;
      }
    } else if (arg === '--platform' || arg === '-p') {
      if (args[i + 1]) {
        result.platforms = args[i + 1].split(',').map((s) => s.trim());
        i++;
      }
    } else if (
      ['add', 'install', 'list', 'ls', 'remove', 'rm', 'uninstall', 'info', 'status'].includes(arg)
    ) {
      result.command = arg;
    }
  }

  // Normalize commands
  if (result.command === 'install') result.command = 'add';
  if (result.command === 'ls') result.command = 'list';
  if (result.command === 'uninstall' || result.command === 'rm') result.command = 'remove';
  if (result.command === 'status') result.command = 'info';

  return result;
}

function printHelp() {
  console.log(`
  ${bold(cyan('Sharp Collection'))}  ${dim('— AI Agent 品控规则安装工具')}

  ${bold('Usage:')}
    npx sharp-skills                      ${dim('Interactive mode (recommended)')}
    npx sharp-skills add                  ${dim('Install all 6 skills')}
    npx sharp-skills add --skill <name>   ${dim('Install specific skill')}
    npx sharp-skills add -p <platform>    ${dim('Target specific platform')}
    npx sharp-skills list                 ${dim('List available skills')}
    npx sharp-skills remove               ${dim('Remove all installed skills')}
    npx sharp-skills remove --skill <n>   ${dim('Remove specific skill')}
    npx sharp-skills info                 ${dim('Show installation status')}

  ${bold('Examples:')}
    ${dim('# Install all skills for Claude Code & Cursor')}
    npx sharp-skills add -p claude,cursor

    ${dim('# Install one skill for all detected platforms')}
    npx sharp-skills add --skill sharp-tech-writing

    ${dim('# Install specific skills for Codex')}
    npx sharp-skills add --skill sharp-tech-writing,sharp-api-design -p codex

    ${dim('# Also works with npx skills add (skills.sh compatible):')}
    npx skills add https://github.com/zhouhuijia/sharp-skills
    npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"

  ${bold('Platforms:')}
    claude    ${dim('Claude Code (.claude/rules/)')}
    cursor    ${dim('Cursor (.cursor/rules/)')}
    codex     ${dim('Codex / OpenAI (.codex/rules/)')}
    copilot   ${dim('GitHub Copilot (.github/copilot-instructions.md)')}
    windsurf  ${dim('Windsurf (.windsurf/rules/)')}
    aider     ${dim('Aider (.aider/rules/)')}
    workbuddy ${dim('WorkBuddy (~/.workbuddy/skills/)')}

  ${bold('Skills:')}
    sharp-tech-writing   ${dim('技术文档品味')}
    sharp-dataviz        ${dim('数据可视化品味')}
    sharp-copywriting    ${dim('营销文案品味')}
    sharp-api-design     ${dim('API 设计品味')}
    sharp-interview      ${dim('面试设计品味')}
    sharp-presentation   ${dim('演示文稿品味')}
`);
}

async function main() {
  const opts = parseArgs();

  if (opts.help) {
    printHelp();
    return;
  }

  if (opts.version) {
    console.log('sharp-skills v1.0.0');
    return;
  }

  // No command → interactive
  if (!opts.command) {
    await interactiveMode();
    return;
  }

  // Resolve platforms
  let platforms = opts.platforms;
  if (platforms.length === 0 && ['add', 'remove'].includes(opts.command)) {
    const detected = detectPlatform();
    platforms = detected.length > 0 ? detected : ['claude', 'cursor'];
  }

  // Validate platforms
  const invalid = platforms.filter((p) => !PLATFORMS[p]);
  if (invalid.length > 0) {
    err(`Unknown platforms: ${invalid.join(', ')}`);
    console.log(`  Use ${cyan('--help')} to see supported platforms.`);
    process.exit(1);
  }

  switch (opts.command) {
    case 'list':
      listSkills();
      break;

    case 'add':
      if (opts.skills.length > 0) {
        // Validate skills
        const bad = opts.skills.filter((s) => !SKILLS[s]);
        if (bad.length > 0) {
          err(`Unknown skills: ${bad.join(', ')}`);
          console.log(`  Use ${cyan('npx sharp-skills list')} to see available skills.`);
          process.exit(1);
        }
        await installSpecific(opts.skills, platforms);
      } else {
        await installAll(platforms);
      }
      break;

    case 'remove':
      if (opts.skills.length > 0) {
        header(`Removing: ${opts.skills.join(', ')}`);
        for (const name of opts.skills) {
          step(`Removing ${name}...`);
          removeSkill(name, platforms);
        }
        ok(bold('Done!'));
      } else {
        removeAll(platforms);
      }
      break;

    case 'info':
      await showInfo();
      break;

    default:
      err(`Unknown command: ${opts.command}`);
      console.log(`  Use ${cyan('--help')} to see available commands.`);
      process.exit(1);
  }
}

main().catch((e) => {
  err(e.message);
  process.exit(1);
});
