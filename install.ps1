# Sharp Collection — PowerShell 安装脚本
#
# 零依赖，Windows 原生安装。
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Skill sharp-tech-writing
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Platform claude,cursor
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Skill sharp-tech-writing -Platform claude
#   powershell -ExecutionPolicy Bypass -File install.ps1 -List
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Remove
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Remove -Skill sharp-tech-writing
#
# Also works with npx skills add (skills.sh compatible):
#   npx skills add https://github.com/zhouhuijia/sharp-skills
#   npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"

param(
  [string]$Skill = "",
  [string]$Platform = "",
  [switch]$List = $false,
  [switch]$Remove = $false,
  [switch]$Info = $false,
  [switch]$Help = $false
)

$ErrorActionPreference = "Stop"

# ── Config ───────────────────────────────────────────────────────

$REPO_RAW = "https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main"
$VERSION = "1.0.0"

$SKILLS = @(
  @{ Name = "sharp-tech-writing";  Display = "技术文档";    Desc = "README、API 文档、开发指南 — 主动语态铁律" },
  @{ Name = "sharp-dataviz";       Display = "数据可视化";  Desc = "图表、统计图 — 图表选择决策树、中国红涨绿跌" },
  @{ Name = "sharp-copywriting";   Display = "营销文案";    Desc = "产品描述、广告语 — 禁用虚词、数字铁律" },
  @{ Name = "sharp-api-design";    Display = "API 设计";    Desc = "REST API、接口规范 — 命名一致性、错误响应标准" },
  @{ Name = "sharp-interview";     Display = "面试设计";    Desc = "面试题、技术评估 — 岗位-题型矩阵、评分锚点" },
  @{ Name = "sharp-presentation";  Display = "演示文稿";    Desc = "PPT、汇报材料 — 金字塔原理、反文字墙" }
)

$PLATFORMS = @{
  "claude"    = @{ Name = "Claude Code";      Dir = ".claude/rules";      FileExt = ".md" }
  "cursor"    = @{ Name = "Cursor";           Dir = ".cursor/rules";      FileExt = ".md" }
  "codex"     = @{ Name = "Codex (OpenAI)";   Dir = ".codex/rules";       FileExt = ".md" }
  "copilot"   = @{ Name = "GitHub Copilot";   Dir = ".github";            SingleFile = "copilot-instructions.md" }
  "windsurf"  = @{ Name = "Windsurf";         Dir = ".windsurf/rules";    FileExt = ".md" }
  "aider"     = @{ Name = "Aider";            Dir = ".aider/rules";       FileExt = ".md" }
  "workbuddy" = @{ Name = "WorkBuddy";        Dir = "";                   Subdir = $true }
}

# ── Helpers ──────────────────────────────────────────────────────

function Write-Header($text) {
  Write-Host "`n  " -NoNewline
  Write-Host "◆" -ForegroundColor Cyan -NoNewline
  Write-Host " $text" -ForegroundColor White
}

function Write-Step($text) {
  Write-Host "  → $text" -ForegroundColor DarkGray
}

function Write-Ok($text) {
  Write-Host "  ✓ $text" -ForegroundColor Green
}

function Write-Warn($text) {
  Write-Host "  ! $text" -ForegroundColor Yellow
}

function Write-Err($text) {
  Write-Host "  ✗ $text" -ForegroundColor Red
}

function Detect-Platform {
  $detected = @()
  if (Test-Path ".claude")                   { $detected += "claude" }
  if ((Test-Path ".cursor") -or (Test-Path ".cursorrules")) { $detected += "cursor" }
  if (Test-Path ".codex")                    { $detected += "codex" }
  if (Test-Path ".github")                   { $detected += "copilot" }
  if (Test-Path ".windsurf")                 { $detected += "windsurf" }
  if (Test-Path ".aider")                    { $detected += "aider" }
  if ((Test-Path "$env:USERPROFILE\.workbuddy") -or (Test-Path ".workbuddy")) { $detected += "workbuddy" }
  return $detected -join ","
}

