{
  description = "The whole kit n kaboodle";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-managerU = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-managerS = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = {
    nixpkgs-unstable,
    nixpkgs-stable,
    home-managerU,
    home-managerS,
    agenix,
    flatpaks,
    catppuccin,
    lanzaboote,
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
          lanzaboote.nixosModules.lanzaboote
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
      huskynix = mkWorkstation {
        deviceModule = ./devices/desktop/huskynix/default.nix;
        hmImports = [
          ./home/common.nix
          ./home/shell/zsh
          ./home/niri.nix
          catppuccin.homeModules.catppuccin
        ];
      };

      pugnix = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./devices/server/pugnix/default.nix
          home-managerS.nixosModules.home-manager
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
                imports = [
                  ./home/shell/zsh
                  catppuccin.homeModules.catppuccin
                  {
                    home = {
                      username = "jampyvi";
                      homeDirectory = "/home/jampyvi";
                      stateVersion = "26.05";
                    };
                    programs.home-manager.enable = true;
                    programs.btop = {
                      enable = true;
                      settings = {
                        theme_background = true;
                        truecolor = true;
                      };
                    };
                  }
                ];
              };
            };
          }
        ];
      };
    };
    packages.x86_64-linux = {
      pugnix-image = inputs.self.nixosConfigurations.pugnix.config.system.build.sdImage;
    };
  };
}
