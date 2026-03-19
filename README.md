# Dev Sênior — Prompts e Configs de IA para VS Code

Conjunto de arquivos de prompt, contexto e automação para um ambiente de desenvolvimento híbrido **Windows 11 + WSL2 + Docker + VS Code**, com foco em produtividade sênior e segurança defensiva.

---

## Conteúdo do repositório

```
.
├── dev-prompts/                         # ← TUDO AQUI: prompts, configs e scripts
│   ├── prompts/
│   │   ├── vs-ia-master.md              # Prompt completo (todas as regras e contexto)
│   │   └── vs-ia-short.md              # Prompt curto (uso rápido)
│   ├── configs/
│   │   ├── copilot-instructions.md     # Instruções para GitHub Copilot
│   │   └── ai-context.md              # Contexto automático de workspace
│   ├── scripts/
│   │   ├── setup-dev-prompts.ps1       # Setup local no Windows (cria D:\Dev)
│   │   └── export-prompts.ps1          # Empacota tudo em .zip para distribuição
│   └── README.dev.md                   # Guia detalhado de uso por ferramenta
├── .github/
│   └── copilot-instructions.md         # Auto-carregado pelo GitHub Copilot
└── README.md                           # Este arquivo
```

---

## Início rápido

### 1. Clone o repositório

```powershell
# [Windows PowerShell]
git clone https://github.com/gpawlakruela-lab/teste.git
cd teste
```

### 2. Habilite a execução de scripts (primeira vez)

```powershell
# [Windows PowerShell — executar como Administrador]
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### 3. Execute o setup local

```powershell
# [Windows PowerShell]
.\dev-prompts\scripts\setup-dev-prompts.ps1
```

O script vai:
- Criar `D:\Dev\` (ou `C:\Dev\` se não houver unidade D)
- Copiar todos os prompts para `D:\Dev\prompts\` e `D:\Dev\configs\`
- Perguntar se deseja adicionar as funções (`aidev`, `proj`, etc.) ao seu `$PROFILE`

### 4. Recarregue o perfil e use

```powershell
. $PROFILE       # carrega as funções no shell atual (sem reiniciar)
aidev            # exibe o prompt curto no terminal — pronto para colar no Copilot Chat
help-dev         # lista todas as funções disponíveis
```

### 5. Exporte para outra máquina (opcional)

```powershell
.\dev-prompts\scripts\export-prompts.ps1
# gera dist\dev-prompts.zip
```

Copie o `.zip` na outra máquina, extraia em `D:\Dev\` e repita o passo 3.

---

## Onde usar cada arquivo

| Ferramenta | Arquivo recomendado |
|---|---|
| **GitHub Copilot** | `.github/copilot-instructions.md` (automático) |
| **Copilot Chat** | `dev-prompts/prompts/vs-ia-master.md` ou `vs-ia-short.md` |
| **Continue** | `vs-ia-master.md` como `systemMessage` no `config.json` |
| **Cursor** | `vs-ia-master.md` em *Rules for AI* ou `.cursorrules` |
| **Outros** | `dev-prompts/configs/ai-context.md` na raiz do workspace |

> Veja o guia completo em [`dev-prompts/README.dev.md`](./dev-prompts/README.dev.md).

---

## Exportar / distribuir os prompts

```powershell
# [Windows PowerShell]
.\dev-prompts\scripts\export-prompts.ps1
# → gera dist\dev-prompts.zip
```

Extraia o `.zip` em `D:\Dev\` em qualquer máquina e rode `setup-dev-prompts.ps1`.

---

## Funções PowerShell disponíveis (após setup)

| Função | O que faz |
|---|---|
| `aidev` | Exibe o prompt curto no terminal para cópia rápida |
| `proj <stack>` | Navega para `D:\Dev\workspace\<stack>` |
| `mkproj <stack> <nome>` | Cria estrutura de novo projeto (`src/`, `tests/`, `docker/`, `README.md`) |
| `prompts` | Lista arquivos de prompt em `D:\Dev\prompts` |
| `help-dev` | Lista todas as funções disponíveis |

---

## Ambiente-alvo

| Componente | Detalhe |
|---|---|
| Host | Windows 11 |
| Shell | PowerShell 5.1+ / PowerShell 7+ |
| IDE | VS Code |
| Containers | Docker Desktop (integração WSL2) |
| Linux | Ubuntu 24.04 LTS via WSL2 |
| Raiz Windows | `D:\Dev` (fallback `C:\Dev`) |
| Raiz Linux | `/mnt/d/Dev` |

---

## Segurança

Todos os prompts têm escopo **defensivo e laboratório autorizado**.  
Nenhuma orientação ofensiva: malware, credential theft, bypass de autenticação, intrusão real em terceiros.

---

## Licença

Veja [LICENSE](./LICENSE).
