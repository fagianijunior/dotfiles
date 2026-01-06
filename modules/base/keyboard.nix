{ ... }:
{
  # Default keyboard configuration for Brazilian ABNT2 layout
  services.xserver = {
    xkb = {
      layout = "br";
      variant = "abnt2";
    };
  };
  
  # Console keyboard
  console.keyMap = "br-abnt2";
}