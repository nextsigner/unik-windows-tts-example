/*
    Este código fué creado por @nextsigner
    E-Mail: nextsigner@gmail.com
*/

import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import unik.UnikQProcess 1.0
ApplicationWindow{
    id:app
    visible: true
    visibility:Qt.platform.os==='android'?"FullScreen":"Windowed"
    width: Qt.platform.os==='android'?Screen.width:500
    height: Qt.platform.os==='android'?Screen.height:900
    color: '#333'
    property int fs: Qt.platform.os==='android'?app.width*0.04:app.width*0.03
    property color c1
    property color c2
    property color c3
    property color c4

    onClosing: {
        close.accepted = true
        Qt.quit()
    }

    UnikSettings{
        id: unikSettings
        property color c1
        property color c2
        property color c3
        property color c4
        //url: './cfg.json'
        Component.onCompleted: {
            unikSettings.currentNumColor=0
            var tcs=unikSettings.defaultColors.split('|')
            var c=tcs[unikSettings.currentNumColor].split('-')
            app.c1=c[0]
            app.c2=c[1]
            app.c3=c[2]
            app.c4=c[3]
        }
    }

    Settings{
        id:appSettings
        category: 'UnikTtsExample'
        property int engine
        property int voice
        property int volume
        property int rate
        property int pitch
    }
    Connections{
        target: unik
        onTtsSpeakingChanged: {
            if(unik.ttsSpeaking===1){ //Playing
                btnSpeakStop.enabled = true
                btnSpeakPauseResume.enabled = true
                btnSpeakPauseResume.text = 'Pausar'
            }else if(unik.ttsSpeaking===2){ //Pausing
                btnSpeakStop.enabled = false
                btnSpeakPauseResume.enabled = true
                btnSpeakPauseResume.text = 'Continuar'
                //app.color='red'
            }else if(unik.ttsSpeaking===0){ //Stoping
                btnSpeakStop.enabled = false
                btnSpeakPauseResume.enabled = false
                btnSpeakPauseResume.text = 'Pausar'
                //app.color='red'
            }else{
                btnSpeakPauseResume.enabled = true
                btnSpeakStop.enabled = true
                btnSpeakPauseResume.text = 'Pausar'
            }
        }
    }

    Item{
        id:xApp
        width: app.width-app.fs
        height: app.height-app.fs-app.fs*0.5
        x:app.fs*0.5
        y:app.fs*0.5
        Flickable{
            id:flick1
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: col1.height
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { }
            Column{
                id: col1
                spacing: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text:'<b>Unik Android Text2Voice Example</b>'
                    font.pixelSize: app.fs*1.4
                    color: 'white'
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Item{width: 1; height: app.fs*2}
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                   spacing: app.fs
                    Text{
                        id: labelCbEngines
                        text:'Engines: '
                        font.pixelSize: app.fs
                        color: 'white'
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: cbEngines
                        width: xApp.width-labelCbEngines.width-48
                        font.pixelSize: app.fs
                        height: app.fs*3
                        model: (''+ttsEngines).split(',')
                        onCurrentIndexChanged: {
                            appSettings.engine= currentIndex
                            unik.ttsEngineSelected(currentIndex)
                        }
                    }
                }
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: app.fs
                    Text{
                        id: labelCbVoices
                        text: 'Voces: '
                        font.pixelSize: app.fs
                        color: 'white'
                    }
                    ComboBox{
                        id: cbVoices
                        width: xApp.width-labelCbVoices.width-app.fs*2
                        font.pixelSize: app.fs
                        height: app.fs*3
                        model: (''+ttsVoices).split(',')
                        onCurrentIndexChanged: {
                            appSettings.voice= currentIndex
                            unik.ttsVoiceSelected(currentIndex)
                        }
                    }
                }
                Column{
                    spacing: app.fs
                    anchors.horizontalCenter: parent.horizontalCenter
                    Row{
                        spacing: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text{
                            text:'Volume: '
                            font.pixelSize: app.fs
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        SpinBox{
                            id: sbVolume
                            from: 0
                            to:100
                            value: 0
                            font.pixelSize: app.fs
                            width: app.fs*10
                            height: app.fs*3
                            onValueChanged: {
                                unik.setTtsVolume(value)
                                appSettings.volume = value
                            }
                        }
                    }
                    Item{width: app.fs; height: 1}
                    Row{
                        spacing: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text{
                            text:'Rate: '
                            font.pixelSize: app.fs
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        SpinBox{
                            id: sbRate
                            from: -10
                            to:10
                            value: 0
                            font.pixelSize: app.fs
                            width: app.fs*10
                            height: app.fs*3
                            onValueChanged: {
                                unik.setTtsRate(value)
                                appSettings.rate = value
                            }
                        }
                    }
                    Item{width: app.fs; height: 1}
                    Row{
                        spacing: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text{
                            text:'Pitch: '
                            font.pixelSize: app.fs
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        SpinBox{
                            id: sbPitch
                            from: -10
                            to:10
                            value: 0
                            font.pixelSize: app.fs
                            width: app.fs*10
                            height: app.fs*3
                            onValueChanged: {
                                unik.setTtsPitch(value)
                                appSettings.pitch = value
                            }
                        }
                    }
                }
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        id: labelCbLocales
                        text:'Lenguaje: '
                        font.pixelSize: app.fs
                        color: 'white'
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: cbLanguajes
                        width: xApp.width-labelCbLocales.width-48
                        font.pixelSize: app.fs
                        height: app.fs*3
                        model: (''+ttsLocales).split(',')
                        onCurrentIndexChanged: {
                            appSettings.voice= currentIndex
                            unik.ttsLanguageSelected(currentIndex)
                        }
                    }
                }
                Text{
                    text:'Escribir un texto'
                    font.pixelSize: app.fs
                    color: 'white'
                }
                TextField{
                    id: ti
                    font.pixelSize: app.fs
                    width: xApp.width-app.fs*2
                    height: app.fs*2
                    onFocusChanged: if(focus && !unik.isTtsSpeaking())speak('Escribir aquí un texto y presionar la tecla Enter')
                    KeyNavigation.tab: btnSpeak
                    Keys.onReturnPressed: {
                        speak(ti.text)
                    }
                    Rectangle{
                        width: parent.width+app.fs*0.25
                        height: parent.height+app.fs*0.25
                        color: 'transparent'
                        border.width: parent.focus?app.fs*0.25:0
                        border.color: "#ff8833"
                        anchors.centerIn: parent
                    }
                }
                Row{
                    spacing: app.fs
                    Button{
                        id:btnSpeak
                        text: 'Hablar'
                        font.pixelSize: app.fs
                        width: app.fs*8
                        height: app.fs*3
                        onFocusChanged: {
                            if(focus&&ti.text!==''&&!unik.isTtsSpeaking()&&!unik.isTtsPaused())speak('Hacer click en este boton para hablar')
                            if(focus&&ti.text===''&&!unik.isTtsSpeaking()&&!unik.isTtsPaused())speak('El campo de texto esta vacio, ingrese un texto para poder convertirlo a voz.')
                        }
                        KeyNavigation.tab: btnSpeakStop
                        onClicked: {
                            if(ti.text!==''){
                                speak(ti.text)
                            }else{
                                speak('El campo de texto esta vacio, ingrese un texto para poder convertirlo a voz.')
                            }
                        }
                        Rectangle{
                            width: parent.width+app.fs*0.25
                            height: parent.height+app.fs*0.25
                            color: 'transparent'
                            border.width: parent.focus?app.fs*0.25:0
                            border.color: "#ff8833"
                            anchors.centerIn: parent
                        }
                    }
                    Button{
                        id:btnSpeakPauseResume
                        enabled: false
                        visible: Qt.platform.os!='linux'
                        text: 'Pausar'
                        font.pixelSize: app.fs
                        width: app.fs*8
                        height: app.fs*3
                        KeyNavigation.tab: row.children[0]
                        onClicked: {
                            if(unik.isTtsPaused()){
                                textSpeaked.text='<b>Continua: </b>'+ti.text
                                unik.ttsResume()
                            }else{
                                textSpeaked.text='<b>Pausado: </b>'+ti.text
                                if(unik.isTtsSpeaking()){
                                    unik.ttsPause()
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width+app.fs*0.25
                            height: parent.height+app.fs*0.25
                            color: 'transparent'
                            border.width: parent.focus?app.fs*0.25:0
                            border.color: "#ff8833"
                            anchors.centerIn: parent
                        }
                    }
                    Button{
                        id:btnSpeakStop
                        enabled: false
                        text: 'Detener'
                        font.pixelSize: app.fs
                        width: app.fs*8
                        height: app.fs*3
                        KeyNavigation.tab: row.children[0]
                        onClicked: {
                            unik.ttsSpeakStop()
                            textSpeaked.text=ti.text
                        }
                        Rectangle{
                            width: parent.width+app.fs*0.25
                            height: parent.height+app.fs*0.25
                            color: 'transparent'
                            border.width: parent.focus?app.fs*0.25:0
                            border.color: "#ff8833"
                            anchors.centerIn: parent
                        }
                    }
                }

                Text{
                    text:'Detectar elemento'
                    font.pixelSize: app.fs
                    color: 'white'
                }
                Row{
                    id:row
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater{
                        id:rep
                        model:['red', 'yellow', 'blue', 'brown', 'pink']
                        property var a: ['rojo', 'amarillo', 'azul', 'marron', 'rosado']
                        Rectangle{
                            width: app.fs*4
                            height: width
                            color: modelData
                            border.width: focus?app.fs*0.5:0
                            border.color: "#ff8833"
                            objectName: 'rect'+index
                            KeyNavigation.tab: index===3?row.children[5]: index===4?ti:row.children[index+1]
                            onFocusChanged: if(focus && !unik.isTtsSpeaking())speak('Sobre el color '+rep.a[index])
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    speak('Sobre el color '+rep.a[index])
                                    parent.focus=true
                                }
                                onClicked: {
                                    speak('Sobre el color '+rep.a[index])
                                    parent.focus=true
                                }
                            }
                        }
                    }
                }
                Item{
                    width: 1
                    height: app.fs*2
                }
                Text{
                    text:'Último texto reproducido'
                    font.pixelSize: app.fs
                    color: 'white'
                }
                Rectangle{
                    width: xApp.width-app.fs*2
                    height: xApp.height*0.3
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        id: textSpeaked
                        font.pixelSize: app.fs
                        width: parent.width-app.fs
                        wrapMode: Text.WordWrap
                        anchors.top: parent.top
                        anchors.topMargin: app.fs
                        anchors.left: parent.left
                        anchors.leftMargin: app.fs
                    }
                }
            }
            Component.onCompleted: ti.focus=true
        }
    }
    UWarnings{}
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted: {
        console.log('TTS Engines for Android: '+ttsEngines)
        console.log('TTS Engine Voices: '+ttsVoices)
        console.log('TTS Engine Locales: '+ttsLocales)
        cbEngines.currentIndex = appSettings.engine
        cbLanguajes.currentIndex = appSettings.voice
        sbVolume.value = appSettings.volume
        sbRate.value = appSettings.rate
        sbPitch.value = appSettings.pitch
    }
    function speak(t){
        textSpeaked.text=t
        unik.speak(t)
    }
}
