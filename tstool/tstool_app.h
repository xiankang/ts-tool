#include <QObject>
#include <QCoreApplication>
#include "config.h"
#include <QPointer>
#include "download_excel.h"
#include "excel_to_ts.h"

class TsToolApp : public QCoreApplication {
	Q_OBJECT
public:
	TsToolApp(int &argc, char** argv);
	~TsToolApp();
	bool init();

private:
	void bindSignals();

	QPointer<Config> config_;
	QPointer<DownloadExcel> downloader_;
	QPointer<ExcelToTs> excel_to_ts_;

public slots:
	void downloadFinished();
signals:
	void downloadTranslateExcel(QString url, QString output_path);
	void translateToTs(QString src, QString target);
};
