self: super: {
  xournalpp = super.xournalpp.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      cp ${../config/xournalpp/pagetemplates.ini} $out/share/xournalpp/ui/pagetemplates.ini
    '';
  });
}
