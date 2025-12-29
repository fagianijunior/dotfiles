import QtQuick
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: 65
    
    property string label: ""
    property color color: "cyan"
    property double value: 0 // 0.0 to 1.0

    Canvas {
        id: canvas
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.8
        height: width

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var centerX = width / 2
            var centerY = height / 2
            var radius = Math.min(centerX, centerY)
            var startAngle = -Math.PI / 2 // Start from the top

            // Background circle
            ctx.beginPath()
            ctx.strokeStyle = "#444444"
            ctx.lineWidth = 10
            ctx.arc(centerX, centerY, radius - ctx.lineWidth / 2, 0, 2 * Math.PI)
            ctx.stroke()

            // Foreground arc
            if (root.value > 0) {
                ctx.beginPath()
                ctx.strokeStyle = root.color
                ctx.lineWidth = 10
                var endAngle = startAngle + (2 * Math.PI * root.value)
                ctx.arc(centerX, centerY, radius - ctx.lineWidth / 2, startAngle, endAngle)
                ctx.stroke()
            }
        }
    }

    Text {
        text: (value * 100).toFixed(1) + "%"
        anchors.centerIn: canvas
        color: "white"
        font.pixelSize: 8
        font.bold: true
    }

    Text {
        text: label
        anchors.top: canvas.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        font.pixelSize: 12
    }

    Component.onCompleted: {
        canvas.requestPaint()
    }

    onValueChanged: {
        canvas.requestPaint()
    }
}
