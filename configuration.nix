# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-f2cba837-8b27-42d4-8afc-1026a93f6ebb".device = "/dev/disk/by-uuid/f2cba837-8b27-42d4-8afc-1026a93f6ebb";
  boot.initrd.luks.devices."luks-f2cba837-8b27-42d4-8afc-1026a93f6ebb".keyFile = "/crypto_keyfile.bin";

  # Enable zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.

  networking.firewall.allowedTCPPorts = [ 57621 ]; # Opens port for spotify local discovery
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Environment Variables
  
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {

    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable the X11 windowing system.
#  services.xserver = {
#    enable = true;
#    desktopManager = {
#      xterm.enable = false;
#      xfce.enable = true;
#    };
#    displayManager.defaultSession = "xfce";
#  };

  # Enable the KDE Plasma Desktop Environment.
   services.xserver.enable = true;
   services.xserver.displayManager.sddm.enable = true;
   services.xserver.desktopManager.plasma5.enable = true;
#   services.xserver.displayManager.defaultSession = "plasmawayland";

  # Enable Proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fatman9000 = {
    isNormalUser = true;
    description = "Fatman9000";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gnumake
    pkgs.discord
    pkgs.steam
    pkgs.kitty
    pkgs.keepassxc
    pkgs.joshuto
    pkgs.heroic
    pkgs.lutris
    pkgs.chezmoi
    pkgs.spotify	
    vscodium.fhs
    pkgs.xfce.xfce4-whiskermenu-plugin
    pkgs.xfce.xfce4-pulseaudio-plugin    
    pkgs.pavucontrol    
    #pkgs.nvidia-vaapi-driver
    pkgs.ani-cli
    pkgs.openjdk
    pkgs.gparted
    pkgs.ventoy
    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks
 #   nvidia-utils
 #   lib32-nvidia-utils
 #   mesa-utils
 #   vkd3d
 #   lib32-vkd3d
 #   vulkan-icd-loader
 #   lib32-vulkan-icd-loader    
];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};

programs.neovim.enable = true;
programs.neovim.defaultEditor = true;

#List services that you want to enable:

services.i2pd.enable = true;

#location.latitude = 35.0;
#location.longitude = 78.0;
#
#services.redshift = {
#    enable = true;
#    brightness = {
      # Note the string values below.
#      day = "1";
#      night = "1";
#    };
#    temperature = {
#      day = 5500;
#      night = 3700;
#    };
#  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
