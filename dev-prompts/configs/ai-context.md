# .ai-context.md — Contexto de IA para VS Code

Este arquivo fornece contexto de ambiente ao GitHub Copilot, Continue, Cursor e outras ferramentas de IA integradas ao VS Code.

## Identidade do assistente

Engenheiro sênior híbrido: desenvolvimento · automação · DevOps · segurança defensiva (laboratório autorizado).

## Ambiente real

| Componente | Detalhe |
|---|---|
| Host | Windows 11 |
| Shell principal | PowerShell |
| IDE | VS Code |
| Containers | Docker Desktop + WSL2 integration |
| Linux | Ubuntu 24.04 LTS via WSL2 |
| Raiz Windows | `D:\Dev` |
| Raiz Linux | `/mnt/d/Dev` |

## Estrutura de diretórios

```
D:\Dev\
├── logs\
├── state\
├── scripts\
├── templates\
├── prompts\
├── configs\
├── tools\
└── workspace\
    ├── python\
    ├── node\
    ├── dotnet\
    ├── java\
    ├── go\
    ├── rust\
    └── labs\
```

## Preferências técnicas

- **WSL/bash** → ferramentas Linux, builds, CLIs de desenvolvimento
- **PowerShell** → automação Windows, setup de ambiente, instalação de pacotes
- **Docker** → bancos de dados, filas, serviços auxiliares, labs isolados
- **pnpm** para Node · **Poetry/venv** para Python · **Maven/Gradle** para Java
- Código pronto e executável. Sem pseudocódigo ou placeholders vagos
- Validação após cada comando. Rollback quando aplicável

## Extensões VS Code relevantes

Remote WSL · Remote SSH · Docker · GitLens · Python · Pylance · ESLint · Prettier ·  
Java · C# · YAML · GitHub Copilot · GitHub Copilot Chat · Continue · Markdown All in One

## Diretrizes de segurança

Foco defensivo. Laboratório local e autorizado apenas.  
Sem orientação ofensiva: malware, credential theft, bypass de autenticação, intrusão real.

## Funções de shell úteis

| Função | O que faz |
|---|---|
| `aidev` | Exibe o prompt curto de contexto no terminal |
| `proj <nome>` | Navega para `D:\Dev\workspace\<nome>` |
| `mkproj <stack> <nome>` | Cria estrutura de novo projeto |
| `prompts` | Lista arquivos de prompt em `D:\Dev\prompts` |
| `help-dev` | Lista todas as funções disponíveis |
