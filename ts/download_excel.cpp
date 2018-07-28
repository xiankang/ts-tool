#include "download_excel.h"
#include <QNetworkRequest>
#include <QFile>
#include <QStandardPaths>

DownloadExcel::DownloadExcel(QObject* parent) : QObject(parent) {
	network_ = new QNetworkAccessManager(this);
	QObject::connect(network_, SIGNAL(finished(QNetworkReply*)), this, SLOT(slotReplyFinished(QNetworkReply*)));
}

DownloadExcel::~DownloadExcel() {

}

void DownloadExcel::execute(QString url, QString output_path) {
	excel_file_ = new QFile(output_path);
	excel_file_->open(QIODevice::WriteOnly);
	reply_ = network_->get(QNetworkRequest(QUrl(url)));
	QObject::connect(reply_, SIGNAL(readyRead()), this, SLOT(slotReadyRead()));
	QObject::connect(reply_, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(slotError(QNetworkReply::NetworkError)));
	QObject::connect(reply_, SIGNAL(sslErrors(QList<QSslError>)), this, SLOT(slotSslErrors(QList<QSslError>)));
	QObject::connect(reply_, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(slotDownloadProgress(qint64, qint64)));
}

void DownloadExcel::slotDownloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
	//if(bytesTotal !=0 )
	//	qDebug("download progress %.2f", qreal(bytesReceived) / bytesTotal * 100);
}

void DownloadExcel::slotReadyRead() {
	qDebug("DownloadExcel::slotReadyRead");
	if (reply_) {
		excel_file_->write(reply_->readAll());
	}
}

void DownloadExcel::slotReplyFinished(QNetworkReply* reply) {
	//��ȡ��Ӧ����Ϣ��״̬��Ϊ200��ʾ����  
	QVariant status_code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
	QByteArray bytes = reply->readAll();  //��ȡ�ֽ�  
	QString result(bytes);  //ת��Ϊ�ַ���  
	qDebug() << result;

	if (reply->error() == QNetworkReply::NoError) {
		QByteArray bytes = reply->readAll();  //��ȡ�ֽ�  
		QString result(bytes);  //ת��Ϊ�ַ���  

		qDebug() <<"DownloadExcel::slotReplyFinished "<< result;
	}
	else {
		//����
		qDebug("DownloadExcel::slotReplyFinished error %d", reply->error());
	}

	reply->deleteLater();
	delete excel_file_;
	emit downloadFinished();
}

void DownloadExcel::slotError(QNetworkReply::NetworkError error) {
	qDebug("DownloadExcel::slotError %d", error);
}

void DownloadExcel::slotSslErrors(QList<QSslError> errors) {
	for (QList<QSslError>::iterator iter = errors.begin(); iter != errors.end(); iter++) {
		qDebug("DownloadExcel::slotSslErrors %d", *iter);
	}
}