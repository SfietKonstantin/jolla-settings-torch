import QtQuick 2.0
import Sailfish.Silica 1.0
import org.SfietKonstantin.settings.torch 1.0

Image {
    enabled: torchControl.enabled
    source: "image://theme/icon-l-power?" + (enabled ? Theme.highlightColor : Theme.primaryColor)
    opacity: enabled ? 1.0 : 0.4
    fillMode: Image.PreserveAspectFit
    smooth: true

    TorchControl {
        id: torchControl
    }
}
