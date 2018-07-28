#pragma once
#include <QGuiApplication>
#include <QQuickWindow>
#include <QQmlapplicationEngine>
#include <QPointer>
#include <QObject>
#include "download_excel.h"
#include "excel_to_ts.h"
#include "config.h"

class TsToolUIApp : public QGuiApplication {
	Q_OBJECT
public:
  TsToolUIApp(int &argc, char** argv);
  ~TsToolUIApp();
	bool init();

private:
  QPointer<QQmlApplicationEngine> p_engine_;

  QPointer<QQuickWindow> main_window_;

  QPointer<DownloadExcel> download_excel_;
  QPointer<ExcelToTs> excel_to_ts_;
  QPointer<Config> config_;
private:
	void bindSignals();
};