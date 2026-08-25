final: prev: {
  prismlauncher-9 = prev.prismlauncher-9.override {
    jdks = [
      prev.jdk17
      prev.jdk25
    ];
  };
}
