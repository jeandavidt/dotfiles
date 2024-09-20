{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim

        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      security.pam.enableSudoTouchIdAuth = true;
      
      system.defaults = {
      dock.autohide = true;
      finder.ShowPathbar = true;
      finder.ShowStatusBar = true;
      finder.AppleShowAllExtensions = true;
      screencapture.location = "/Pictures/Screenshots";
      finder.FXPreferredViewStyle = "Nlsv";
      # default Finder list item size large
      };
      homebrew.enable = true;
      homebrew.onActivation.autoUpdate = true;
      homebrew.onActivation.cleanup = "uninstall";
      homebrew.brews = [
        "neovim"
        "cava"
        "cowsay"
        "ffmpeg"
        "fzf"
        "gcc"
        "imagemagick"
        "juliaup"
        "lazygit"
        "luajit"
        "powerlevel10k"
        "pyenv"
        "pyenv-virtualenv"
        "python3"
        "r"
        "ripgrep"
        "rustup"
        "sqlite"
        "stow"
        "texlab"
        "tmux"
        "tree"
        "unixodbc"
        "zoxide"
      ];
      homebrew.casks = [
        "1password"
        "1password-cli"
        "font-jetbrains-mono-nerd-font"
        "raycast"
        "slack"
        "wezterm"
        "zoom"
        "zotero"
        "arc"
        "notion"
        "notion-calendar"
        "whatsapp"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "microsoft-office"
        "appcleaner"
        "nordvpn"
        "microsoft-office"
        "visual-studio-code"
        "chatgpt"
        "rectangle-pro"
        "vanilla"
        "transmission"
        "cleanupbuddy"

      ];
      homebrew.masApps = {
         "Adobe Lightroom" = 1451544217;
        "Elmedia Video Player" = 1044549675;
        "Day One" = 1055511498;
        "Kindle" = 302584613;
        "Flow" = 1423210932;
        "Amphetamine" = 937984704;
      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#JDsMac
    darwinConfigurations."JDsMac" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."JDsMac".pkgs;
  };
}
