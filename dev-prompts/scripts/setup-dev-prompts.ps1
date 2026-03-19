<#
.SYNOPSIS
    Setup de prompts e configs de IA para ambiente Dev Sênior híbrido.

.DESCRIPTION
    Cria a estrutura de pastas em D:\Dev (fallback C:\Dev) e escreve os
    arquivos de prompt e configuração de IA. O script é idempotente:
    arquivos existentes não são sobrescritos sem confirmação.

.EXAMPLE
    .\setup-dev-prompts.ps1
    .\setup-dev-prompts.ps1 -Force   # sobrescreve sem confirmar

.NOTES
    Ambiente: Windows 11 · PowerShell 5.1+ ou PowerShell 7+
    Raiz preferida: D:\Dev  |  Fallback: C:\Dev
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Write-Step {
    param([string]$Message)
    Write-Host "  --> $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor Green
}

function Write-Skip {
    param([string]$Message)
    Write-Host "  [--] $Message (já existe, pulando)" -ForegroundColor DarkGray
}

function Write-FileContent {
    <#
    Escreve $Content em $Path com UTF-8 sem BOM.
    Se o arquivo já existir, pede confirmação (ou usa -Force).
    #>
    param(
        [string]$Path,
        [string]$Content,
        [switch]$ForceWrite
    )

    if (Test-Path $Path) {
        if (-not $ForceWrite) {
            $answer = Read-Host "  Arquivo '$Path' já existe. Sobrescrever? [s/N]"
            if ($answer -notmatch '^[sS]$') {
                Write-Skip $Path
                return
            }
        }
    }

    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
    Write-Ok $Path
}

# ---------------------------------------------------------------------------
# Resolve raiz (D:\Dev ou C:\Dev)
# ---------------------------------------------------------------------------
$devRoot = if (Test-Path 'D:\') { 'D:\Dev' } else { 'C:\Dev' }
Write-Host ""
Write-Host "=== Setup Dev Prompts ===" -ForegroundColor Yellow
Write-Host "  Raiz: $devRoot"
Write-Host ""

# ---------------------------------------------------------------------------
# Criar estrutura de pastas
# ---------------------------------------------------------------------------
Write-Step "Criando estrutura de pastas..."

$folders = @(
    "$devRoot\prompts",
    "$devRoot\configs",
    "$devRoot\scripts",
    "$devRoot\logs",
    "$devRoot\state",
    "$devRoot\templates",
    "$devRoot\tools",
    "$devRoot\workspace\python",
    "$devRoot\workspace\node",
    "$devRoot\workspace\dotnet",
    "$devRoot\workspace\java",
    "$devRoot\workspace\go",
    "$devRoot\workspace\rust",
    "$devRoot\workspace\labs"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Ok $folder
    } else {
        Write-Skip $folder
    }
}

# ---------------------------------------------------------------------------
# Conteúdo: Prompt Mestre (vs-ia-master.md)
# ---------------------------------------------------------------------------
$masterPrompt = @'
# PROMPT MESTRE — VS CODE + WINDOWS + WSL + DOCKER + DEV SÊNIOR + SEGURANÇA DEFENSIVA

Você é meu engenheiro sênior de desenvolvimento, automação, DevOps, workstation profissional e segurança defensiva em laboratório autorizado.

Você atua dentro do meu VS Code como mentor técnico, arquiteto, revisor, solucionador de problemas e assistente de shell.

## CONTEXTO REAL DO MEU AMBIENTE

Host principal:
- Windows 11
- PowerShell como shell administrativo principal
- VS Code como IDE principal
- Docker Desktop instalado
- WSL2 ativo
- Ubuntu 24.04 LTS no WSL
- Docker funcionando no Windows e dentro do Ubuntu via integração WSL

Estrutura principal:
- Raiz operacional principal: D:\Dev
- Logs: D:\Dev\logs
- Estado: D:\Dev\state
- Scripts: D:\Dev\scripts
- Templates: D:\Dev\templates
- Prompts: D:\Dev\prompts
- Configs: D:\Dev\configs
- Tools: D:\Dev\tools
- Workspace: D:\Dev\workspace

Workspaces por stack:
- D:\Dev\workspace\python
- D:\Dev\workspace\node
- D:\Dev\workspace\dotnet
- D:\Dev\workspace\java
- D:\Dev\workspace\go
- D:\Dev\workspace\rust
- D:\Dev\workspace\labs

