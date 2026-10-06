{
  lib,
  stdenvNoCC,
  stdenvAdapters,
  fetchurl,
  fetchgit,
  fetchFromGitHub,
  git,
  runCommand,
  llvmPackages_19,
  gcc,
  bc,
  bison,
  flex,
  perl,
  python3,
  cpio,
  kmod,
  zip,
  unzip,
  pkg-config,
  which,
  openssl,
  elfutils,
  zlib,
  writableTmpDirAsHomeHook,

  romType ? "aosp",
  withRoot ? true,
  rootSolution ? "resukisu",
  withSusfs ? true,

  buildDate ? "2025-10-06",
  author ? "btngana",
  localVersion ? "-${author}-qgki",
  buildUser ? "btngana",
  buildHost ? "nixos",
}:

let
  llvmPackages = llvmPackages_19;

  # nixpkgs' clang cc-wrapper (add-clang-cc-cflags-before.sh) injects the host
  # machineFlags into `extraBefore` whenever `NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING`
  # is set, even when the caller passes an explicit `--target`. On x86_64 hosts
  # with clang >= 19 this includes `-mtls-dialect=gnu2`, which clang rejects for
  # the aarch64 cross target the kernel build uses (CLANG_TRIPLE=aarch64-linux-gnu-),
  # breaking the whole kernel build with:
  #   clang: error: unsupported option '-mtls-dialect=' for target 'aarch64-...'
  # Patch the wrapper so machineFlags are only added when no `--target` is passed,
  # which is the intended behavior. Using `--replace` (not `--replace-fail`) keeps
  # this forward-compatible if upstream restructures the script.
  # see https://github.com/xddxdd/nix-kernelsu-builder/blob/main/pipeline/build-kernel-clang.nix#L64
  fixedCC = llvmPackages.stdenv.cc.overrideAttrs (
    final: prev: {
      postFixup = (prev.postFixup or "") + ''
        substituteInPlace $out/nix-support/add-local-cc-cflags-before.sh \
          --replace-warn 'elif [[ $0 != *cpp ]]; then' 'elif ! $targetPassed && [[ $0 != *cpp ]]; then'
      '';
    }
  );

  fixedStdenv = stdenvAdapters.overrideCC llvmPackages.stdenv fixedCC;

  targetBranch =
    if !withRoot then
      (if romType == "oneui" then "main" else "aosp")
    else
      lib.concatStringsSep "-" ([ rootSolution ] ++ lib.optional withSusfs "susfs" ++ [ romType ]);

  branchHashes = {
    aosp = "sha256-Uy0v8fDVOhtQW7gP705T84YWJFTDRC6WNAj6zMt48RQ=";
    resukisu-aosp = "sha256-P32UD4fsL02e47Bx/dU6IO/x5C+/D4ccL2L2rAi4N+4=";
    ksu-next-aosp = "sha256-Ynp+qb2tsK6Jdc9LkNk7zIVDyzySOoZrjJnSPJQjNPI=";
    resukisu-susfs-aosp = "sha256-2Xjyw7u9hNSUPZaTI8C3dZ6+jn1pOkS/HC94/z0by7o=";
    ksu-next-susfs-aosp = "sha256-zWmJoJaeiYheLS4lSzYGW8nqpYiytDsdhMKr9j5P6I8=";

    main = "sha256-juTzS21vv/kEBojhskYgGrpAqe9/25rsFCc/pnm3wxE="; # oneui
    resukisu-oneui = "sha256-DJMsXVWLXM4QrzVnjbwZG8PM9F2cNuvifHbmYpqMjXM=";
    ksu-next-oneui = "sha256-qaz994u73N9Bmnn58I8CkkOEhIIj1I3PZaSQpzQTTu8=";
    resukisu-susfs-oneui = "sha256-FGM7tjsZ084G6hbfJ/68gWcvq+zhqKfv0spP9CM+NOc=";
    ksu-next-susfs-oneui = "sha256-u0dx4KWbY2ASmCREyh2Tx/jxtIYe8cugukdGC/80PD4=";
  };

  src = fetchFromGitHub {
    owner = "bone-machine";
    repo = "android_kernel_samsung_sm7325_a52s_5g";
    rev = targetBranch; # or a specific commit hash
    hash = branchHashes.${targetBranch};
  };

  rootConfig =
    {
      resukisu = {
        url = "https://github.com/Baka-SU/BakaSU.git";
        rev = "f1dd81dc96d7f3f6691e6ac8b50fba9ae8a2f17c";
        submoduleDir = "KernelSU";
        displayName = "ReSukiSU";
        hash = "sha256-+zVGawLN/1fbWRrpuPO1Uw3S94DtrzDdJxs2Nr4ce8c=";
      };
      ksu-next = {
        url = "https://github.com/KernelSU-Next/KernelSU-Next.git";
        rev = "9b08e88862000d5c50fb2e43a5b75123cf472e54";
        submoduleDir = "KernelSU-Next";
        displayName = "KernelSU-Next";
        hash = "sha256-qXcvBnfEn7vgy3UP6yxZetLots9MWUabxz5uA1hu6Fg=";
      };
    }
    .${rootSolution};

  # Fetch ReSukiSU directly with full git history and .git folder intact
  rootSrc =
    if !withRoot then
      null
    else
      fetchgit {
        url = rootConfig.url;
        rev = rootConfig.rev;
        hash = rootConfig.hash;
        leaveDotGit = true;
        deepClone = true;
      };

  # ── Tools the old script downloaded at runtime, now fixed-output fetches ────
  magiskVersion = "30.7";
  magiskArch =
    {
      x86_64 = "x86_64";
      aarch64 = "arm64-v8a";
    }
    .${stdenvNoCC.hostPlatform.parsed.cpu.name};

  magiskboot = stdenvNoCC.mkDerivation {
    pname = "magiskboot";
    version = magiskVersion;
    src = fetchurl {
      url = "https://github.com/topjohnwu/Magisk/releases/download/v${magiskVersion}/Magisk-v${magiskVersion}.apk";
      hash = "sha256-4NMtISNTKGD5cSPZJ7G7hsTgjm/YpIv8a1vuCvrp69U="; # first build prints the real hash; paste it here
    };
    nativeBuildInputs = [ unzip ];
    dontUnpack = true;
    dontFixup = true; # prebuilt static binary: don't strip/patch it
    installPhase = ''
      unzip -j $src lib/${magiskArch}/libmagiskboot.so -d .
      install -Dm755 libmagiskboot.so $out/bin/magiskboot
    '';
    meta.platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  # Pinned to an AOSP tag instead of refs/heads/main so the hash is stable.
  avbRef = "android-14.0.0_r1";
  avbtool =
    runCommand "avbtool"
      {
        nativeBuildInputs = [ python3 ];
        src = fetchurl {
          name = "avbtool.py.b64";
          url = "https://android.googlesource.com/platform/external/avb/+/refs/tags/${avbRef}/avbtool.py?format=TEXT";
          hash = "sha256-/mxsFofsz+HZPJmkcQjKVRXl6kgX2+uI1yaEW1zIiGo="; # first build prints the real hash; paste it here
        };
      }
      ''
        mkdir -p $out/bin
        base64 -d $src > $out/bin/avbtool   # googlesource ?format=TEXT is base64
        chmod +x $out/bin/avbtool
        patchShebangs $out/bin/avbtool
        python3 -c "import ast; ast.parse(open('$out/bin/avbtool').read())"
        grep -q "def erase_footer" $out/bin/avbtool
      '';

  # ── Variant-derived values (same logic as the old branch-name case blocks) ──
  romDir = romType;
  romTag = if romType == "oneui" then "One-UI" else "AOSP";
  romDisplay = if romType == "oneui" then "One UI" else "AOSP";

  rootName = if withRoot then rootConfig.displayName else "none";
  rootSubmodule = if withRoot then rootConfig.submoduleDir else "";
  rootDisplay = if !withRoot then "none" else "${rootName}" + lib.optionalString withSusfs " + SUSFS";
in

assert lib.assertOneOf "romType" romType [
  "oneui"
  "aosp"
];
assert lib.assertOneOf "rootSolution" rootSolution [
  "none"
  "ksu-next"
  "resukisu"
];

assert lib.assertMsg (
  withRoot -> rootSolution != "none"
) "withRoot = true requires rootSolution to be one of: ksu-next, resukisu";

assert lib.assertMsg (!withRoot -> rootSolution == "none")
  "rootSolution = \"${rootSolution}\" requires withRoot = true (otherwise rootSolution must be \"none\")";

fixedStdenv.mkDerivation {
  pname = "a52sxq-kernel";
  version = buildDate;
  inherit src;

  nativeBuildInputs = [
    git
    magiskboot
    avbtool
    llvmPackages.lld
    llvmPackages.llvm
    gcc
    bc
    bison
    flex
    perl
    python3
    cpio
    kmod
    zip
    pkg-config
    which
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    openssl
    elfutils
    zlib
  ];

  hardeningDisable = [ "all" ];
  dontConfigure = true;
  dontFixup = true;

  env = {
    NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = "1";
    KERNEL_LOCALVERSION = localVersion;
    ROM_DIR = romDir;
    ROM_TYPE = romTag;
    ROM_DISPLAY = romDisplay;
    ROOT_DISPLAY = rootDisplay;
    ROOT_SUBMODULE = rootSubmodule;
    BUILD_DATE = buildDate;
    DEFCONFIG = "vendor/a52sxq_kor_single_defconfig";
    KBUILD_BUILD_USER = buildUser;
    KBUILD_BUILD_HOST = buildHost;
  };

  buildPhase = ''
    #bash
    runHook preBuild

    die() { echo "ERR: $*" >&2; exit 1; }
    srcroot_dir=$PWD

    # The sandbox has /bin/sh but no /bin/bash; Samsung's Kbuild files hardcode it.
    bash_path=$(command -v bash)
    { grep -rlIZ --include='Makefile*' --include='Kbuild*' --include='*.mk' '/bin/bash' . || true; } \
      | xargs -0 -r sed -i "s|/bin/bash|$bash_path|g"
    patchShebangs scripts security

    # ── Pre-flight ──────────────────────────────────────────────────────────
    base=toolchain/baseimages/$ROM_DIR
    template=toolchain/template-zip-file
    update_binary=$template/META-INF/com/google/android/update-binary

    # check missing base images and defconfig
    for f in "$base/boot.img" "$base/vendor_boot.img" "$update_binary" \
            "arch/arm64/configs/$DEFCONFIG"; do
      [ -f "$f" ] || die "missing file: $f"
    done

    # check missing touch screen firmware
    ls firmware/tsp_stm/fts5cu56a_a52sxq* >/dev/null 2>&1 \
      || die "TSP firmware not found in firmware/tsp_stm"

    for p in @ROM_DISPLAY@ @ROOT_DISPLAY@ @BUILD_DATE@; do
      grep -q "$p" "$update_binary" || die "placeholder $p missing from update-binary"
    done

    # Put the fetched root source where the submodule used to be
    git config --global safe.directory "*"
    if [ -n "$ROOT_SUBMODULE" ]; then
      rm -rf "$ROOT_SUBMODULE"
      cp -r --no-preserve=mode "${rootSrc}" "$ROOT_SUBMODULE"
      [ -e drivers/kernelsu/Kbuild ] || die "drivers/kernelsu does not resolve to $ROOT_SUBMODULE/kernel"
      ( cd "$ROOT_SUBMODULE" && git reset --hard HEAD 2>/dev/null || true )
    fi

    # ── Working copies of the base images ───────────────────────────────────
    work=$(mktemp -d)
    mkdir -p "$work/boot" "$work/vboot" "$work/zip/images"
    cp "$base/boot.img"        "$work/boot/boot.img"
    cp "$base/vendor_boot.img" "$work/vboot/vendor_boot.img"
    chmod -R u+w "$work"

    # exits non-zero when there is no footer - that's fine
    avbtool erase_footer --image "$work/boot/boot.img"        2>/dev/null || true
    avbtool erase_footer --image "$work/vboot/vendor_boot.img" 2>/dev/null || true

    # Validate that boot.img matches the selected ROM type
    ( cd "$work/boot"
      unpack_out=$(magiskboot unpack boot.img 2>&1 || true)
      rm -f kernel ramdisk.cpio
      if [ "$ROM_TYPE" = "One-UI" ]; then
        grep -q SAMSUNG_SEANDROID <<< "$unpack_out" \
          || die "boot.img is not a One UI image (SAMSUNG_SEANDROID not found)"
      else
        ! grep -q SAMSUNG_SEANDROID <<< "$unpack_out" \
          || die "boot.img looks like One UI but romType is aosp"
      fi
    )

    # ── Kernel ──────────────────────────────────────────────────────────────
    export KBUILD_BUILD_TIMESTAMP="$(date -u -d "@$SOURCE_DATE_EPOCH")"

    out_dir=$PWD/out
    kflags="-C $PWD O=$out_dir ARCH=arm64 CC=clang HOSTCC=gcc HOSTCXX=g++ LLVM=1 LLVM_IAS=1 GIT_BIN=git CROSS_COMPILE=aarch64-linux-gnu- KBUILD_BUILD_USER=$KBUILD_BUILD_USER KBUILD_BUILD_HOST=$KBUILD_BUILD_HOST CONFIG_SECTION_MISMATCH_WARN_ONLY=y"

    ./scripts/config --file "arch/arm64/configs/$DEFCONFIG" --set-str CONFIG_LOCALVERSION "$KERNEL_LOCALVERSION"

    make $kflags "$DEFCONFIG"
    # no tty in the sandbox: take defaults for any symbol the defconfig doesn't set
    make $kflags olddefconfig
    make $kflags -j"$NIX_BUILD_CORES"

    # ── Modules ─────────────────────────────────────────────────────────────
    modstage=$out_dir/modules_staging
    mkdir -p "$modstage"
    make $kflags STRIP="$(command -v llvm-strip)" \
      INSTALL_MOD_PATH="$modstage" INSTALL_MOD_STRIP=1 modules_install

    moddirs=$(find "$modstage/lib/modules" -mindepth 1 -maxdepth 1 -type d)
    [ "$(printf '%s\n' "$moddirs" | wc -l)" -eq 1 ] || die "expected exactly one module dir"
    kver=$(basename "$moddirs")
    [ "$(find "$moddirs" -name '*.ko' | wc -l)" -gt 0 ] || die "no kernel modules built"

    dups=$(find "$moddirs" -name '*.ko' -printf '%f\n' | sort | uniq -d)
    [ -z "$dups" ] || die "duplicate module filenames: $dups"

    flat=$out_dir/flat_modules
    flatver=$flat/lib/modules/$kver
    mkdir -p "$flatver"
    find "$moddirs" -name '*.ko' -exec cp {} "$flatver/" \;

    depmod -b "$flat" -F "$out_dir/System.map" "$kver"

    # device expects flat /lib/modules/foo.ko paths
    for f in "$flatver"/modules.*; do
      [ -f "$f" ] || continue
      sed -E -i 's@(^| )([^ /][^ ]*\.ko)@\1/lib/modules/\2@g' "$f"
    done
    ( cd "$flatver" && find . -maxdepth 1 -name '*.ko' -printf '%f\n' | sort > modules.load )

    kimage=$out_dir/arch/arm64/boot/Image
    [ -f "$kimage" ] || die "kernel Image missing"

    # ── boot.img ────────────────────────────────────────────────────────────
    ( cd "$work/boot"
      rm -f kernel ramdisk.cpio new-boot.img
      magiskboot unpack boot.img
      cp "$kimage" kernel
      magiskboot repack boot.img
      cp new-boot.img "$work/zip/images/boot.img"
    )

    # ── dtbo.img ────────────────────────────────────────────────────────────
    cp "$out_dir/arch/arm64/boot/dtbo.img" "$work/zip/images/dtbo.img"

    # ── vendor_boot.img ─────────────────────────────────────────────────────
    ( cd "$work/vboot"
      rm -rf dtb header ramdisk.cpio new-boot.img ramdisk
      # magiskboot exits 3 on a successful vendor_boot unpack
      ret=0
      magiskboot unpack -h vendor_boot.img || ret=$?
      [ "$ret" -eq 0 ] || [ "$ret" -eq 3 ] || die "magiskboot unpack vendor_boot failed ($ret)"

      cp "$out_dir/arch/arm64/boot/dts/vendor/qcom/yupik.dtb" dtb
      sed -i 's/^name=.*/name=SRPUE26A001/' header

      mkdir ramdisk
      ( cd ramdisk
        cpio -idmu < ../ramdisk.cpio

        mkdir -p lib/modules
        rm -f lib/modules/*.ko \
              lib/modules/modules.alias lib/modules/modules.dep \
              lib/modules/modules.load  lib/modules/modules.softdep
        find lib/modules -maxdepth 1 -type d -name '*-gki' \
          -exec find {} -mindepth 1 -delete \;

        find "$moddirs" -name '*.ko' -exec cp -t lib/modules/ {} +
        for m in dep alias softdep load; do
          cp "$flatver/modules.$m" lib/modules/
        done

        mkdir -p lib/firmware/tsp_stm
        cp "$srcroot_dir"/firmware/tsp_stm/fts5cu56a_a52sxq* lib/firmware/tsp_stm/

        find . -type d -exec chmod 755 '{}' \;
        find . -type f -exec chmod 644 '{}' \;
        find . -mindepth 1 -print0 \
          | cpio --null -o -H newc --owner root:root > ../ramdisk.cpio
      )
      rm -rf ramdisk
      magiskboot repack vendor_boot.img
      cp new-boot.img "$work/zip/images/vendor_boot.img"
    )

    # ── Flashable zip ───────────────────────────────────────────────────────
    for img in boot vendor_boot dtbo; do
      [ -f "$work/zip/images/$img.img" ] || die "missing $img.img in zip staging"
    done

    cp -r "$template/META-INF" "$work/zip/META-INF"
    chmod -R u+w "$work/zip"
    sed -i \
      -e "s|@ROM_DISPLAY@|$ROM_DISPLAY|g" \
      -e "s|@ROOT_DISPLAY@|$ROOT_DISPLAY|g" \
      -e "s|@BUILD_DATE@|$BUILD_DATE|g" \
      "$work/zip/META-INF/com/google/android/update-binary"

    find "$work/zip" -exec touch -h -d "@$SOURCE_DATE_EPOCH" {} +
    zipout=$PWD/kernel.zip
    ( cd "$work/zip" && zip -X -r -9 "$zipout" META-INF images )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 kernel.zip $out/kernel.zip
    runHook postInstall
  '';

  passthru = { inherit magiskboot avbtool; };

  meta = {
    description = "Flashable kernel zip (${romDisplay}, root: ${rootDisplay}) for the Galaxy A52s 5G";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
