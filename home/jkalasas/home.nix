{ configs, hyprland, pkgs, ... }:
let
  webcord-vencord-wayland = pkgs.symlinkJoin {
    name = "webcord-vencord";
    paths = [ pkgs.webcord-vencord ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/webcord --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };
in
{
  imports = [
    hyprland.homeManagerModules.default
    ./programs
    ./scripts
    ./themes
  ];

  home = {
    username = "jkalasas";
    homeDirectory = "/home/jkalasas";
  };

  home.packages = (with pkgs; [
    # dev stuff
    corepack_21
    lazygit
    nodejs_21
    python3
    python311Packages.pip
    openssl
    rustup

    # user
    gimp-with-plugins
    libresprite
    mpv
    onlyoffice-bin
    spotdl
    telegram-desktop
    webcord-vencord-wayland
    yt-dlp

    # misc
    archiver
    bibata-cursors
    brightnessctl
    btop
    eza
    ffmpeg
    font-manager
    grim
    grimblast
    networkmanagerapplet
    pfetch
    tty-clock
    unrar
    unzip
    tokyo-night-gtk
    wl-clipboard
    xwaylandvideobridge
  ]) ++ (with pkgs.gnome; [
    file-roller
    zenity
    gnome-tweaks
    eog
  ]);

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Macchiato-Compact-Lavender-Dark";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
