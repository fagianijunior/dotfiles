# NixOS Orange Pi Zero 2

Configuração do NixOS para Orange Pi Zero 2 como servidor.

## Características

- **Arquitetura**: ARM64 (aarch64-linux)
- **SoC**: Allwinner H616
- **CPU**: 4x Cortex-A53 @ 1.5GHz
- **Rede**: Ethernet via interface `end0` - WiFi desabilitado
- **Virtualização**: Docker habilitado
- **Interface**: Servidor headless (sem Wayland/X.Org)
- **Kernel**: Linux 6.2+ (linuxPackages_latest)

## Serviços Instalados

- Docker + Docker Compose
- SSH (porta 22)
- systemd-resolved para DNS

## Build

Para construir a configuração:

```bash
nixos-rebuild build --flake .#orangepizero2
```

## Deploy

Para aplicar a configuração no Orange Pi Zero 2:

```bash
nixos-rebuild switch --flake .#orangepizero2 --target-host terabytes@orangepizero2
```

Ou localmente no dispositivo:

```bash
sudo nixos-rebuild switch --flake .#orangepizero2
```

## Configuração de Hardware

O arquivo `hardware-configuration.nix` está configurado para:
- SD Card com labels: `NIXOS_SD` (root) e `FIRMWARE` (boot)
- Interface de rede: `end0` (Ethernet)
- Módulos Allwinner: sunxi, dwmac_sun8i, phy_sun4i_usb
- CPU: Cortex-A53 (4 cores)

## Acesso SSH

O SSH está habilitado por padrão. Para conectar:

```bash
ssh terabytes@orangepizero2
```

## Docker

O Docker está configurado com auto-prune semanal. Para usar:

```bash
docker ps
docker-compose up -d
```

O usuário `terabytes` já está no grupo `docker`.

## Notas

- Sem interface gráfica (servidor headless)
- IPv6 desabilitado
- Firewall habilitado com Docker trusted
- Logs do journald limitados a 100MB e 7 dias
