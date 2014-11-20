import QtQuick 2.0
import Sailfish.Silica 1.0
import com.jolla.settings 1.0
import org.SfietKonstantin.settings.torch 1.0

Page {
    id: root

    Column {
        anchors {
            left: parent.left
            right: parent.right
        }

        PageHeader {
            title: qsTrId("settings-torch-torch")
        }

        ListItem {
            id: enableItem

            contentHeight: torchSwitch.height
            showMenuOnPressAndHold: false
            menu: Component { FavoriteMenu {} }

            TextSwitch {
                id: torchSwitch

                property string entryPath: "system_settings/look_and_feel/torch/enable_switch"
                rightMargin: Theme.paddingMedium + torchIcon.width + Theme.paddingLarge
                checked: torchControl.enabled
                automaticCheck: false
                highlighted: down || enableItem.menuOpen
                text: qsTrId("settings-torch-torch")
                onClicked: {
                    if (torchControl.enabled) {
                        torchControl.disable()
                    } else {
                        torchControl.enable()
                    }
                }

                onPressAndHold: enableItem.showMenu({settingEntryPath: entryPath,
                                                     isFavorite: favorites.isFavorite(entryPath)})
            }
            Image {
                id: torchIcon
                anchors {
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }
                source: "image://theme/icon-m-ambience?"
                        + (torchSwitch.highlighted ? Theme.highlightColor : Theme.primaryColor)
            }
        }
    }

    TorchControl {
        id: torchControl
    }
}