Ambiente Linux principal:
- Ubuntu 24.04 no WSL2
- Diretório espelhado principal no Linux: /mnt/d/Dev
- Docker deve preferir integração com WSL
- Sempre que fizer sentido, prefira rodar ferramentas no Ubuntu/WSL
- Quando for melhor usar Windows nativo, explique por quê

## OBJETIVO

Você deve me ajudar a operar este ambiente como um profissional sênior híbrido:
- desenvolvimento profissional
- automação e DevOps
- backend moderno
- containers e ambientes reproduzíveis
- observabilidade e troubleshooting
- segurança defensiva e laboratórios autorizados

Seu foco é entregar resultado real, pronto para executar, sem respostas vagas.

## REGRAS DE OPERAÇÃO

1. Sempre considere o contexto atual antes de responder.
2. Sempre priorize soluções práticas, estáveis e reproduzíveis.
3. Sempre prefira:
   - Ubuntu/WSL para ferramentas Linux e fluxos de desenvolvimento
   - PowerShell para automação Windows
   - Docker para isolamento quando fizer sentido
4. Sempre use caminhos reais do meu ambiente.
5. Não use placeholders vagos.
6. Não invente nomes de pacotes, extensões ou comandos.
7. Não entregue pseudocódigo quando eu pedir código ou shell.
8. Se eu pedir setup, entregue comandos copiáveis.
9. Se eu pedir código, entregue código pronto.
10. Se eu pedir arquitetura, explique a estrutura e o fluxo.
11. Se eu pedir troubleshooting, faça diagnóstico por etapas.
12. Sempre que possível, inclua validação depois dos comandos.
13. Sempre que possível, inclua rollback, reversão ou recuperação.
14. Sempre explique rapidamente o porquê das decisões.

## SEGURANÇA E LIMITES

O ambiente inclui segurança defensiva e laboratório autorizado.

Você pode ajudar com:
- troubleshooting, observabilidade, captura e análise de tráfego
- inventário, hardening, diagnóstico, análise local
- laboratórios controlados, ambientes vulneráveis locais para estudo autorizado
- revisão de configuração insegura, correção e mitigação

Você NÃO deve ajudar com:
- malware, trojans, ransomware, credential theft, brute force
- phishing, exploração ilegal, bypass de autenticação
- payload ofensivo, persistência maliciosa, intrusão real em terceiros
- automações ofensivas fora de laboratório autorizado

Se o pedido tocar em segurança, trate sempre como:
- laboratório local, ambiente autorizado, finalidade defensiva de aprendizado ou validação segura

## COMO RESPONDER

Formato preferido:
1. resumo curto
2. passo a passo
3. comandos prontos
4. validação
5. observações de risco ou rollback, se houver

Sempre indique o contexto: [Windows PowerShell] / [Ubuntu WSL] / [Docker] / [VS Code]

## STACK PADRÃO

Linguagens: Python · Node.js · Java · .NET · Go · Rust · Perl
Dev tools: VS Code · Docker · Git · GitHub CLI · Maven · Gradle · DBeaver · Postman · Insomnia
Defensive tools: Wireshark · Nmap · Sysinternals · OWASP ZAP · Burp Suite Community
'@

# ---------------------------------------------------------------------------
# Conteúdo: Prompt Curto (vs-ia-short.md)
# ---------------------------------------------------------------------------
$shortPrompt = @'
# VS CODE — PROMPT CURTO (SHORT)

Você é meu engenheiro sênior: desenvolvimento, automação, DevOps, segurança defensiva.

## Ambiente

- Windows 11 · PowerShell · VS Code · Docker Desktop · WSL2 · Ubuntu 24.04
- Raiz: D:\Dev (Windows) / /mnt/d/Dev (WSL)
- Workspaces: D:\Dev\workspace\{python,node,dotnet,java,go,rust,labs}

## Regras

- Resposta objetiva: resumo → passo a passo → comandos prontos → validação
- Indique sempre o contexto: [Windows PowerShell] / [Ubuntu WSL] / [Docker]
- Prefira WSL/bash para Linux; PowerShell para Windows; Docker para isolamento
- Caminhos reais, sem placeholders. Código pronto, sem pseudocódigo
- Valide antes de instalar. Inclua rollback quando relevante

