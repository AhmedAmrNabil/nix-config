import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls

Rectangle {
    id: root
    width: 500
    height: 300 
    color: "transparent"

    // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
            // Release keyboard focus
            WlrLayershell.keyboardFocus = WlrKeyboardFocus.None;

            // Change your state 
            ViewState.activeView = ViewState.Views.ViewDefault;

            event.accepted = true;
        }
    }
    TextField {
        id: textField
        anchors.centerIn: parent
        width: parent.width * 0.8
        placeholderText: "Type here..."
        focus: WlrLayershell.keyboardFocus === WlrKeyboardFocus.Exclusive
        onFocusChanged: {
            if (focus) {
                WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
            } else {
                WlrLayershell.keyboardFocus = WlrKeyboardFocus.None;
            }
        }
    }
}
