/*
 * Copyright 2012 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.1
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Template {
    title: "Advanced List Items"

    Row {
        spacing: 10

        Rectangle {
            color: "#eeeeee"
            width: childrenRect.width
            height: childrenRect.height

            ListItem.Container {
                width: 250

                ListItem.Header { text: "Controls" }
                ListItem.Standard {
                    text: "Label"
                    control: Button {
                        width: 100
                        text: "click me"
                        anchors.centerIn: parent
                        onClicked: print("clicked button")
                    }
                    onClicked: control.clicked()
                }
                ListItem.Standard {
                    control: Button {
                        text: "Big control"
                        anchors.fill: parent
                    }
                }

                ListItem.Header { text: "Tabs" }
                ListItem.Base {
                    height: 145
                    Tabs {
                        height: parent.height - 20
                        width: parent.width - 20
                        anchors.centerIn: parent
                        Tab {
                            text: "Tab 1"
                            page: TextCustom {
                                anchors.centerIn: parent
                                text: "Page one"
                                color: Qt.rgba(0.4, 0.4, 0.4, 1.0)
                            }
                        }
                        Tab {
                            text: "Tab 2"
                            page: TextCustom {
                                anchors.centerIn: parent
                                text: "Page two"
                                color: Qt.rgba(0.4, 0.4, 0.4, 1.0)
                            }
                        }
                        Tab {
                            text: "Tab 3"
                            page: TextCustom {
                                anchors.centerIn: parent
                                text: "Page three"
                                color: Qt.rgba(0.4, 0.4, 0.4, 1.0)
                            }
                        }
                    }
                }
                ListItem.Header { text: "Caption" }
                ListItem.Caption {
                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit, erat ut vulputate dignissim, augue est vulputate ante, non tempus nulla est quis purus."
                }
            }
        }

        Rectangle {
            color: "#eeeeee"
            width: childrenRect.width
            height: childrenRect.height

            ListItem.Container {
                width: 250

                ListItem.Header { text: "Selectors" }
                ListItem.Selector {
                    text: "Default"
                    values: ["Value 1", "Value 2", "Value 3", "Value 4"]
                }
                ListItem.Selector {
                    text: "Disabled"
                    values: ["Value 1", "Value 2", "Value 3", "Value 4"]
                    enabled: false
                }
                ListItem.Selector {
                    text: "Expanded"
                    values: ["Value 1", "Value 2", "Value 3", "Value 4"]
                    selectedIndex: 1
                    expanded: true
                }
                ListItem.Selector {
                    text: "Icon"
                    iconSource: "avatar_contacts_list.png"
                    values: ["Value 1", "Value 2", "Value 3", "Value 4"]
                }
            }
        }
    }
}