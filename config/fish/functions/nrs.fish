function nrs --wraps='sudo nixos-rebuild switch --flake ~/dotfiles' --description 'alias nrs sudo nixos-rebuild switch --flake ~/dotfiles'
    sudo nixos-rebuild switch --flake ~/dotfiles $argv
end
