#include "tstoolui_app.h"


TsToolUIApp::TsToolUIApp(int &argc, char **argv) : QGuiApplication(argc, argv) {

}

TsToolUIApp::~TsToolUIApp() {

}

bool TsToolUIApp::init() {
  try{
    p_engine_ = new QQmlApplicationEngine(this);
	p_engine_->load(QUrl("qrc:/qml/tstool_main_window.qml"));
	for (int i = 0; i < p_engine_->rootObjects().size(); i++) {
		QObject *rootObject = p_engine_->rootObjects().at(i);
		if (rootObject->objectName() == QString("tstool_main_window")) {
			main_window_ = qobject_cast<QQuickWindow*>(rootObject);
		}
	}
	main_window_->show();

	config_ = new Config(this);
	download_excel_ = new DownloadExcel(this);
	excel_to_ts_ = new ExcelToTs(config_, this);

	bindSignals();
  }
  catch(const char* error) {
    qDebug(error);
    return false;
  }

  return true;
}

void TsToolUIApp::bindSignals() {
	QObject::connect(main_window_, SIGNAL(downloadExcel(QString, QString)), download_excel_, SLOT(execute(QString, QString)));
	QObject::connect(main_window_, SIGNAL(excelToTs(QString, QString)), excel_to_ts_, SLOT(execute(QString, QString)));
}