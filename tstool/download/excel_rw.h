#pragma once
#include <QObject>
#include <QList>
#include <QString>
#include "translate_model.h"

class ExcelRW : public QObject {
	Q_OBJECT
public:
	ExcelRW(QObject *parent = 0);
	~ExcelRW();

	bool readXlsx(QList<QList<TranslateModel>> &list, QString path);

private:
	int sheet_index_;
	int key_column_;
	int trans_columns_;
};