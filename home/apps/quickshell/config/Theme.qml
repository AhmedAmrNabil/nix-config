// Theme.qml
pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // ── Catppuccin Mocha ─────────────────────────────────────────────────

    // Accent colors
    readonly property color rosewater: "#f5e0dc"
    readonly property color flamingo: "#f2cdcd"
    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color maroon: "#eba0ac"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sky: "#89dceb"
    readonly property color sapphire: "#74c7ec"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"

    // Text
    readonly property color text: "#cdd6f4"
    readonly property color subtext1: "#bac2de"
    readonly property color subtext0: "#a6adc8"

    // Overlays
    readonly property color overlay2: "#9399b2"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay0: "#6c7086"

    // Surfaces
    readonly property color surface2: "#585b70"
    readonly property color surface1: "#45475a"
    readonly property color surface0: "#313244"

    // Base
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"

    // ── Semantic aliases ─────────────────────────────────────────────────

    readonly property color primary: sky
    readonly property color disabled: overlay2
    readonly property color textSecondary: subtext0

    // // Backgrounds
    // readonly property color bgApp: crust
    // readonly property color bgPill: base
    // readonly property color bgPopup: mantle
    // readonly property color bgButton: surface0
    // readonly property color bgButtonHovered: surface1
    // readonly property color bgButtonPressed: surface2

    // // Text
    // readonly property color textPrimary: text
    // readonly property color textSecondary: subtext1
    // readonly property color textMuted: overlay0

    // // Border
    // readonly property color borderSubtle: Qt.rgba(1, 1, 1, 0.09)
    // readonly property color borderFocus: lavender

    // // Icons
    // readonly property color iconWifi: blue
    // readonly property color iconBluetooth: mauve
    // readonly property color iconMedia: green
    // readonly property color iconWarning: yellow
    // readonly property color iconError: red
    // readonly property color iconSuccess: green
}
