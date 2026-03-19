<#
.SYNOPSIS
    Empacota os prompts e configs de IA em um arquivo .zip para distribuição.

.DESCRIPTION
    Cria dist\dev-prompts.zip com os arquivos de prompt e configuração prontos
    para copiar para D:\Dev\prompts e D:\Dev\configs em outro ambiente.

.EXAMPLE
    .\export-prompts.ps1
    .\export-prompts.ps1 -OutputDir C:\Users\me\Desktop

.NOTES
    Ambiente: Windows 11 · PowerShell 5.1+ ou PowerShell 7+
    Saída padrão: dist\dev-prompts.zip (relativo ao script ou à raiz do repo)
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

$zipPath = Join-Path $OutputDir 'dev-prompts.zip'

# ---------------------------------------------------------------------------
# Arquivos a empacotar
# ---------------------------------------------------------------------------
$filesToPack = @(
    @{ Src = Join-Path $promptsDir 'prompts\vs-ia-master.md';          Dest = 'prompts\vs-ia-master.md' },
    @{ Src = Join-Path $promptsDir 'prompts\vs-ia-short.md';           Dest = 'prompts\vs-ia-short.md' },
    @{ Src = Join-Path $promptsDir 'configs\copilot-instructions.md';  Dest = 'configs\copilot-instructions.md' },
    @{ Src = Join-Path $promptsDir 'configs\ai-context.md';            Dest = 'configs\ai-context.md' },
    @{ Src = Join-Path $promptsDir 'README.dev.md';                    Dest = 'README.dev.md' }
)

# ---------------------------------------------------------------------------
# Criar pasta de saída e montar zip
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Export Dev Prompts ===" -ForegroundColor Yellow

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
            Write-Warning "Arquivo não encontrado (pulando): $src"
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
    Write-Host "Para instalar em outro ambiente:" -ForegroundColor Yellow
    Write-Host "  1. Copie dev-prompts.zip para a nova máquina"
    Write-Host "  2. Extraia em D:\Dev  (ou C:\Dev)"
    Write-Host "     Resultado esperado:"
    Write-Host "       D:\Dev\prompts\vs-ia-master.md"
    Write-Host "       D:\Dev\prompts\vs-ia-short.md"
    Write-Host "       D:\Dev\configs\copilot-instructions.md"
    Write-Host "       D:\Dev\configs\ai-context.md"
    Write-Host "  3. Execute o setup para registrar as funcoes no perfil:"
    Write-Host "       .\scripts\setup-dev-prompts.ps1"
    Write-Host ""
}
finally {
    # Limpar diretório temporário
    if (Test-Path $tmpDir) {
        Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
