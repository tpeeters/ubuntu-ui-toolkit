QT += platformsupport-private

CONFIG += custom_qpa   # needed by test to set device pixel ratio correctly
include(../../test-include.pri)
SOURCES += tst_units_scale.cpp
