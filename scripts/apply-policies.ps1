# Apply Cursor Rules and Skills to Target Project (Windows PowerShell)
# Usage: .\apply-policies.ps1 C:\path\to\target-project

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetPath
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

# Verify target exists
if (-not (Test-Path $TargetPath)) {
    Write-Host "Error: Target directory does not exist: $TargetPath" -ForegroundColor Red
    exit 1
}

Write-Host "=== Applying Development Policies ===" -ForegroundColor Green
Write-Host "From: $RepoRoot"
Write-Host "To:   $TargetPath"
Write-Host ""

# Function to copy with confirmation
function Copy-WithConfirm {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Name
    )

    if (Test-Path $Destination) {
        Write-Host "$Name already exists in target." -ForegroundColor Yellow
        $response = Read-Host "Overwrite? (y/n)"
        if ($response -ne 'y') {
            Write-Host "Skipped $Name"
            return $false
        }
    }

    Copy-Item -Path $Source -Destination $Destination -Recurse -Force
    Write-Host "✓ Copied $Name" -ForegroundColor Green
    return $true
}

# 1. Copy Cursor Rules
Write-Host "1. Copying Cursor Rules..."
$cursorDir = Join-Path $TargetPath ".cursor"
New-Item -ItemType Directory -Force -Path $cursorDir | Out-Null

$rulesSource = Join-Path $RepoRoot ".cursor\rules"
$rulesDest = Join-Path $cursorDir "rules"
if (Copy-WithConfirm -Source $rulesSource -Destination $rulesDest -Name "Cursor Rules") {
    Write-Host "  → .cursor\rules\ directory copied"
}
Write-Host ""

# 2. Copy Skills (optional)
Write-Host "2. Copying Skills..."
$response = Read-Host "Copy skills directory? (y/n)"
if ($response -eq 'y') {
    $skillsSource = Join-Path $RepoRoot "skills"
    $skillsDest = Join-Path $TargetPath "skills"
    if (Copy-WithConfirm -Source $skillsSource -Destination $skillsDest -Name "Skills") {
        Write-Host "  → skills\ directory copied"
    }
}
Write-Host ""

# 3. Copy Terminal & SSH Policy
Write-Host "3. Copying Terminal & SSH Policy..."
$response = Read-Host "Copy Terminal & SSH Policy? (y/n)"
if ($response -eq 'y') {
    $opsDir = Join-Path $TargetPath "docs\ops"
    New-Item -ItemType Directory -Force -Path $opsDir | Out-Null

    $policySource = Join-Path $RepoRoot "docs\ops\TERMINAL_SSH_POLICY.md"
    $policyDest = Join-Path $opsDir "TERMINAL_SSH_POLICY.md"
    if (Copy-WithConfirm -Source $policySource -Destination $policyDest -Name "Terminal Policy") {
        Write-Host "  → docs\ops\TERMINAL_SSH_POLICY.md copied"
    }
}
Write-Host ""

# 4. Create .editorconfig if missing
Write-Host "4. Checking .editorconfig..."
$editorconfigPath = Join-Path $TargetPath ".editorconfig"
if (-not (Test-Path $editorconfigPath)) {
    @"
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[*.py]
indent_size = 4
"@ | Out-File -FilePath $editorconfigPath -Encoding UTF8
    Write-Host "✓ Created .editorconfig" -ForegroundColor Green
} else {
    Write-Host "  .editorconfig already exists, skipped"
}
Write-Host ""

# 5. Summary
Write-Host "=== Done! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Applied to: $TargetPath"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Review copied files in your target project"
Write-Host "2. Customize .cursor\rules\999-overrides.md for project-specific rules"
Write-Host "3. Update your README to reference these policies"
Write-Host ""
Write-Host "Documentation:"
Write-Host "- Usage with Cursor: $RepoRoot\docs\USAGE_WITH_CURSOR.md"
Write-Host "- Usage with Claude Code: $RepoRoot\docs\USAGE_WITH_CLAUDE_CODE.md"
Write-Host "- Architecture: $RepoRoot\docs\ARCHITECTURE_OF_POLICIES.md"
Write-Host ""
