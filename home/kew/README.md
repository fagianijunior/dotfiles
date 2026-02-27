# Kew - Terminal Music Player

Kew é um player de áudio minimalista para terminal com interface TUI elegante.

## Recursos

- Interface TUI intuitiva e colorida
- Suporte para múltiplos formatos de áudio (MP3, FLAC, OGG, WAV, etc.)
- Visualização de espectro de áudio
- Exibição de capas de álbum
- Playlist dinâmica
- Controles de reprodução completos

## Uso Básico

### Iniciar kew

```bash
# Iniciar com diretório de música
kew ~/Music

# Iniciar com arquivo específico
kew ~/Music/album/song.mp3

# Usar o script helper
kew-music
```

### Atalhos de Teclado

- `Space`: Play/Pause
- `n`: Próxima faixa
- `p`: Faixa anterior
- `+/-`: Aumentar/diminuir volume
- `s`: Alternar shuffle
- `r`: Alternar repeat
- `f`: Adicionar arquivo/pasta
- `c`: Limpar playlist
- `/`: Buscar
- `h`: Ajuda
- `q`: Sair

## Configuração

A configuração está em `~/.config/kew/kewrc` e inclui:

- Cores e unicode habilitados
- Volume padrão: 100%
- Exibição de capa e espectro habilitados
- Repeat e shuffle desabilitados por padrão

## Integração com Hyprland

Você pode adicionar keybinds no Hyprland para controlar o kew:

```nix
# Em home/hyprland/keybinds.nix
bind = SUPER, M, exec, wezterm start -- kew-music
```

## Dicas

1. Organize sua música em `~/Music` para usar o script `kew-music`
2. Use `/` para buscar rapidamente na playlist
3. Pressione `h` para ver todos os comandos disponíveis
4. O kew suporta tags ID3 para exibir metadados
