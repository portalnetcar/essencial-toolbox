# VSCode Automated Setup & Provisioning

Este diretório contém uma suíte de automação *production-ready* para instalação e provisionamento do Visual Studio Code. A arquitetura dos scripts foi desenhada focando em **resiliência, eficiência de I/O e idempotência**, garantindo um setup confiável tanto em macOS (Apple Silicon/Intel) quanto em distribuições Linux baseadas em Debian/Ubuntu.

## Como Usar (Quick Start)

Os scripts foram otimizados para execução *one-liner* segura diretamente do repositório remoto.

### 1. Instalação do VSCode (Core)
Instala o binário base do VSCode. No macOS, utiliza o Homebrew (baixando o binário Universal para Apple Silicon). No Linux, configura o *keyring* GPG oficial da Microsoft e instala via APT.

```bash
curl -fsSL https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/main/install_vscode/vscode_check_install_update.sh | bash

```

### 2. Provisionamento de Extensões Essenciais

Verifica a presença da CLI do VSCode e instala um *baseline* de extensões voltadas para Platform Engineering, Devops, Cloud Architecture (AWS) e IA.

```bash
curl -fsSL https://raw.githubusercontent.com/portalnetcar/essencial-toolbox/main/install_vscode/vscode_check_extensions.sh | bash

```

## Extensões Provisionadas (Baseline)

A suíte instala automaticamente as seguintes ferramentas de produtividade e infraestrutura:

* **Linguagens:** `golang.go`, `rust-lang.rust-analyzer`
* **Infraestrutura e Cloud:** `hashicorp.terraform`, `amazonwebservices.aws-toolkit-vscode`
* **Containers e Orquestração:** `ms-kubernetes-tools.vscode-kubernetes-tools`, `ms-azuretools.vscode-docker`, `redhat.vscode-yaml`
* **CI/CD:** `github.vscode-github-actions`
* **AI/Assistência:** `augment.vscode-augment`
* **Documentação:** `bierner.markdown-mermaid`

## Referências Oficiais

O design destes scripts segue as melhores práticas e diretrizes das documentações oficiais:

* [Visual Studio Code Command Line Interface (CLI)](https://code.visualstudio.com/docs/editor/command-line)
* [Microsoft Docs: VSCode on Linux (GPG & APT Setup)](https://code.visualstudio.com/docs/setup/linux)
* [Microsoft Docs: VSCode on macOS](https://code.visualstudio.com/docs/setup/mac)
* [Unofficial Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
