{
  lib,
  pkgs,
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

  # Opciones para la aceleración gráfica de AMD (Mesa/Vulkan/OpenCL)
  hardware.graphics = {
    enable = mkDefault true;
    enable32Bit = mkDefault true; # Soporte para juegos/aplicaciones de 32 bits (Steam, Wine)

    extraPackages = with pkgs; [
      # Soporte de OpenCL para AMD
      rocmPackages.clr.icd
    ];

    # RADV (Mesa Vulkan) ya está habilitado por defecto y es el reemplazo oficial
    extraPackages32 = with pkgs; [
    ];
  };

  # (Opcional) Variables de entorno específicas para AMD
  environment.sessionVariables = {
    # Por defecto, si instalas amdvlk, NixOS puede priorizarlo.
    # Si quieres forzar el uso del driver RADV de Mesa (recomendado para juegos):
    # AMD_VULKAN_ICD = "RADV";
  };
}
