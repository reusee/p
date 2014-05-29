import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  visible: true
	color: "black"
	id: root

  // 播放器
	Video {
	  focus: true
		anchors.fill: parent
		autoLoad: true
		autoPlay: true
		source: videos[0]
		playbackRate: 1
		id: v
		property int index: 0

		function accelerate() {
		  v.pause()
      var res = metaData.resolution.width * metaData.resolution.height
      if (res > 900000) {
        playbackRate = 5
      } else {
        playbackRate = 16
      }
      muted = true
      v.play()
		}

	  Keys.onPressed: {
	    switch (event.key) {
	    // 加速
	    case Qt.Key_F:
	      if (v.playbackRate > 1) {
          v.playbackRate = 1
          v.muted = false
        } else {
          v.accelerate()
        }
	      break
	    case Qt.Key_R:
	      v.playbackRate += 1
	      break
	    case Qt.Key_E:
	      v.playbackRate -= 1
	      break
	    // 退出
	    case Qt.Key_Q:
	      Qt.quit()
	      break
	    // 选择
	    case Qt.Key_J:
	      v.index = v.index + 1
	      if (v.index == videos.length) {
	        v.index = 0
	      }
	      v.source = videos[v.index]
	      v.playbackRate = 1
	      v.muted = false
	      break
	    case Qt.Key_K:
	      v.index = v.index - 1
	      if (v.index < 0) {
	        v.index = videos.length - 1
	      }
	      v.source = videos[v.index]
	      v.playbackRate = 1
	      v.muted = false
	      break
	    // 跳转
	    case Qt.Key_G:
	      var target = v.position - 5000
	      if (target < 0) target = 0
        v.seek(target)
	      break
	    case Qt.Key_H:
	      var target = v.position + 60000
	      if (target > v.duration) target = v.duration
	      v.seek(target)
	      break
	    // 暂停
	    case Qt.Key_Space:
	      v.playbackState == MediaPlayer.PlayingState ? v.pause() : v.play()
	      break
	    // 标签
	    case Qt.Key_T:
        desc.text = ""
        v.pause()
	      tagDescDialog.visible = true
	      break
	    } // switch
	  }
	}

	// 文件名
	Text {
	  text: v.source
	  anchors.bottom: parent.bottom
	  color: "white"
	  font.pixelSize: 16
	}

	// 播放时间
	Text {
	  text: formatTime(v.position, v.duration, v.playbackRate)
	  anchors.top: parent.top
	  anchors.right: parent.right
	  anchors.rightMargin: 10
	  color: "white"
	  font.pixelSize: 16
	}

	// 标签
	ListView {
	  anchors.left: parent.left
	  anchors.top: parent.top
	  width: 500
	  height: parent.height
	  model: video.nCurrentTags //TODO
	  spacing: 3
	  delegate: Text {
	    text: video.getCurrentTagByIndex(index).description
	    color: "white"
	    font.pixelSize: 14
	    MouseArea {
	      anchors.fill: parent
	      onClicked: v.seek(video.getCurrentTagByIndex(index).position)
	    }
	  }
	}
	Window {
	  id: tagDescDialog
	  modality: Qt.WindowModal
	  color: "black"
	  width: 200
	  height: 50
	  visible: false
    TextField {
      anchors.centerIn: parent
      id: desc
      focus: true
      onAccepted: {
	      if (desc.text != "") {
  	      video.addTag(v.source, v.position, desc.text) //TODO
	      }
  	    tagDescDialog.visible = false
      }
      onEditingFinished: {
  	    v.play()
      }
      Keys.onEscapePressed: tagDescDialog.visible = false
    }
	}
}