## Segurança

Defensiva e laboratório autorizado apenas.
NÃO ajude com: malware, ransomware, credential theft, brute force, phishing,
bypass de autenticação, payload ofensivo, intrusão real.
'@

# ---------------------------------------------------------------------------
# Conteúdo: Copilot Instructions
# ---------------------------------------------------------------------------
$copilotInstructions = @'
# Copilot Instructions — Dev Sênior Híbrido

Você é um engenheiro sênior de desenvolvimento, automação, DevOps e segurança defensiva
em laboratório autorizado, atuando como mentor técnico e assistente de shell no VS Code.

Ambiente: Windows 11 · PowerShell · VS Code · Docker Desktop · WSL2 · Ubuntu 24.04 LTS
Raiz Windows: D:\Dev  |  Raiz WSL: /mnt/d/Dev
Workspaces: D:\Dev\workspace\{python,node,dotnet,java,go,rust,labs}

Respostas: objetivas · resumo → passo a passo → comandos → validação
Contexto do shell: [Windows PowerShell] / [Ubuntu WSL] / [Docker]
Prefira WSL/bash para Linux, PowerShell para Windows, Docker para isolamento.
Caminhos reais, código pronto, sem pseudocódigo.

Segurança: DEFENSIVA e laboratório autorizado APENAS.
NÃO ajude com: malware, credential theft, brute force, bypass de autenticação,
payload ofensivo, intrusão real.
'@

# ---------------------------------------------------------------------------
# Escrever arquivos de prompt
# ---------------------------------------------------------------------------
Write-Step "Escrevendo arquivos de prompt..."

Write-FileContent -Path "$devRoot\prompts\vs-ia-master.md" -Content $masterPrompt -ForceWrite:$Force
Write-FileContent -Path "$devRoot\prompts\vs-ia-short.md"  -Content $shortPrompt  -ForceWrite:$Force
Write-FileContent -Path "$devRoot\configs\copilot-instructions.md" -Content $copilotInstructions -ForceWrite:$Force

# ---------------------------------------------------------------------------
# Adicionar função aidev + funções utilitárias ao perfil PowerShell
# ---------------------------------------------------------------------------
Write-Step "Verificando perfil PowerShell..."

$profileContent = @"

# ---------------------------------------------------------------------------
# Dev Sênior — funções de ambiente  (adicionado por setup-dev-prompts.ps1)
# ---------------------------------------------------------------------------
`$DevRoot = if (Test-Path 'D:\') { 'D:\Dev' } else { 'C:\Dev' }

function aidev {
    <#
    .SYNOPSIS Exibe o prompt curto de contexto de IA no terminal.
    #>
    `$promptFile = "`$DevRoot\prompts\vs-ia-short.md"
    if (Test-Path `$promptFile) {
        Get-Content `$promptFile | Write-Host
        Write-Host ""
        Write-Host "[aidev] Conteúdo copiado do arquivo: `$promptFile" -ForegroundColor DarkGray
    } else {
        Write-Warning "Arquivo de prompt nao encontrado: `$promptFile"
        Write-Warning "Execute: .\dev-prompts\scripts\setup-dev-prompts.ps1"
    }
}

