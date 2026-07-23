{...}: {
  programs.thunderbird = {
    enable = true;
    profiles.jampyvi = {
      isDefault = true;
      # Thunderbird extensions aren't natively supported via Nixpkgs easily,
      # but we can set some sane defaults:
      settings = {
        "privacy.donottrackheader.enabled" = true;
        "mail.spellcheck.inline" = true;
      };
    };
  };
}
