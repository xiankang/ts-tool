#pragma once
#include <QObject>
#include "translate_model.h"
#include <QVector>
#include <QMap>

class TsRw : public QObject {
	Q_OBJECT
public:
	explicit TsRw(QObject *parent = 0);
	~TsRw();

	bool exportToTs(QList<QList<TranslateModel>> &list, QString path);

	int findLanguageIndex(QString language_file);
	static QString prefix_;
	static QVector<QString> language_;
	static void initLanguage();
};

