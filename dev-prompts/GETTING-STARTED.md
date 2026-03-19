# 🚀 GETTING STARTED — Dev Sênior Híbrido

Guia completo para executar o ambiente após extrair o ZIP.

---

## Pré-requisitos

| Ferramenta | Link | Obrigatório |
|---|---|---|
| Windows 11 | — | ✅ |
| VS Code | https://code.visualstudio.com/ | ✅ |
| PowerShell 5.1+ (ou PS7) | já incluso no Windows | ✅ |
| Docker Desktop | https://www.docker.com/products/docker-desktop/ | Recomendado |
| WSL2 + Ubuntu 24.04 | `wsl --install -d Ubuntu-24.04` | Recomendado |

---

## PASSO 1 — Extrair o ZIP

Extraia `dev-prompts-full.zip` para `D:\Dev` (ou `C:\Dev` se não tiver D:).

Resultado esperado após extração:

```
D:\Dev\
├── GETTING-STARTED.md        ← este arquivo
├── README.dev.md
├── prompts\
│   ├── vs-ia-master.md
│   └── vs-ia-short.md
├── configs\
│   ├── copilot-instructions.md
│   └── ai-context.md
└── scripts\
    ├── setup-dev-prompts.ps1
    ├── install-extensions.ps1
    └── export-prompts.ps1
```

---

## PASSO 2 — Habilitar scripts PowerShell (uma vez)

Abra o **PowerShell como Administrador** e execute:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## PASSO 3 — Instalar extensões do VS Code e ferramentas

```powershell
# Navegue até a pasta de scripts
cd D:\Dev\scripts

# Instala extensões do VS Code + verifica ferramentas via winget
.\install-extensions.ps1
```

> Responda `s` para cada ferramenta que quiser instalar (Git, Node.js, Python, etc.)
>
> Para instalar tudo sem confirmação:
> ```powershell
> .\install-extensions.ps1 -Force
> ```
>
> Para instalar apenas extensões VS Code (pular ferramentas):
> ```powershell
> .\install-extensions.ps1 -SkipTools
> ```

**Extensões instaladas automaticamente:**

| Categoria | Extensões |
|---|---|
| IA / Copilot | GitHub Copilot, GitHub Copilot Chat |
| Python | Python, Pylance, Debugpy |
| Node / JS / TS | ESLint, Prettier, TypeScript |
| Java | Extension Pack for Java |
| .NET / C# | C# Dev Kit |
| Go | Go |
| Rust | rust-analyzer |
| PowerShell | PowerShell |
| Docker | Docker, Dev Containers |
| WSL | Remote - WSL |
| Git | GitLens, GitHub Pull Requests |
| API / REST | REST Client |
| Config | YAML, TOML, DotENV, EditorConfig |
| Ortografia | Code Spell Checker (EN + PT-BR) |

---

## PASSO 4 — Configurar prompts e perfil PowerShell

```powershell
cd D:\Dev\scripts
.\setup-dev-prompts.ps1
```

> Responda `s` quando perguntado sobre adicionar funções ao `$PROFILE`.

---

## PASSO 5 — Recarregar e testar

```powershell
# Recarrega o perfil
. $PROFILE

# Testa os comandos disponíveis
aidev          # exibe o prompt curto → cole no Copilot Chat
help-dev       # lista todos os comandos
proj python    # navega para D:\Dev\workspace\python
prompts        # lista arquivos de prompt disponíveis
```

---

## PASSO 6 — Configurar o Copilot no VS Code

1. Pressione `Ctrl+Alt+I` para abrir o **Copilot Chat**
2. No terminal, execute `aidev` e copie o output
3. Cole o conteúdo como **primeira mensagem** da conversa Copilot

Para uso automático (todas as sessões), copie o conteúdo de
`D:\Dev\configs\copilot-instructions.md` para:
```
seu-repositorio\.github\copilot-instructions.md
```

---

## Comandos disponíveis após o setup

```powershell
aidev                    # exibe prompt curto de contexto de IA
proj <stack>             # navega para D:\Dev\workspace\<stack>
                         # ex: proj python | proj node | proj go
mkproj <stack> <nome>    # cria projeto com src/ tests/ docker/ README.md
                         # ex: mkproj node minha-api
prompts                  # lista arquivos .md em D:\Dev\prompts
help-dev                 # mostra todos os comandos
```

---

## Uso no Ubuntu / WSL2

```bash
# [Ubuntu WSL]
# Os arquivos em D:\Dev ficam em /mnt/d/Dev no WSL
cat /mnt/d/Dev/prompts/vs-ia-short.md

# Alias útil (adicione ao ~/.bashrc)
alias aidev='cat /mnt/d/Dev/prompts/vs-ia-short.md'
```

---

## Exportar para outra máquina

```powershell
# [Windows PowerShell]
cd D:\Dev\scripts
.\export-prompts.ps1
# → gera dist\dev-prompts.zip pronto para copiar
```

---

## Solução de problemas

| Problema | Solução |
|---|---|
| `code` não reconhecido | Reinstale o VS Code marcando "Add to PATH" |
| Scripts bloqueados | Execute `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Pasta `D:\Dev` não criada | Execute `setup-dev-prompts.ps1` — cria automaticamente |
| Extensão não instalou | Abra VS Code → Extensions → pesquise pelo nome e instale manualmente |
| `aidev` não funciona | Execute `. $PROFILE` para recarregar o perfil |
