#include "excel_to_ts.h"
#include "excel_rw.h"
#include <QDebug>
#include "ts_rw.h"

ExcelToTs::ExcelToTs(QObject *parent) : QObject(parent) {

}

ExcelToTs::~ExcelToTs() {

}

void ExcelToTs::execute(QString src, QString target) {
	ExcelRW excel_rw;
	QList<QList<TranslateModel>> list;
	qDebug("excel path: %s, ts path: %s", qPrintable(src), qPrintable(target));
	excel_rw.readXlsx(list, src);
	TsRw ts_rw;
	ts_rw.exportToTs(list, target);
}