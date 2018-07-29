#include "excel_to_ts.h"
#include "excel_rw.h"
#include <QDebug>
#include "ts_rw.h"

ExcelToTs::ExcelToTs(Config* config, QObject *parent) : QObject(parent),
config_(config)
{

}

ExcelToTs::~ExcelToTs() {

}

void ExcelToTs::execute(QString src, QString target) {
	ExcelRW excel_rw(config_->getSheetName(), config_->getLanToSuffixMap());
	QMap<QString, QList<TranslateModel>> list;
	qInfo("excel path: %s, ts path: %s", qPrintable(src), qPrintable(target));
	if (!excel_rw.readXlsx(list, src)) {
		qFatal("ExcelToTs::execute read excel file failed!");
	}
	TsRw ts_rw(config_->getLanToSuffixMap());
	ts_rw.exportToTs(list, target);

	emit exportFinished();
}