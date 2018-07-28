#pragma once
#include <QObject>
#include "config.h"
#include <QPointer>

class ExcelToTs : public QObject {
	Q_OBJECT
public:
	ExcelToTs(Config* config, QObject* parent = 0);
	~ExcelToTs();

signals:
	void exportFinished();
public slots:
	void execute(QString src, QString target);

private:
	QPointer<Config> config_;
};