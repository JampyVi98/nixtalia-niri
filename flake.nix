{
  description = "The whole kit n kaboodle";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-managerU = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-managerS = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    catppuccin.url = "github:catppuccin/nix";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  outputs = {
    nixpkgs-unstable,
    nixpkgs-stable,
    home-managerU,
    home-managerS,
    agenix,
    flatpaks,
    catppuccin,
    disko,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    libU = nixpkgs-unstable.lib;

    mkWorkstation = {
      deviceModule,
      hmImports,
    }:
      libU.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          deviceModule
          home-managerU.nixosModules.home-manager
          flatpaks.nixosModules.default
          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                (
                  {osConfig, ...}: {
                    _module.args.hostName = osConfig.networking.hostName;
                  }
                )
              ];
              users.jampyvi = {
                imports = hmImports;
              };
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      erebos = mkWorkstation {
        deviceModule = ./devices/desktop/erebos/default.nix;
        hmImports = [
          ./home/common.nix
          ./home/shell/zsh/zsh.nix
          ./home/niri.nix
          catppuccin.homeModules.catppuccin
        ];
      };

      # steamos build is still in testing, expect major changes and broken functionality
      steamos = mkWorkstation {
        deviceModule = ./devices/desktop/dionysus/default.nix;
        hmImports = [
          ./home/steam.nix
        ];
      };

      seed = mkWorkstation {
        deviceModule = ./devices/server/vms/seed/default.nix;
        hmImports = [
          ./home/common.nix
          ./home/shell/zsh/zsh.nix
          ./home/kde.nix
        ];
      };
    };
  };
}
