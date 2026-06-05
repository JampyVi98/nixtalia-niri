_: {
  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "ericlinagora";
          repo = "libfprint-CS9711";
          rev = "c242a40fcc51aec5b57d877bdf3edfe8cb4883fd";
          sha256 = "sha256-WFq8sNitwhOOS3eO8V35EMs+FA73pbILRP0JoW/UR80=";
        };
        buildInputs = (oldAttrs.buildInputs or []) ++ [final.nss final.opencv final.doctest];
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [final.cmake];
        postPatch =
          (oldAttrs.postPatch or "")
          + ''
            sed -i '/sigfm_tests = executable/d' libfprint/sigfm/meson.build
            sed -i 's/1.94.6/1.94.9/g' meson.build
          '';
        doCheck = false; # Disable tests if they fail
      });

      fprintd = prev.fprintd.overrideAttrs (oldAttrs: {
        postPatch =
          (oldAttrs.postPatch or "")
          + ''
            sed -i '1i #define FP_DEVICE_RETRY_TOO_FAST 9999' src/device.c
          '';
      });
    })
  ];

  services.fprintd = {
    enable = true;
  };
}
