# README.dev.md — Guia de uso dos prompts de IA

Este documento explica **onde e como usar cada arquivo de prompt/contexto** deste repositório nas diferentes ferramentas de IA do VS Code.

---

## Arquivos disponíveis

| Arquivo | Finalidade |
|---|---|
| `dev-prompts/prompts/vs-ia-master.md` | Prompt completo — todas as regras, contexto e stack |
| `dev-prompts/prompts/vs-ia-short.md` | Versão curta — para uso rápido no terminal ou chat |
| `dev-prompts/configs/copilot-instructions.md` | Instruções automáticas para GitHub Copilot |
| `dev-prompts/configs/ai-context.md` | Contexto geral de workspace para qualquer ferramenta de IA |

---

## Como usar em cada ferramenta

### GitHub Copilot Chat

1. Abra o painel **Copilot Chat** no VS Code (`Ctrl+Alt+I`)
2. Cole o conteúdo de `dev-prompts/prompts/vs-ia-master.md` como primeira mensagem da conversa
3. **Ou** use o arquivo `.github/copilot-instructions.md` — o Copilot o carrega automaticamente como contexto do repositório

> **Dica:** Para sessões rápidas, use `vs-ia-short.md` — é suficiente para a maioria das tarefas.

### Continue (extensão VS Code)

1. Abra `~/.continue/config.json` (ou o arquivo de configuração do workspace)
2. Adicione o campo `systemMessage` com o conteúdo de `vs-ia-master.md`:

```json
{
  "models": [
    {
      "title": "Dev Sênior",
      "provider": "...",
      "model": "...",
      "systemMessage": "<cole aqui o conteúdo de vs-ia-master.md>"
    }
  ]
}
```

3. Salve e recarregue o Continue

### Cursor

1. Abra **Cursor Settings → Rules for AI** (ou `.cursorrules` na raiz do projeto)
2. Cole o conteúdo de `dev-prompts/prompts/vs-ia-master.md`
3. Para projetos específicos, crie `.cursorrules` na raiz do projeto com o conteúdo de `vs-ia-short.md`

### Codeium / outros

- Cole o conteúdo de `dev-prompts/prompts/vs-ia-short.md` no campo de **System Prompt** ou **Custom Instructions** da ferramenta
- Referencie `dev-prompts/configs/ai-context.md` como contexto adicional de workspace quando a ferramenta suportar arquivos de contexto

### Workspace docs (contexto automático)

- Ferramentas que leem arquivos de contexto do workspace (como alguns plugins do Continue) detectam `dev-prompts/configs/ai-context.md` automaticamente

---

## Setup local no Windows

Para copiar os prompts para `D:\Dev\prompts` e criar os arquivos de configuração localmente, execute o script PowerShell:

```powershell
# [Windows PowerShell]
.\dev-prompts\scripts\setup-dev-prompts.ps1
```

O script é idempotente: não sobrescreve arquivos existentes sem confirmação.

---

## Função `aidev` (uso rápido no terminal)

Após executar o script de setup, a função `aidev` fica disponível no seu perfil PowerShell:

```powershell
# [Windows PowerShell]
aidev
```

Isso exibe o prompt curto diretamente no terminal — útil para copiar e colar rapidamente no Copilot Chat ou qualquer outra ferramenta.

Para carregar no shell atual sem reiniciar:

```powershell
# [Windows PowerShell]
. $PROFILE
```

---

## Recomendações de uso

- Use **`vs-ia-master.md`** quando iniciar uma sessão longa de desenvolvimento ou quando precisar que o assistente entenda todo o contexto do ambiente
- Use **`vs-ia-short.md`** para tarefas pontuais, perguntas rápidas ou quando o contexto já foi estabelecido
- Mantenha **`.github/copilot-instructions.md`** e **`dev-prompts/configs/copilot-instructions.md`** atualizados para que o Copilot sempre tenha o contexto correto automaticamente
- Atualize **`dev-prompts/configs/ai-context.md`** quando mudar ferramentas, paths ou preferências do ambiente
