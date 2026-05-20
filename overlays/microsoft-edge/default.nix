self: super: {
  microsoft-edge = super.microsoft-edge.override {
    commandLineArgs = "--password-store=kwallet6 --enable-blink-features=MiddleClickAutoscroll --test-type";
  };
}