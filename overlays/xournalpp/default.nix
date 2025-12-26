self: super: {
  xournalpp = super.xournalpp.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      cp ${./pagetemplates.ini} $out/share/xournalpp/ui/pagetemplates.ini
    '';
  });
}
