#pragma once
#include <QGuiApplication>
#include <QQuickWindow>
#include <QQmlapplicationEngine>
#include <QPointer>

class TsToolApp : public QGuiApplication {
	Q_OBJECT
public:
  TsToolApp(int &argc, char** argv);
  ~TsToolApp();
	bool init();

private:
  QPointer<QQmlApplicationEngine> p_engine_;
};