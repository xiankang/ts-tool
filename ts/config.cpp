#include "config.h"
#include <QDomDocument>
#include <QFile>
#include "xlsxdocument.h"
#include "xlsxcellrange.h"

QString Config::config_file_ = QString("./config/config.xml");
QString Config::region_code_file_ = QString("./config/region_code.xlsx");

Config::Config(QObject* parent) : QObject(parent) {
	readConfig();
	readReginCode();
}

Config::~Config() {

}

void Config::readConfig() {
	QFile file(config_file_);
	if (!file.open(QFile::ReadOnly | QFile::Text)) {
		qFatal("Config::readConfig() can't open file %s", qUtf8Printable(config_file_));
		return;
	}

	QDomDocument doc;
	if (!doc.setContent(&file)) {
		qFatal("Config::readConfig() xml parsing error");
		return;
	}

	QDomElement root = doc.documentElement();
	qInfo(qUtf8Printable(root.nodeName()));

	QDomNodeList& node_list(root.childNodes());
	for(int i=0; i< node_list.count(); i++){
		QDomNode node = node_list.at(i);
		if (node.nodeName() == QString("excelUrl")) {
			excel_url_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("sheetName")) {
			sheet_name_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("tsPath")) {
			ts_path_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("translatePath")) {
			translate_path_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("regionSheetName")) {
			region_sheet_name_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("regionSheetName2")) {
			region_sheet_name2_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("lanToChinese")) {
			lan_to_chinese_ = node.toElement().text().trimmed();
		}
		else if (node.nodeName() == QString("lan")) {
			lan_ = node.toElement().text().trimmed();
		}
	}

	qInfo("download translate excel file form %s", qUtf8Printable(excel_url_));
	qInfo("translate file save: %s", qUtf8Printable(translate_path_));
	qInfo("sheet name: %s", qUtf8Printable(sheet_name_));
	qInfo("regionSheetName: %s",qUtf8Printable(region_sheet_name_));
	qInfo("regionSheetName2: %s", qUtf8Printable(region_sheet_name2_));
	qInfo("lan column name: %s", qUtf8Printable(lan_));
	qInfo("lanToChinese column name: %s", qUtf8Printable(lan_to_chinese_));
	qInfo("ts path: %s", qUtf8Printable(ts_path_));
	file.close();
}

void Config::readReginCode() {
	QXlsx::Document* p_doc = new QXlsx::Document(region_code_file_);
	if (p_doc == nullptr) {
		qFatal("Config::readReginCode() can't open %s", region_code_file_);
		return;
	}

	if (p_doc->sheetNames().isEmpty()) {
		qFatal("Config::readReginCode() %s is no data");
		return;
	}

	p_doc->selectSheet(region_sheet_name_);

	QXlsx::CellRange cell_range = p_doc->currentWorksheet()->dimension();
	
	qInfo("%d",cell_range.columnCount());

	int lan_column = 0;
	int lan_to_chinese_column = 0;
	for (int i = 1; i <= cell_range.columnCount(); i++) {
		QXlsx::Cell* cell = p_doc->cellAt(1, i);
		if (cell) {
			QString column_name = cell->value().toString().trimmed();
			if (lan_to_chinese_ == column_name.toUtf8().constData()) {
				lan_to_chinese_column = i;
			}
			else if (lan_ == column_name) {
				lan_column = i;
			}
		}
	}

	for (int i = 3; i <= cell_range.rowCount(); i++) {
		QXlsx::Cell* lan_cell = p_doc->cellAt(i, lan_column);
		QString lan;
		QString chinese;
		if (lan_cell) {
			lan = lan_cell->value().toString().trimmed();
		}
		QXlsx::Cell* chinese_cell = p_doc->cellAt(i, lan_to_chinese_column);
		if (chinese_cell) {
			chinese = chinese_cell->value().toString().trimmed();
		}

		if (!chinese.isEmpty()) {
			lan_to_suffix_[chinese] = lan;

			qInfo("lan: %s, chinese: %s", qUtf8Printable(lan), qUtf8Printable(chinese));
		}
	}
}