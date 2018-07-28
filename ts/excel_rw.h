#pragma once
#include <QObject>
#include <QMap>
#include <QString>
#include "translate_model.h"

class ExcelRW : public QObject {
	Q_OBJECT
public:
	ExcelRW(QString sheet_name, QMap<QString, QString> lan_to_suffix, QObject *parent = 0);
	~ExcelRW();

	bool readXlsx(QMap<QString, QList<TranslateModel>> &list, QString path);

private:
	QString sheet_name_;
	int key_column_;
	//ÓïÑÔµ½ºó×ºmap
	QMap<QString, QString> lan_to_suffix_;
};