import QtQuick 2.2
import QtQuick.Controls 1.1
import QtMultimedia 5.0

ApplicationWindow {
  visible: true
  title: "Player"
  color: "black"

  Video {
    anchors.fill: parent
    autoLoad: true
    autoPlay: true
    source: videos[0]
  }

}
