final: prev: {
  open-scq30 = prev.open-scq30.overrideAttrs (old: {
    preFixup = (old.preFixup or "") + ''
      gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${prev.cosmic-icons}/share")
    '';
  });
}
