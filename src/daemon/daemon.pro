TEMPLATE = app
TARGET = torchd

QT = core dbus
CONFIG += link_pkgconfig
PKGCONFIG += gstreamer-0.10

# DBus
system(qdbusxml2cpp dbus/org.SfietKonstantin.torchd.xml -i torchdobject.h -a adaptor)

HEADERS += torchdobject.h \
    adaptor.h

SOURCES += main.cpp \
    adaptor.cpp \
    torchdobject.cpp

OTHER_FILES += dbus/org.SfietKonstantin.torchd.xml \
    dbus/org.SfietKonstantin.torchd.service

target.path = /usr/bin
INSTALLS += target

# DBus service
dbusService.files = dbus/org.SfietKonstantin.torchd.service
dbusService.path = /usr/share/dbus-1/services/
INSTALLS += dbusService
