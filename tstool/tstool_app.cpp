#include "tstool_app.h"
#include <QObject>
#include <QString>

TsToolApp::TsToolApp(int &argc, char **argv) : QCoreApplication(argc, argv) {

}

TsToolApp::~TsToolApp() {

}

bool TsToolApp::init() {
	config_ = new Config(this);
	downloader_ = new DownloadExcel(this);
	excel_to_ts_ = new ExcelToTs(config_, this);

	bindSignals();
	emit downloadTranslateExcel(config_->getExcelUrl(), config_->getTranslatePath());
	return 1;
}

void TsToolApp::bindSignals() {
	QObject::connect(this, SIGNAL(downloadTranslateExcel(QString, QString)), downloader_, SLOT(execute(QString, QString)));
	QObject::connect(downloader_, SIGNAL(downloadFinished()), this, SLOT(downloadFinished()));
	QObject::connect(this, SIGNAL(translateToTs(QString, QString)), excel_to_ts_, SLOT(execute(QString, QString)));
	QObject::connect(excel_to_ts_, SIGNAL(exportFinished()), this, SLOT(quit()));
}

void TsToolApp::downloadFinished() {
	emit translateToTs(config_->getTranslatePath(), config_->getTsPath());
}