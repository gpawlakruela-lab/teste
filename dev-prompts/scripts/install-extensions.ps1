<#
.SYNOPSIS
    Instala extensoes do VS Code e ferramentas opcionais para o ambiente Dev Senior hibrido.

.DESCRIPTION
    - Instala extensoes do VS Code para todas as stacks do ambiente
    - Verifica e instala ferramentas via winget (Git, GitHub CLI, Node.js, Python, Go, Rust)
    - Idempotente: nao reinstala o que ja esta instalado

.EXAMPLE
    .\install-extensions.ps1
    .\install-extensions.ps1 -SkipTools   # apenas extensoes do VS Code

.NOTES
    Ambiente: Windows 11 · PowerShell 5.1+ ou PowerShell 7+
    Requer VS Code instalado e 'code' disponivel no PATH
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$SkipTools,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Write-Step  { param([string]$M); Write-Host "  --> $M" -ForegroundColor Cyan }
function Write-Ok    { param([string]$M); Write-Host "  [OK] $M" -ForegroundColor Green }
function Write-Skip  { param([string]$M); Write-Host "  [--] $M (ja instalado)" -ForegroundColor DarkGray }
function Write-Warn  { param([string]$M); Write-Host "  [!!] $M" -ForegroundColor Yellow }

# ---------------------------------------------------------------------------
# Verificar VS Code
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Install Extensions + Tools ===" -ForegroundColor Yellow
Write-Host ""

$codeAvailable = $null -ne (Get-Command 'code' -ErrorAction SilentlyContinue)

if (-not $codeAvailable) {
    Write-Warn "Comando 'code' nao encontrado no PATH."
    Write-Warn "Instale o VS Code em https://code.visualstudio.com/ e reabra o terminal."
    Write-Warn "Pulando instalacao de extensoes..."
} else {
    Write-Step "Instalando extensoes do VS Code..."

    # Lista de extensoes: ID · Descricao
    $extensions = @(
        # GitHub Copilot
        'GitHub.copilot',
        'GitHub.copilot-chat',

        # Python
        'ms-python.python',
        'ms-python.vscode-pylance',
        'ms-python.debugpy',

        # Node / JavaScript / TypeScript
        'dbaeumer.vscode-eslint',
        'esbenp.prettier-vscode',
        'ms-vscode.vscode-typescript-next',

        # Java
        'vscjava.vscode-java-pack',

        # .NET / C#
        'ms-dotnettools.csdevkit',

        # Go
        'golang.go',

        # Rust
        'rust-lang.rust-analyzer',

        # PowerShell
        'ms-vscode.powershell',

        # Docker / Containers
        'ms-azuretools.vscode-docker',
        'ms-vscode-remote.remote-containers',

        # WSL
        'ms-vscode-remote.remote-wsl',

        # Git / GitHub
        'eamodio.gitlens',
        'github.vscode-pull-request-github',

        # REST / API
        'humao.rest-client',

        # YAML / TOML / Dotenv
        'redhat.vscode-yaml',
        'tamasfe.even-better-toml',
        'mikestead.dotenv',

        # Qualidade / Formatacao
        'EditorConfig.EditorConfig',
        'streetsidesoftware.code-spell-checker',
        'streetsidesoftware.code-spell-checker-portuguese-brazilian'
    )

    $installed = code --list-extensions 2>$null

    foreach ($ext in $extensions) {
        if ($installed -contains $ext) {
            Write-Skip $ext
        } else {
            Write-Step "Instalando: $ext"
            code --install-extension $ext --force 2>&1 | Out-Null
            Write-Ok $ext
        }
    }

    Write-Host ""
    Write-Ok "Extensoes do VS Code concluidas."
}

# ---------------------------------------------------------------------------
# Ferramentas via winget (opcional)
# ---------------------------------------------------------------------------
if (-not $SkipTools) {
    Write-Host ""
    Write-Step "Verificando ferramentas via winget..."

    $wingetAvailable = $null -ne (Get-Command 'winget' -ErrorAction SilentlyContinue)

    if (-not $wingetAvailable) {
        Write-Warn "winget nao disponivel. Instale manualmente as ferramentas abaixo:"
        Write-Host "  Git:        https://git-scm.com/download/win"
        Write-Host "  GitHub CLI: https://cli.github.com/"
        Write-Host "  Node.js:    https://nodejs.org/"
        Write-Host "  Python:     https://www.python.org/downloads/"
        Write-Host "  Go:         https://go.dev/dl/"
        Write-Host "  Rust:       https://rustup.rs/"
        Write-Host "  Docker:     https://www.docker.com/products/docker-desktop/"
    } else {
        # @( @{Id=''; Name=''}, ... )
        $tools = @(
            @{ Id = 'Git.Git';                    Name = 'Git' },
            @{ Id = 'GitHub.cli';                 Name = 'GitHub CLI' },
            @{ Id = 'OpenJS.NodeJS.LTS';          Name = 'Node.js LTS' },
            @{ Id = 'Python.Python.3.12';         Name = 'Python 3.12' },
            @{ Id = 'GoLang.Go';                  Name = 'Go' },
            @{ Id = 'Rustlang.Rustup';            Name = 'Rust (rustup)' },
            @{ Id = 'Docker.DockerDesktop';       Name = 'Docker Desktop' },
            @{ Id = 'Microsoft.WindowsTerminal';  Name = 'Windows Terminal' },
            @{ Id = 'JanDeDobbeleer.OhMyPosh';    Name = 'Oh My Posh (prompt)' }
        )

        foreach ($tool in $tools) {
            Write-Step "Verificando $($tool.Name)..."
            $result = winget list --id $tool.Id --exact 2>&1
            if ($result -match $tool.Id) {
                Write-Skip $tool.Name
            } else {
                if ($Force -or (Read-Host "  Instalar $($tool.Name)? [s/N]") -match '^[sS]$') {
                    winget install --id $tool.Id --silent --accept-package-agreements --accept-source-agreements
                    Write-Ok $tool.Name
                } else {
                    Write-Warn "Pulando: $($tool.Name)"
                }
            }
        }
    }
}

# ---------------------------------------------------------------------------
# Resumo
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Concluido ===" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "  1. Reinicie o VS Code para ativar todas as extensoes"
Write-Host "  2. Execute setup-dev-prompts.ps1 para configurar os prompts e o perfil"
Write-Host "  3. Execute '. `$PROFILE' e depois 'aidev' para testar"
Write-Host ""
