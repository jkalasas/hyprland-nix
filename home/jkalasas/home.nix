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
    gnumake
    lazygit
    nasm
    nodejs_21
    nodePackages.live-server
    mysql-shell
    php
    phpPackages.composer
    poetry
    python3
    openssl
    rustup

    # user
    audacity
    bottles
    cabextract
    ciscoPacketTracer8
    chromium
    corefonts
    gimp-with-plugins
    ghostscript
    libreoffice
    libresprite
    motrix
    mpv
    playonlinux
    obs-studio
    obs-studio-plugins.wlrobs
    onlyoffice-bin
    ruby
    samba
    spotdl
    telegram-desktop
    webcord-vencord-wayland
    yt-dlp
    vistafonts
    wineWowPackages.stable
    winetricks

    # misc
    archiver
    bibata-cursors
    brightnessctl
    btop
    eza
    ffmpeg
    font-manager
    fzf
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
    pomodoro
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
