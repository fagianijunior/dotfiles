{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kew
  ];

  # Configuração do kew
  xdg.configFile."kew/kewrc".text = ''
    # Kew Configuration File
    
    # Visual settings
    color=true
    unicode=true
    
    # Playback settings
    repeat=off
    shuffle=off
    volume=100
    
    # Display settings
    show_cover=true
    show_spectrum=true
    
    # Key bindings (defaults)
    # Space: Play/Pause
    # n: Next track
    # p: Previous track
    # +/-: Volume up/down
    # s: Shuffle toggle
    # r: Repeat toggle
    # q: Quit
    # f: Add file/folder
    # c: Clear playlist
    # /: Search
    # h: Help
  '';

  # Script helper para iniciar kew com uma pasta
  home.file.".local/bin/kew-music" = {
    text = ''
      #!/usr/bin/env fish
      # Helper script to start kew with music directory
      
      set MUSIC_DIR "$HOME/Music"
      
      if test -d "$MUSIC_DIR"
        kew "$MUSIC_DIR"
      else
        echo "Music directory not found: $MUSIC_DIR"
        echo "Starting kew without directory..."
        kew
      end
    '';
    executable = true;
  };
}
