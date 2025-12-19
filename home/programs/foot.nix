{config, ...}:
{
  programs.foot.enable = true;
  
  xdg.configFile."foot/foot.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/foot/foot.ini";
  };
}