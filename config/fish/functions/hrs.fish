function hrs --wraps='home-manager switch --flake ~/dotfiles' --description 'alias hrs home-manager switch --flake ~/dotfiles'
    home-manager switch --flake ~/dotfiles $argv
end
