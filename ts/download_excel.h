#pragma once
#include <QNetworkAccessManager>
#include <QObject>
#include <QNetworkReply>
#include <QPointer>
#include <QFile>

class DownloadExcel : public QObject {
	Q_OBJECT

public:
	DownloadExcel(QObject* parent = 0);
	~DownloadExcel();

signals:
	void downloadFinished();
public slots:
	void slotDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
	void slotReadyRead();
	void slotError(QNetworkReply::NetworkError error);
	void slotSslErrors(QList<QSslError> errors);
	void slotReplyFinished(QNetworkReply* reply);
	void execute(QString url, QString output_path);
private:
	QFile* excel_file_;
	QPointer<QNetworkAccessManager>  network_;
	QPointer<QNetworkReply> reply_;
};