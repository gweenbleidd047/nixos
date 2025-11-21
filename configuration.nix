# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      #<home-manager/nixos>
      #./home.nix
    ];

  # Configuration options for LUKS Device
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/d284ce00-75dc-4afd-ae0d-637a737464cb";
      header = "/dev/disk/by-partuuid/84eff006-3d95-488e-8561-da576289bc82";
      allowDiscards = true; # Used if primary device is a SSD
      preLVM = true;
     };
    };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WD600BEVS-07LAT0_WD-WXC806056467"; # or "nodev" for efi only

  boot.extraModulePackages = with config.boot.kernelPackages; [ amneziawg ];

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.nameservers = [ "1.1.1.1" "8.4.4.8" ];
  services.resolved = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["ru_RU.KOI8-R/KOI8-R" "ru_RU.UTF-8/UTF-8" "ru_RU/ISO-8859-5"];
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Enable the X11 windowing system.
  services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      windowManager.i3.enable = true;
      displayManager.lightdm.enable = false;
      displayManager.startx = {
        enable = true;
        generateScript = true;
      };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.package = pkgs.zfs;
  networking.hostId = "79b88ee4";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      samsung-unified-linux-driver
      splix
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services = {
    pipewire = {
      enable = true;
        pulse.enable = true;
    };
  # picom = {
  #   enable = true;
  #   fade = true;
  #   inactiveOpacity = 0.8;
  #   activeOpacity = 0.9;
  #   shadow = true;
  #   fadeDelta = 4;
  # };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gweenbleidd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    amneziawg-go
    amneziawg-tools
    anydesk
    appimage-run
    arandr
    aria2
    ayugram-desktop
    bandwhich
    bc
    btop
    cfonts
    chromium
    cointop
    deltachat-desktop
    dive
    distrobox
    docker-compose
    fastfetch
    fd
    feh
    filezilla
    freeplane
    fzf
    gemini-cli
    gh
    git
    go
    gost
    heroic
    homebank
    i3blocks-gaps
    isd
    jitsi-meet-electron
    kmon
    krita
    libreoffice-fresh
    lolcat
    flameshot
    mangohud
    mpv
    multimarkdown
    ncdu
    netscanner
    nmap
    nomacs
    ntfs3g
    nvtopPackages.nvidia
    thunderbird
    tmux
    librewolf
    ollama
    p7zip
    protonup
    pulsemixer
    pyradio
    python313Full
    qemu_full
    qtox
    ranger
    remmina
    retroshare
    ripgrep
    rofi
    shellcheck
    speedtest
    sshuttle
    st
    tmatrix
    unrar-wrapper
    unzip
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wavemon
    wget
    wikiman
    wineWowPackages.staging
    winetricks
    wireshark
    yt-dlp
    zathura
    zip
  ];

  fonts.packages = with pkgs; [
    source-code-pro
    anonymousPro
    inconsolata
    iosevka
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
    fira-code
    fira-code-symbols
    dina-font
    dejavu_fonts
    proggyfonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.agave
    nerd-fonts.monoid
    nerd-fonts.ubuntu
    nerd-fonts.iosevka
    nerd-fonts.cousine
    nerd-fonts.mononoki
    nerd-fonts.monaspace
    nerd-fonts.liberation
    nerd-fonts.space-mono
    nerd-fonts.geist-mono
    nerd-fonts.roboto-mono
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
    nerd-fonts.sauce-code-pro
    nerd-fonts.caskaydia-cove
    ];
  fonts.fontconfig.useEmbeddedBitmaps = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };

  virtualisation.docker.daemon.settings = {
  data-root = "/home/gweenbleidd/docker";
  };

  home-manager.users.gweenbleidd = { pkgs, ... }: {
    home.packages = with pkgs; [
      neofetch
      lazygit
    ];
    programs = {
      emacs = {
        enable = true;
      };
      git = {
        enable = true;
        userName  = "gweenbleidd";
        userEmail = "gweenbleidd@example.com";
      };
      starship = {
        enable = true;
        # Configuration written to ~/.config/starship.toml
        settings = {
        # add_newline = false;

        # character = {
        #   success_symbol = "[➜](bold green)";
        #   error_symbol = "[➜](bold red)";
        # };
        # package.disabled = true;
        };
      };
    };
    home.stateVersion = "25.05";
  };

  home-manager.useGlobalPkgs = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