function Fetch-SkillContent($skillName) {
  # Try rules.md first, then SKILL.md with frontmatter stripping
  $url = "$REPO_RAW/skills/$skillName/rules.md"
  try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
    return $response.Content
  } catch {
    $url = "$REPO_RAW/skills/$skillName/SKILL.md"
    try {
      $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
      $content = $response.Content
      # Strip YAML frontmatter
      if ($content.StartsWith("---")) {
        $parts = $content -split "---", 3
        if ($parts.Count -ge 3) {
          return $parts[2].TrimStart("`n")
        }
      }
      return $content
    } catch {
      Write-Err "Failed to fetch: $skillName"
      return $null
    }
  }
}

function Install-SkillForPlatform($skillName, $platKey) {
  $plat = $PLATFORMS[$platKey]
  if (-not $plat) {
    Write-Err "Unknown platform: $platKey"
    return
  }

  if ($platKey -eq "workbuddy") {
    $skillDir = "$env:USERPROFILE\.workbuddy\skills\$skillName"
    New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
    $skillUrl = "$REPO_RAW/skills/$skillName/SKILL.md"
    try {
      $response = Invoke-WebRequest -Uri $skillUrl -UseBasicParsing -ErrorAction Stop
      Set-Content -Path "$skillDir\SKILL.md" -Value $response.Content -Encoding UTF8
      Write-Ok "$skillName → $($plat.Name)  $skillDir\SKILL.md"
    } catch {
      Write-Err "Failed to fetch SKILL.md for $skillName"
    }
  } elseif ($plat.ContainsKey("SingleFile")) {
    $dir = $plat.Dir
    $file = Join-Path $dir $plat.SingleFile
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $content = Fetch-SkillContent $skillName
    if ($content) {
      if (Test-Path $file) {
        Add-Content -Path $file -Value "`n`n## $skillName`n`n$content" -Encoding UTF8
      } else {
        Set-Content -Path $file -Value $content -Encoding UTF8
      }
      Write-Ok "$skillName → $($plat.Name)  $file"
    }
  } else {
    $dir = $plat.Dir
    $file = Join-Path $dir "$skillName$($plat.FileExt)"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $content = Fetch-SkillContent $skillName
    if ($content) {
      Set-Content -Path $file -Value $content -Encoding UTF8
      Write-Ok "$skillName → $($plat.Name)  $file"
    }
  }
}

function Remove-SkillForPlatform($skillName, $platKey) {
  $plat = $PLATFORMS[$platKey]
  if (-not $plat) { return }

  if ($platKey -eq "workbuddy") {
    $skillDir = "$env:USERPROFILE\.workbuddy\skills\$skillName"
    if (Test-Path $skillDir) {
      Remove-Item -Recurse -Force $skillDir
      Write-Ok "Removed $skillName from $($plat.Name)"
    }
  } elseif ($plat.ContainsKey("SingleFile")) {
    $file = Join-Path $plat.Dir $plat.SingleFile
    if (Test-Path $file) {
      $content = Get-Content -Path $file -Raw -Encoding UTF8
      $escaped = [regex]::Escape($skillName)
      $pattern = "(?ms)\n##\s*$escaped\s*\n.*?(?=\n##\s|\z)"
      $cleaned = [regex]::Replace($content, $pattern, "").TrimEnd()
      if ($cleaned) {
        Set-Content -Path $file -Value $cleaned -Encoding UTF8
      } else {
        Remove-Item -Force $file
      }
      Write-Ok "Removed $skillName from $($plat.Name)"
    }
  } else {
    $file = Join-Path $plat.Dir "$skillName$($plat.FileExt)"
    if (Test-Path $file) {
      Remove-Item -Force $file
      Write-Ok "Removed $skillName from $($plat.Name)  $file"
    }
  }
}

# ── Actions ──────────────────────────────────────────────────────

function List-Skills {
  Write-Header "Available Skills (6)"
  Write-Host ""
  foreach ($s in $SKILLS) {
    Write-Host "  $($s.Name)" -ForegroundColor White
    Write-Host "    $($s.Display) — $($s.Desc)" -ForegroundColor DarkGray
    Write-Host ""
  }
}

