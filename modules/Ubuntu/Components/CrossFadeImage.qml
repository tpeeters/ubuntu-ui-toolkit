/*
 * Copyright (C) 2013 Canonical, Ltd.
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

import QtQuick 2.0
/*!
   \qmltype CrossFadeImage
   \ingroup ubuntu
   \brief An Image like component which smoothly fades when its source is updated.

   \qml
        import QtQuick 2.0
        import Ubuntu.Components 0.1

        CrossFadeImage {
            width: units.gu(100)
            height: units.gu(75)
            source: "http://design.ubuntu.com/wp-content/uploads/ubuntu-logo14.png"
            fadeDuration: 1000
            MouseArea {
                anchors.fill: parent
                onClicked: parent.source = "http://design.ubuntu.com/wp-content/uploads/canonical-logo1.png"
            }
        }
    \endqml
    */

Item {
    id: root

    /*!
      The image being displayed. Can be a URL to any image format supported by Qt.
     */
    property url source

    /*!
      \qmlproperty enumeration fillMode

      Set this property to define what happens when the source image has a different size than the item.

      Defaults to \c Image.PreserveAspectFit.

      \list
        \li Image.Stretch - the image is scaled to fit
        \li Image.PreserveAspectFit - the image is scaled uniformly to fit without cropping
        \li Image.PreserveAspectCrop - the image is scaled uniformly to fill, cropping if necessary
        \li Image.Tile - the image is duplicated horizontally and vertically
        \li Image.TileVertically - the image is stretched horizontally and tiled vertically
        \li Image.TileHorizontally - the image is stretched vertically and tiled horizontally
        \li Image.Pad - the image is not transformed
      \endlist
    */
    property int fillMode : Image.PreserveAspectFit

    /*!
      The time over which to fade between images. Defaults to \c UbuntuAnimation.FastDuration.
      \sa UbuntuAnimation
    */
    property int duration: 250 // FIXME: UbuntuAnimation.FastDuration is what we want but it doesn't get set...

    /*!
      Whether the animation is running
    */
    readonly property bool running: nextImageFadeIn.running

    /*!
      The actual width and height of the loaded image
    */
    readonly property size sourceSize: internals.currentImage.sourceSize

    /*!
      \qmlproperty enumeration status

      This property holds the status of image loading. It can be one of:

      \list
        \li Image.Null - no image has been set
        \li Image.Ready - the image has been loaded
        \li Image.Loading - the image is currently being loaded
        \li Image.Error - an error occurred while loading the image
      \endlist
    */
    readonly property int status: internals.currentImage ? internals.currentImage.status : Image.Null

    QtObject {
        id: internals

        /*! \internal
          Defines the image currently being shown
        */
        property Image currentImage: image1
        /*! \internal
          Defines the image being changed to
        */
        property Image nextImage: image2

        function swapImages() {
            internals.currentImage.z = 0;
            internals.nextImage.z = 1;
            nextImageFadeIn.start();

            var tmpImage = internals.currentImage;
            internals.currentImage = internals.nextImage;
            internals.nextImage = tmpImage;
        }
    }

    Image {
        id: image1
        anchors.fill: parent
        cache: false
        asynchronous: true
        fillMode: parent.fillMode
        z: 1
    }

    Image {
        id: image2
        anchors.fill: parent
        cache: false
        asynchronous: true
        fillMode: parent.fillMode
        z: 0
    }

    /*!
      \internal
      Do the fading when the source is updated
    */
    onSourceChanged: {
        // On creation, the souce handler is called before image pointers are set.
        if (internals.currentImage === null) {
            internals.currentImage = image1;
            internals.nextImage = image2;
        }

        nextImageFadeIn.stop();

        // Don't fade in initial picture, only fade changes
        if (internals.currentImage.source == "") {
            internals.currentImage.source = source;
        } else {
            nextImageFadeIn.stop();
            internals.nextImage.opacity = 0.0;
            internals.nextImage.source = source;

            // If case the image is still in QML's cache, status will be "Ready" immediately
            if (internals.nextImage.status === Image.Ready || internals.nextImage.source === "") {
                internals.swapImages();
            }
        }
    }

    Connections {
        target: internals.nextImage
        onStatusChanged: {
            if (internals.nextImage.status == Image.Ready) {
                 internals.swapImages();
             }
        }
    }

    UbuntuNumberAnimation {
        id: nextImageFadeIn
        target: internals.nextImage
        property: "opacity"
        to: 1.0
        duration: root.duration

        onRunningChanged: {
            if (!running) {
                internals.nextImage.source = "";
            }
        }
    }
}
