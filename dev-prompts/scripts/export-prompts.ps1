<#
.SYNOPSIS
    Empacota prompts, configs, scripts e guia de inicio em dev-prompts-full.zip.

.DESCRIPTION
    Cria dist\dev-prompts-full.zip com tudo necessario para configurar o ambiente
    em outro Windows: prompts, configs, scripts de setup/install-extensions/export
    e o GETTING-STARTED.md com instrucoes passo a passo.

.EXAMPLE
    .\export-prompts.ps1
    .\export-prompts.ps1 -OutputDir C:\Users\me\Desktop

.NOTES
    Ambiente: Windows 11 · PowerShell 5.1+ ou PowerShell 7+
    Saida padrao: dist\dev-prompts-full.zip (relativo a raiz do repo)
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$OutputDir = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Resolve caminhos
# ---------------------------------------------------------------------------
$scriptDir  = Split-Path $MyInvocation.MyCommand.Path -Parent
$promptsDir = Split-Path $scriptDir -Parent     # dev-prompts/
$repoRoot   = Split-Path $promptsDir -Parent    # repo root

if (-not $OutputDir) {
    $OutputDir = Join-Path $repoRoot 'dist'
}

$zipPath = Join-Path $OutputDir 'dev-prompts-full.zip'

# ---------------------------------------------------------------------------
# Arquivos a empacotar  (Src relativo a $promptsDir, Dest dentro do zip)
# ---------------------------------------------------------------------------
$filesToPack = @(
    # Guia de inicio
    @{ Src = Join-Path $promptsDir 'GETTING-STARTED.md';               Dest = 'GETTING-STARTED.md' },
    @{ Src = Join-Path $promptsDir 'README.dev.md';                    Dest = 'README.dev.md' },

    # Prompts
    @{ Src = Join-Path $promptsDir 'prompts\vs-ia-master.md';          Dest = 'prompts\vs-ia-master.md' },
    @{ Src = Join-Path $promptsDir 'prompts\vs-ia-short.md';           Dest = 'prompts\vs-ia-short.md' },

    # Configs
    @{ Src = Join-Path $promptsDir 'configs\copilot-instructions.md';  Dest = 'configs\copilot-instructions.md' },
    @{ Src = Join-Path $promptsDir 'configs\ai-context.md';            Dest = 'configs\ai-context.md' },

    # Scripts
    @{ Src = Join-Path $scriptDir  'setup-dev-prompts.ps1';            Dest = 'scripts\setup-dev-prompts.ps1' },
    @{ Src = Join-Path $scriptDir  'install-extensions.ps1';           Dest = 'scripts\install-extensions.ps1' },
    @{ Src = Join-Path $scriptDir  'export-prompts.ps1';               Dest = 'scripts\export-prompts.ps1' }
)

# ---------------------------------------------------------------------------
# Criar pasta de saída e montar zip
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Export Dev Prompts (Full Package) ===" -ForegroundColor Yellow

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Remover zip antigo se existir
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

$tmpDir = Join-Path $env:TEMP "dev-prompts-export-$(Get-Random)"
New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null

try {
    foreach ($entry in $filesToPack) {
        $src  = $entry.Src
        $dest = Join-Path $tmpDir $entry.Dest

        if (-not (Test-Path $src)) {
            Write-Warning "Arquivo nao encontrado (pulando): $src"
            continue
        }

        $destDir = Split-Path $dest -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }

        Copy-Item $src $dest -Force
        Write-Host "  [+] $($entry.Dest)" -ForegroundColor Cyan
    }

    # Compactar
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tmpDir, $zipPath)

    Write-Host ""
    Write-Host "  [OK] Exportado para: $zipPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "Para instalar em outra maquina:" -ForegroundColor Yellow
    Write-Host "  1. Copie dev-prompts-full.zip para a nova maquina"
    Write-Host "  2. Extraia em D:\Dev  (ou C:\Dev)"
    Write-Host "  3. Abra o PowerShell como Administrador e execute:"
    Write-Host "       Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"
    Write-Host "  4. Instale extensoes e ferramentas:"
    Write-Host "       .\scripts\install-extensions.ps1"
    Write-Host "  5. Configure prompts e perfil:"
    Write-Host "       .\scripts\setup-dev-prompts.ps1"
    Write-Host "  6. Recarregue e teste:"
    Write-Host "       . `$PROFILE"
    Write-Host "       aidev"
    Write-Host ""
    Write-Host "  Consulte GETTING-STARTED.md para o guia completo." -ForegroundColor DarkYellow
    Write-Host ""
}
finally {
    # Limpar diretório temporário
    if (Test-Path $tmpDir) {
        Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
