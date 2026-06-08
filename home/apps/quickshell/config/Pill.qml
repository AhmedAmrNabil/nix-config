import QtQuick

QtObject {
    enum State {
        Collapsed,
        Expanded,
        Launcher
    }
    property int state: Pill.State.Collapsed
}