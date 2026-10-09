{
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # Cargar el módulo kernel de AMD temprano en el proceso de arranque
  boot = {
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["amdgpu"];
  };

  # Indicarle al servidor gráfico (Wayland/X11) que use el driver de amdgpu
  services.xserver.videoDrivers = ["amdgpu"];

  # Opciones para la aceleración gráfica de AMD (Mesa/Vulkan)
  hardware.graphics = {
    enable = mkDefault true;
    enable32Bit = mkDefault true; # Soporte para juegos/aplicaciones de 32 bits (Steam, Wine)
  };
}