function proj {
    <#
    .SYNOPSIS Navega para D:\Dev\workspace\<nome>.
    .EXAMPLE  proj python
    #>
    param([string]`$Name)
    `$target = "`$DevRoot\workspace\`$Name"
    if (Test-Path `$target) {
        Set-Location `$target
        Write-Host "[proj] `$target" -ForegroundColor Cyan
    } else {
        Write-Warning "Workspace nao encontrado: `$target"
        Write-Host "Workspaces disponiveis:" -ForegroundColor Yellow
        Get-ChildItem "`$DevRoot\workspace" -Directory | Select-Object -ExpandProperty Name
    }
}

function prompts {
    <#
    .SYNOPSIS Lista arquivos de prompt disponíveis em D:\Dev\prompts.
    #>
    `$promptsDir = "`$DevRoot\prompts"
    if (Test-Path `$promptsDir) {
        Write-Host "Prompts disponíveis em `$promptsDir :" -ForegroundColor Yellow
        Get-ChildItem `$promptsDir -Filter '*.md' | ForEach-Object {
            Write-Host "  `$(`$_.Name)" -ForegroundColor Cyan
        }
    } else {
        Write-Warning "Pasta de prompts nao encontrada: `$promptsDir"
    }
}

function mkproj {
    <#
    .SYNOPSIS Cria estrutura de novo projeto em D:\Dev\workspace\<stack>\<nome>.
    .EXAMPLE  mkproj python meu-projeto
    #>
    param(
        [string]`$Stack,
        [string]`$Name
    )
    if (-not `$Stack -or -not `$Name) {
        Write-Host "Uso: mkproj <stack> <nome>" -ForegroundColor Yellow
        Write-Host "Stacks: python, node, dotnet, java, go, rust, labs"
        return
    }
    `$target = "`$DevRoot\workspace\`$Stack\`$Name"
    if (Test-Path `$target) {
        Write-Warning "Projeto ja existe: `$target"
        return
    }
    New-Item -ItemType Directory -Path "`$target\src"    -Force | Out-Null
    New-Item -ItemType Directory -Path "`$target\tests"  -Force | Out-Null
    New-Item -ItemType Directory -Path "`$target\docker" -Force | Out-Null
    @"
# `$Name

Projeto `$Stack criado em `$(Get-Date -Format 'yyyy-MM-dd').

## Estrutura

- ``src/`` — código principal
- ``tests/`` — testes
- ``docker/`` — Dockerfiles e compose
"@ | Set-Content "`$target\README.md" -Encoding UTF8
    Write-Host "  [OK] Projeto criado: `$target" -ForegroundColor Green
    Set-Location `$target
}

function help-dev {
    <#
    .SYNOPSIS Lista as funções de ambiente disponíveis.
    #>
    Write-Host ""
    Write-Host "=== Dev Sênior — Funções disponíveis ===" -ForegroundColor Yellow
    Write-Host "  aidev              Exibe o prompt curto de IA no terminal"
    Write-Host "  proj <stack>       Navega para D:\Dev\workspace\<stack>"
    Write-Host "  prompts            Lista arquivos de prompt em D:\Dev\prompts"
    Write-Host "  mkproj <s> <n>     Cria estrutura de projeto em workspace"
    Write-Host "  help-dev           Esta mensagem"
    Write-Host ""
}
"@

$marker = '# Dev Sênior — funções de ambiente'

if (Test-Path $PROFILE) {
    $existing = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($existing -match [regex]::Escape($marker)) {
        Write-Skip "Funções já presentes no perfil PowerShell ($PROFILE)"
    } else {
        if ($Force -or (Read-Host "  Adicionar funções (aidev, proj, mkproj, prompts, help-dev) ao perfil PowerShell? [s/N]") -match '^[sS]$') {
            Add-Content -Path $PROFILE -Value $profileContent -Encoding UTF8
            Write-Ok "Funções adicionadas ao perfil: $PROFILE"
            Write-Host "  Execute '. `$PROFILE' para carregar no shell atual" -ForegroundColor DarkYellow
        } else {
            Write-Skip "Perfil PowerShell (usuário optou por não modificar)"
        }
    }
} else {
    $profileDir = Split-Path $PROFILE -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    if ($Force -or (Read-Host "  Criar perfil PowerShell e adicionar funções? [s/N]") -match '^[sS]$') {
        Set-Content -Path $PROFILE -Value $profileContent.TrimStart() -Encoding UTF8
        Write-Ok "Perfil criado: $PROFILE"
        Write-Host "  Execute '. `$PROFILE' para carregar no shell atual" -ForegroundColor DarkYellow
    } else {
        Write-Skip "Criação do perfil PowerShell (usuário optou por não criar)"
    }
}

# ---------------------------------------------------------------------------
# Resumo final
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Concluído ===" -ForegroundColor Green
Write-Host ""
Write-Host "Arquivos criados/atualizados em $devRoot :" -ForegroundColor Yellow
Write-Host "  prompts\vs-ia-master.md       — prompt completo"
Write-Host "  prompts\vs-ia-short.md        — prompt curto"
Write-Host "  configs\copilot-instructions.md — instruções do Copilot"
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "  1. Recarregue o perfil:  . `$PROFILE"
Write-Host "  2. Teste:                aidev"
Write-Host "  3. Veja workspaces:      proj"
Write-Host "  4. Ajuda:                help-dev"
Write-Host ""
