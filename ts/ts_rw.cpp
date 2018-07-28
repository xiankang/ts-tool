#include "ts_rw.h"
#include <QFile>
#include <QDomDocument>
#include <QDir>
#include <QTextStream>
#include <QDebug>

TsRw::TsRw(QMap<QString, QString> lan_to_suffix, QObject *parent) : QObject(parent),
lan_to_suffix_(lan_to_suffix)
{

}

TsRw::~TsRw() {

}

QString TsRw::findLanguageSuffix(QString language_file) {
	int index_of_ = language_file.lastIndexOf("_");
	int index_of_dot = language_file.lastIndexOf(".");
	QString suffix = language_file.mid(index_of_ + 1, index_of_dot-index_of_-1);
	return suffix;
}

bool TsRw::exportToTs(QMap<QString,QList<TranslateModel>> &list, QString path) {
	QDir dir(path);
	if (!dir.exists())
		return false;

	QStringList filter;
	filter << "*.ts";

	QFileInfoList file_info_list = dir.entryInfoList(filter);

	foreach(QFileInfo file_info, file_info_list) {
		//find translate list index
		QString suffix = findLanguageSuffix(file_info.fileName());
		qDebug("ts file %s, suffix:%s", qUtf8Printable(file_info.filePath()), qUtf8Printable(suffix));

		QFile file(file_info.filePath());

		if (!file.open(QIODevice::ReadOnly)) {
			qDebug("can't open file %s" , qUtf8Printable(file_info.filePath()));
			continue;
		}

		//»ñÈ¡translate model list
		QList<TranslateModel>& trans_list(list[suffix]);

		QMap<QString, QString> key_value;

		foreach(TranslateModel model, trans_list) {
			key_value[model.getKey()] = model.getTranslate();
			//qDebug("key=%s, translation=%s ", qUtf8Printable(model.getKey()), qUtf8Printable(model.getTranslate()));
		}

		if (trans_list.count() <= 0) {
			qDebug("translate list is empty");
			continue;
		}

		QDomDocument doc;
		if (!doc.setContent(&file)) {
			qDebug("xml parsing error");
			continue;
		}

		file.close();


		QDomElement root = doc.documentElement();
		QDomNodeList message_list = root.elementsByTagName("message");

		QDomNode node;

		for (int i = 0; i < message_list.count(); i++) {
			node = message_list.at(i);
			QDomNodeList child_list = node.childNodes();
			QString key = child_list.at(child_list.count() - 2).toElement().text();
			QString translation = node.lastChild().toElement().text();
			QString value = key_value[key];
			//qDebug("key=%s, translation=%s, value=%s", qUtf8Printable(key), qUtf8Printable(translation), qUtf8Printable(value));

			if (!value.isEmpty() && translation != value) {
				QDomNode old_node = node.lastChild();

				QDomElement new_element = doc.createElement("translation");
				QDomText text = doc.createTextNode(value);
				new_element.appendChild(text);
				node.replaceChild(new_element, old_node);
			}
		}

		if (!file.open(QFile::WriteOnly | QFile::Truncate)) {
			qDebug("can't write");
			continue;
		}

		QTextStream out_stream(&file);
		doc.save(out_stream, 4);
		file.close();
	}

	return true;
}