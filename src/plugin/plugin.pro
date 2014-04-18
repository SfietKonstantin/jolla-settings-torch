TEMPLATE = lib
TARGET = torchqml
TARGET = $$qtLibraryTarget($$TARGET)


MODULENAME = org/SfietKonstantin/settings/torch
TARGETPATH = $$[QT_INSTALL_QML]/$$MODULENAME

QT += core dbus qml
CONFIG += plugin

# DBus
system(qdbusxml2cpp ../daemon/dbus/org.SfietKonstantin.torchd.xml -p proxy)

HEADERS += torchcontrol.h \
    proxy.h

SOURCES += plugin.cpp \
    torchcontrol.cpp \
    proxy.cpp

OTHER_FILES += qmldir *.qml *.json qmldir *.js

import.files = qmldir
import.path = $$TARGETPATH
target.path = $$TARGETPATH

qmlpages.path = /usr/share/jolla-settings/pages/torch
qmlpages.files = *.qml *.js

plugin_entry.path = /usr/share/jolla-settings/entries
plugin_entry.files = torch.json

INSTALLS += target import plugin_entry qmlpages
