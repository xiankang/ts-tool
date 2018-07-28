#pragma once
#include <QObject>
#include "translate_model.h"
#include <QVector>
#include <QMap>

class TsRw : public QObject {
	Q_OBJECT
public:
	explicit TsRw(QMap<QString, QString> lan_to_suffix, QObject *parent = 0);
	~TsRw();

	bool exportToTs(QMap<QString, QList<TranslateModel>> &list, QString path);

	QString findLanguageSuffix(QString language_file);
	static QString prefix_;

	//ÓïÑÔµ½ºó×ºmap
	QMap<QString, QString> lan_to_suffix_;
};