function Install-All($platformsStr) {
  $plats = $platformsStr -split ","
  $platNames = ($plats | ForEach-Object { $PLATFORMS[$_].Name }) -join ", "
  Write-Header "Installing all 6 skills for: $platNames"
  foreach ($s in $SKILLS) {
    Write-Step "Installing $($s.Name)..."
    foreach ($p in $plats) {
      Install-SkillForPlatform $s.Name $p
    }
  }
  Write-Host ""
  Write-Ok "All 6 skills installed!"
}

function Install-Specific($skillStr, $platformsStr) {
  $skills = $skillStr -split ","
  $plats = $platformsStr -split ","
  $platNames = ($plats | ForEach-Object { $PLATFORMS[$_].Name }) -join ", "
  Write-Header "Installing: $skillStr for $platNames"
  foreach ($sk in $skills) {
    Write-Step "Installing $sk..."
    foreach ($p in $plats) {
      Install-SkillForPlatform $sk $p
    }
  }
  Write-Host ""
  Write-Ok "Done!"
}

function Remove-All($platformsStr) {
  $plats = $platformsStr -split ","
  $platNames = ($plats | ForEach-Object { $PLATFORMS[$_].Name }) -join ", "
  Write-Header "Removing all skills from: $platNames"
  foreach ($s in $SKILLS) {
    Write-Step "Removing $($s.Name)..."
    foreach ($p in $plats) {
      Remove-SkillForPlatform $s.Name $p
    }
  }
  Write-Host ""
  Write-Ok "All skills removed."
}

function Show-Info {
  $detected = Detect-Platform
  Write-Header "Sharp Collection Info"
  Write-Host ""
  Write-Host "  Version:      $VERSION"
  Write-Host "  Working dir:  $(Get-Location)"
  Write-Host "  Home dir:     $env:USERPROFILE"
  if ($detected) {
    Write-Host "  Detected:     $detected"
  } else {
    Write-Host "  Detected:     none" -ForegroundColor DarkGray
  }
  Write-Host ""
}

function Print-Help {
  Write-Host @"

  Sharp Collection  — AI Agent 品控规则安装工具 (PowerShell)

  Usage:
    .\install.ps1                                   # Install all (auto-detect)
    .\install.ps1 -Skill <name>                     # Install specific skill
    .\install.ps1 -Platform <plat>                  # Target specific platform
    .\install.ps1 -Skill <n> -Platform <p>          # Both
    .\install.ps1 -List                             # List skills
    .\install.ps1 -Remove                           # Remove all
    .\install.ps1 -Remove -Skill <n>                # Remove specific
    .\install.ps1 -Info                             # Show status
    .\install.ps1 -Help                             # This message

  Examples:
    # Install all skills for Claude Code & Cursor
    .\install.ps1 -Platform claude,cursor

    # Install one skill
    .\install.ps1 -Skill sharp-tech-writing

    # Also works with npx skills add:
    npx skills add https://github.com/zhouhuijia/sharp-skills
    npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"

  Platforms:  claude | cursor | codex | copilot | windsurf | aider | workbuddy
  Skills:     sharp-tech-writing | sharp-dataviz | sharp-copywriting |
              sharp-api-design | sharp-interview | sharp-presentation

"@
}

# ── Main ─────────────────────────────────────────────────────────

if ($Help) {
  Print-Help
  exit 0
}

if ($List) {
  List-Skills
  exit 0
}

if ($Info) {
  Show-Info
  exit 0
}

# Resolve platforms
if (-not $Platform) {
  $Platform = Detect-Platform
  if (-not $Platform) {
    $Platform = "claude,cursor"
    Write-Warn "No platform detected, defaulting to: claude,cursor"
  } else {
    Write-Step "Detected platforms: $Platform"
  }
}

if ($Remove) {
  if ($Skill) {
    $plats = $Platform -split ","
    foreach ($p in $plats) {
      Remove-SkillForPlatform $Skill $p
    }
    Write-Ok "Removed $Skill"
  } else {
    Remove-All $Platform
  }
} else {
  if ($Skill) {
    Install-Specific $Skill $Platform
  } else {
    Install-All $Platform
  }
}
