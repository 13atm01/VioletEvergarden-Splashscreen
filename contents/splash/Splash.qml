import QtQuick 2.7
import QtQuick.Particles 2.0
import QtQuick.Window 2.2


Rectangle {
    id: root
    
    // Define some miscellanous variables
    width: Screen.width
    height: Screen.height
    property int stage
    // Create background gradient
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#202020" }
        GradientStop { position: 1.0; color: "#330066" }
    }
    //Get KDE splash screen stages
    onStageChanged: {
        if (stage==1) {
            beltOuter.opacity=0.6
        }
        if (stage==2) {
        }
        if (stage==3) {
            beltInner.opacity=0.6
        }
        if (stage==4) {
        }
        if (stage==5) {
            beltInner.secondAnimation=1.0
            text.opacity=0.8
            beltInner2.opacity=0.6
        }
        if (stage==6) {
        }
    }
    
    // Configuration of the render images
    Image {
        id: imageConfig
        property var imageArray: ["images/VE.png", "images/VE01.png", "images/VE02.png"]
        // Percentage of Screen configs
        property int maxHeight: 100
        property int maxWidth: 0
        property int x_offset: 4
        opacity: 0
        source: imageConfig.imageArray[Math.floor(Math.random() * imageConfig.imageArray.length)]
    }
    
    // Background snowflakes generator
    ParticleSystem {
        id: bgPS
        anchors.fill: parent
        ImageParticle {
            source: "images/starParticle.png"
        }
        // Small snowflake emitter
        Emitter {
            anchors.fill: parent
            size: 10
            emitRate: 50
            maximumEmitted: 50
            lifeSpan: 3000; lifeSpanVariation: 400
            velocity: PointDirection {xVariation: 60; y:30; yVariation: 30;}
        }
        Gravity {
            anchors.fill: parent
            angle: 90
            magnitude: 15
        }
    }
    
    // Outer bars of the belt (acts on opacity)
    Rectangle {
        id: beltOuter
        anchors.verticalCenter: beltInner.verticalCenter
        anchors.left: parent.left
        height: beltInner.height * 1.65
        width: 0
        opacity: 0
        gradient: Gradient {
            GradientStop { position: 0.0000; color: "#FFFFFFFF" }
            GradientStop { position: 0.1499; color: "#FFFFFFFF" }
            GradientStop { position: 0.1500; color: "#00FFFFFF" }
            GradientStop { position: 0.8499; color: "#00FFFFFF" }
            GradientStop { position: 0.8500; color: "#FFFFFFFF" }
            GradientStop { position: 1.0000; color: "#FFFFFFFF" }
        }
        Behavior on opacity {
            NumberAnimation { target: beltOuter; property: "width"; to: root.width; duration: 2000 }
        }
    }
    
    // Middle bar of the belt (acts on opacity)
    Rectangle {
        id: beltInner
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: 0
        height: Screen.height / 7
        color: "#FFFFFF"
        opacity: 0
        property int secondAnimation: 0
        Behavior on opacity {
            NumberAnimation { target: beltInner; property: "width"; to: root.width; duration: 2000 }
        }
        // Secondary Animation
        Behavior on secondAnimation {
            NumberAnimation {target: beltInner; property: "width"; to: root.width * 0.56; duration: 1000 }
        }
    }
    
    // Splash text anchored to middle belt
    Text {
        id: text
        property double landscape_fontsize: Screen.height / 9
        property double portrait_fontsize: text.width / text.text.length 
        color: "#FFFFFF"
        font.pixelSize: (landscape_fontsize * text.text.length >= text.width) ? text.portrait_fontsize : text.landscape_fontsize
        anchors.left: beltInner.right
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        width: Screen.width * 0.32
        text: "Welcome"
        opacity: 0
        Behavior on opacity { NumberAnimation {duration: 1000; easing {type: Easing.InOutQuad}} }
    }
    Rectangle {
        id: beltInner2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: text.right
        width: Screen.width * 0.5
        height: beltInner.height
        color: "#FFFFFF"
        opacity: 0
    }
    
    // Character foreground image (above previous layers)
    Image {
        id: renderForeground
        anchors.bottom: parent.bottom
        // Image render screen resolution scaling
        x: Screen.width * (imageConfig.x_offset / 100)
        fillMode: Image.PreserveAspectFit
        function fit_width(){
            var imageWidth = imageConfig.width
            var imageHeight = imageConfig.height
            var maxWidth = Screen.width * (imageConfig.maxWidth / 100)
            var maxHeight = Screen.height * (imageConfig.maxHeight / 100)
            var imageRatio = imageHeight / imageWidth
            var screenRatio = Screen.height / Screen.width
            
            if(screenRatio >= imageRatio){
                imageWidth = maxWidth
                imageHeight = imageRatio * imageWidth
            } else {
                imageHeight = maxHeight
                imageWidth = imageHeight / imageRatio
            }
            return imageWidth
        }
        width: fit_width()
        source: imageConfig.source
    }
    
    // Foreground snowflakes generator
    ParticleSystem {
        id: fgPS
        anchors.fill: parent
        ImageParticle {
            source: "images/starParticle.png"
        }
        // Medium snowflake emitter
        Emitter {
            anchors.fill: parent
            size: 20
            emitRate: 10
            maximumEmitted: 20
            lifeSpan: 3000; lifeSpanVariation: 400
            velocity: PointDirection {xVariation: 60; y:50; yVariation: 25;}
        }
        // Large snowflake emitter
        Emitter {
            anchors.fill: parent
            size: 30
            emitRate: 2
            maximumEmitted: 8
            lifeSpan: 3000; lifeSpanVariation: 300
            velocity: PointDirection {xVariation: 60; y:60; yVariation: 20;}
        }
        Gravity {
            anchors.fill: parent
            angle: 90
            magnitude: 15
        }
    }
}
