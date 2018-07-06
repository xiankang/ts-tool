#pragma once
#include <QObject>
class ExcelToTs : public QObject {
	Q_OBJECT
public:
	ExcelToTs(QObject* parent = 0);
	~ExcelToTs();

public slots:
	void execute(QString src, QString target);
};