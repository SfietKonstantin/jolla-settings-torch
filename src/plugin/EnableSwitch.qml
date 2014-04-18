import QtQuick 2.0
import Sailfish.Silica 1.0
import org.SfietKonstantin.settings.torch 1.0

Switch {
    id: torchControlSwitch
    property string entryPath

    icon.source: "image://theme/icon-m-ambience"
    checked: torchControl.enabled
    automaticCheck: false
    onClicked: {
        if (torchControl.enabled) {
            torchControl.disable()
        } else {
            torchControl.enable()
        }
    }

    TorchControl {
        id: torchControl
    }
}
