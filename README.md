# LunnaOS Polaris

LunnaOS Polaris é a reconstrução do LunnaOS sobre **Bazzite GNOME**, usando o fluxo de imagem bootável recomendado pelo projeto Bazzite/Universal Blue.

## Objetivo

- manter a base, drivers, stack de jogos, rollback e atualizações do Bazzite GNOME;
- aplicar identidade visual LunnaOS: interface escura, acento roxo e wallpaper Polaris;
- disponibilizar Wine nativo no host;
- manter a imagem adequada ao modelo bootc/OSTree, evitando alterações destrutivas no sistema;
- impedir o `systemd-oomd` de encerrar workloads preventivamente por pressão de memória;
- preparar uma ISO instalável e imagens de disco somente depois da validação completa.

## Arquitetura

```text
Bazzite GNOME (stable)
        │
        ├── drivers / firmware / gaming stack / Steam / Lutris / rollback
        │
        └── LunnaOS Polaris layer
              ├── Wine nativo
              ├── GNOME dark + purple accent
              ├── wallpaper Polaris
              ├── favoritos padrão do desktop
              ├── política sem systemd-oomd
              └── identidade /etc/lunnaos/release
```

A base não é um fork do código inteiro do Bazzite. O projeto usa uma camada fina sobre a imagem publicada, o que reduz manutenção e preserva as mudanças upstream.

## Build local

Requisitos: Podman, sudo e Python 3.11+.

```bash
bash ./build_files/validate.sh
podman build --pull=newer -t localhost/lunnaos-polaris:dev .
```

Depois da imagem estar validada:

```bash
bash ./scripts/build-iso.sh localhost/lunnaos-polaris:dev
```

ou:

```bash
bash ./scripts/build-disk.sh localhost/lunnaos-polaris:dev qcow2
```

Os artefatos ficam em `output/`.

## GitHub Actions

O workflow de **build é manual (`workflow_dispatch`)**. Pushes e pull requests não iniciam build da imagem nem da ISO. Existe apenas uma validação automática dos scripts e arquivos de configuração.

No workflow manual, é possível escolher:

- tag da imagem;
- publicar ou não no GHCR;
- gerar ou não a ISO.

## Kernel LunnaOS

A primeira etapa mantém o kernel fornecido pelo Bazzite para não quebrar drivers, módulos akmods e compatibilidade de hardware. A identidade `LunnaOS` já está separada em `/etc/lunnaos/release`.

A troca real do `uname -r` para uma versão de kernel compilada como LunnaOS será feita em uma etapa própria, com validação de drivers e akmods antes de entrar na ISO final. Não é usado um simples `sed` para fingir uma versão de kernel diferente.

## Estado atual

**Fase: fundação do sistema.**

1. Base Bazzite GNOME: preparada.
2. Tema/identidade visual: preparada.
3. Wine nativo: preparado.
4. Política de memória: preparada.
5. Build manual: preparado.
6. ISO: preparado, mas ainda não executado.
7. Kernel próprio LunnaOS: pendente de implementação e validação.
8. Testes de boot/UEFI/Legacy, GPU, Wi-Fi, áudio, Steam, Wine e suspensão: pendentes.

> Nenhum build da imagem ou da ISO deve ser iniciado automaticamente. O objetivo é só gerar a primeira ISO depois que o repositório estiver completo e validado.
