/*
 * Copyright (C) 2015 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Styles 1.3

BottomEdgeStyle {
    //setup properties
    property BottomEdge bottomEdge: styledItem
    panel: panelItem
    contentItem: loader.item
    panelAnimation: panelBehavior
    revealThreshold: bottomEdge.hint.height + units.gu(2)

    // own styling properties
    property color backgroundColor: "transparent"
    property color panelColor: theme.palette.normal.background
    property color shadowColor: theme.palette.selected.background
    property bool attachHintToContent: false

    anchors {
        // break the fill from BottomEdge, StyledItem automatically fills that
//        fill: undefined
        bottom: parent.bottom
    }
    width: parent.width
    height: parent.height

    Rectangle {
        id: background
        anchors.fill: parent
        color: backgroundColor
        z: -1
    }

    states: State {
        name: "reparentedHint"
        when: attachHintToContent
        AnchorChanges {
            target: bottomEdge.hint
            anchors.bottom: panelItem.top
        }
    }

    // unlock/lock panel also when commit/collapse is called manually
    Connections {
        target: bottomEdge
        onCommitStarted: panelItem.swipedAboveHint = true
        onCollapseCompleted: panelItem.swipedAboveHint = false
    }

    Rectangle {
        id: panelItem
        objectName: "bottomedge_panel"
        property bool swipedAboveHint: false
        property bool unlocked: (bottomEdge.state > BottomEdge.Hidden)
                                || swipedAboveHint
        anchors {
            left: parent.left
            right: parent.right
            top: unlocked ? undefined : parent.bottom
        }
        height: loader.item ? loader.item.height : 0
        y: bottomEdge.height
        color: panelColor
        opacity: y < bottomEdge.height ? 1.0 : 0.0

        Behavior on y { UbuntuNumberAnimation { id: panelBehavior } }

        state: {
            switch (bottomEdge.state) {
            case BottomEdge.Revealed: return "Revealed"
            case BottomEdge.Committed: return "Committed"
            default: return ""
            }
        }

        states: [
            State {
                name: "Revealed"
                PropertyChanges {
                    target: bottomEdge.hint
                    status: BottomEdgeHint.Locked
                }
            },
            State {
                name: "Committed"
                PropertyChanges {
                    target: bottomEdge.hint
                    status: BottomEdgeHint.Locked
                }
            }
        ]

        // shadows
        Rectangle {
            id: topShadow
            anchors {
                bottom: parent.top
                left: parent.left
                right: parent.right
            }
            height: units.gu(1)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(shadowColor.r, shadowColor.g, shadowColor.b, 0.0) }
                GradientStop { position: 1.0; color: Qt.rgba(shadowColor.r, shadowColor.g, shadowColor.b, 0.3) }
            }
        }
        Rectangle {
            id: bottomShadow
            anchors {
                top: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: units.gu(1)
            rotation: 180
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(shadowColor.r, shadowColor.g, shadowColor.b, 0.0) }
                GradientStop { position: 1.0; color: Qt.rgba(shadowColor.r, shadowColor.g, shadowColor.b, 0.3) }
            }
        }

        // content
        Loader {
            id: loader
            anchors.horizontalCenter: parent.horizontalCenter
            asynchronous: true
            source: bottomEdge.state > BottomEdge.Hidden ? bottomEdge.content : ""
            sourceComponent: bottomEdge.state > BottomEdge.Hidden ? bottomEdge.contentComponent : null
            onItemChanged: {
                if (item) {
                    item.parent = panelItem;
                    item.anchors.horizontalCenter = panelItem.horizontalCenter;
                }
            }
        }

        Connections {
            target: bottomEdge
            onDragProgressChanged: {
                panelItem.y = bottomEdge.height * (1.0 - dragProgress);
            }
        }
    }
}
