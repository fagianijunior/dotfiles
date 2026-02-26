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

### Build local no Orange Pi (recomendado)

**IMPORTANTE:** Antes de fazer o primeiro rebuild, crie um swap temporário para evitar travamentos:

```bash
# 1. Criar swap temporário manualmente (2GB)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 2. Fazer o build (com recursos limitados para não travar)
cd /root/dotfiles
sudo nixos-rebuild switch --flake .#orangepizero2 --option max-jobs 1 --option cores 2
```

Após o primeiro build bem-sucedido, o NixOS irá gerenciar o swapfile automaticamente (configurado em `hardware-configuration.nix`). O swap temporário criado manualmente será substituído pelo gerenciado pelo NixOS no próximo boot.

### Deploy remoto

Para aplicar a configuração remotamente do seu desktop:

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
- Swap de 2GB configurado (pode ser movido para SSD externo)

## Movendo Swap para SSD Externo

Quando plugar um SSD externo, edite `hardware-configuration.nix`:

```nix
swapDevices = [
  {
    device = "/mnt/ssd/swapfile";  # Ajuste o caminho
    size = 4096;  # Pode aumentar para 4GB no SSD
  }
];
```

Ou use uma partição swap dedicada:

```nix
swapDevices = [
  { device = "/dev/sda2"; }  # Partição swap no SSD
];
```
