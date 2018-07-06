#pragma once
#include <QObject>

class TsRw : public QObject {
	Q_OBJECT
public:
	TsRw(QObject *parent = 0);
	~TsRw();
};