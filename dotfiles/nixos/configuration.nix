# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4"; # or btrfs/xfs depending on your actual setup
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat"; # or vfat if using UEFI boot
  };

  swapDevices = [
    { device = "/dev/nvme0n1p3"; }
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;

    device = "nodev";

    theme ="/home/aufvim/Elegant-grub2-themes/Elegant-forest-window-left-dark";
    };

  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
#sound

hardware.pulseaudio.enable = false;
services.pipewire = {
    enable = true;
    alsa.enable = true;       # ALSA backend (for legacy apps)
    pulse.enable = true;      # PulseAudio compatibility layer
    jack.enable = false;      # Enable if you use JACK apps (optional)
  };

#kernal 


 # boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      sync.enable = true;
      # Replace these IDs with your actual values from `lspci`
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  
    open = false; # Set to true if using open kernel module (try false for stability)
    nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
  };

networking.networkmanager.enable = true;
services.upower.enable = true;
hardware.enableAllFirmware = true;

hardware.opengl.extraPackages = with pkgs; [
  vaapiIntel
  vaapiVdpau
  libvdpau-va-gl
];
hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;



  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;



hardware.firmware = with pkgs; [
	linux-firmware

];
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

services.xserver.enable = true;
services.xserver.windowManager.i3.enable = true;
services.xserver.displayManager.gdm.enable = false;
services.xserver.displayManager.sddm.enable = true;
services.xserver.libinput.enable = true;
  services.desktopManager.plasma6.enable = true;
programs.hyprland.enable = true;
  services.flatpak.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
programs.zsh.enable = true;
  users.users.aufvim = {
    isNormalUser = true;
    description = "aufvim";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "audio" "sound" "video" ];
    packages = with pkgs; [
    networkmanagerapplet
	scrot
	pasystray
	zsh
	vlc
    xorg.xmodmap
    xorg.xrandr
    flatpak
];
  };

  services.logind = {
  lidSwitch = "ignore";
  lidSwitchDocked = "ignore";
  lidSwitchExternalPower = "ignore";
};


virtualisation.docker.enable = true;
virtualisation.virtualbox.host.enable = true;

users.extraGroups.vboxusers.members = [ "aufvim" ];
users.extraGroups.docker.members = [ "aufvim" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      numpy
      pandas
      cairosvg
      requests
    ]))
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
ly
git
hyprland
wayland
wayland-protocols
xwayland
wlroots
wayland-utils
wl-clipboard
foot
powertop
gcc
    gnumake
    cmake
    pkg-config
    python3
    nodejs
    rustup
    go
    docker
 pipewire
    pavucontrol        # PulseAudio volume control GUI (works with PipeWire Pulse)
    wireplumber        # Recommended PipeWire session manager
neovim
vscode
haruna
polybar
curl
i3
btop
yazi
bottles
ffmpegthumbnailer
  poppler_utils       # For PDFs
  jq
  bat
  ueberzugpp

xclip
killall
gettext
python313Packages.pip
superfile
avahi
htop
feh 
wlr-randr
arandr
gamemode
mangohud
lutris
    wineWowPackages.stable
    winetricks

autorandr
qbittorrent
pasystray
python314
zsh
i3status
dmenu
firefox
kitty  
 wget
 pciutils
 mesa-demos
 vulkan-tools
 neofetch
 xterm
 rofi-wayland
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
