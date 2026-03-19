# Dev Sênior — Prompts e Configs de IA para VS Code

Conjunto de arquivos de prompt, contexto e automação para um ambiente de desenvolvimento híbrido **Windows 11 + WSL2 + Docker + VS Code**, com foco em produtividade sênior e segurança defensiva.

---

## Conteúdo do repositório

```
.
├── .ai-context.md                   # Contexto automático de workspace (Continue, Cursor, etc.)
├── .github/
│   └── copilot-instructions.md      # Instruções automáticas do GitHub Copilot
├── docs/
│   └── prompts/
│       ├── vs-ia-master.md          # Prompt completo (todas as regras e contexto)
│       └── vs-ia-short.md           # Prompt curto (uso rápido)
├── scripts/
│   ├── setup-dev-prompts.ps1        # Setup local no Windows (cria D:\Dev e copia prompts)
│   └── export-prompts.ps1           # Empacota os prompts em .zip para distribuição
└── README.dev.md                    # Guia detalhado de uso por ferramenta
```

---

## Início rápido

### 1. Clone o repositório

```powershell
# [Windows PowerShell]
git clone https://github.com/gpawlakruela-lab/teste.git
cd teste
```

### 2. Execute o setup local

```powershell
# [Windows PowerShell] — cria D:\Dev e instala os prompts localmente
.\scripts\setup-dev-prompts.ps1
```

### 3. Recarregue o perfil e use

```powershell
. $PROFILE       # carrega as funções no shell atual
aidev            # exibe o prompt curto no terminal
help-dev         # lista todas as funções disponíveis
```

---

## Onde usar cada arquivo

| Ferramenta | Arquivo recomendado |
|---|---|
| **GitHub Copilot** | `.github/copilot-instructions.md` (automático) |
| **Copilot Chat** | `docs/prompts/vs-ia-master.md` ou `vs-ia-short.md` |
| **Continue** | `vs-ia-master.md` como `systemMessage` no `config.json` |
| **Cursor** | `vs-ia-master.md` em *Rules for AI* ou `.cursorrules` |
| **Outros** | `.ai-context.md` na raiz do workspace |

> Veja o guia completo em [`README.dev.md`](./README.dev.md).

---

## Exportar / distribuir os prompts

Para gerar um arquivo `.zip` com todos os prompts e configs prontos para copiar em outro ambiente:

```powershell
# [Windows PowerShell]
.\scripts\export-prompts.ps1
```

Isso cria `dist\dev-prompts.zip` contendo apenas os arquivos de prompt e config, prontos para copiar para `D:\Dev\prompts` e `D:\Dev\configs` em qualquer máquina.

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
