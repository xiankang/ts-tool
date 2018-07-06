import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

ApplicationWindow {
    id: tstool_main_window
    objectName: "tstool_main_window"
    visible: true
    width: 640
    height: 435
    title: qsTr("TsTool 1.0.0")
    flags: Qt.Window

    property string excel_url: "https://docs.google.com/spreadsheets/d/1sTVHU4BD124cGgzNeKc966licpc09PeiDTO9ygn18HI/export?format=xlsx&id=1sTVHU4BD124cGgzNeKc966licpc09PeiDTO9ygn18HI"
    signal downloadExcel(string url, string excel_output_path);
    signal excelToTs(string execel_path, string ts_path);

    Item {
        id: item_content
        anchors.fill: parent

        GridLayout {
            id: grid_layout_content
            flow: GridLayout.TopToBottom
            anchors.fill: parent




            GridLayout {
                id: layout_url
                width: 100
                height: 100
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter


                Label {
                    id: label_open_url
                    text: qsTr("excel path")
                }

                TextField {
                    id: txt_excel_output_path
                    text: "D:/a.xlsx"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Button {
                    id: btn_download
                    text: qsTr("download")
                    onClicked: {
                        emit: tstool_main_window.downloadExcel(tstool_main_window.excel_url, txt_excel_output_path.text);
                    }
                }

            }



            GridLayout {
                id: layout_output
                width: 100
                height: 100
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Label {
                    id: label_ts_path
                    text: qsTr("ts path")
                }

                TextField {
                    id: txt_ts_output_path
                    text: "D:/a.ts"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Button {
                    id: btn_open
                    text: qsTr("open")
                }

            }

            Button {
                id: btn_excel_to_ts
                text: qsTr("excel to ts")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    emit: tstool_main_window.excelToTs(txt_excel_output_path.text, txt_ts_output_path.text);
                }
            }

        }
    }
}
