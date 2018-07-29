#include "excel_rw.h"

#include "xlsxcellrange.h"
#include "xlsxdocument.h"

ExcelRW::ExcelRW(QString sheet_name, QMap<QString, QString> lan_to_suffix, QObject *parent) : QObject(parent), 
key_column_(1), 
sheet_name_(sheet_name),
lan_to_suffix_(lan_to_suffix)
{

}

ExcelRW::~ExcelRW() {

}

bool ExcelRW::readXlsx(QMap<QString, QList<TranslateModel>>& list, QString path) {
	bool is_success = false;
	list.clear();

	QString key, source, translate;

	QXlsx::CellRange cell_range;

	QXlsx::Document* p_doc = new QXlsx::Document(path);

	if (p_doc == nullptr) {
		return is_success;
	}

	foreach(QString sheet_name, p_doc->sheetNames()) {
		qInfo(qUtf8Printable(sheet_name));
	}

	//选择第sheet_name_表
	if (!p_doc->selectSheet(sheet_name_)) {
		qFatal("ExcelRW::readXlsx %s 不存在", qUtf8Printable(sheet_name_));
		return is_success;
	}
	
	cell_range = p_doc->currentWorksheet()->dimension();

	for (int column = 2; column <= cell_range.columnCount(); column++) {
		//
		QList<TranslateModel> trans_list;
		QXlsx::Cell* cell = p_doc->cellAt(1, column);
		QString suffix;
		if (cell) {
			suffix = lan_to_suffix_[cell->value().toString().trimmed()];
		}
		do {
			if (1 == cell_range.lastRow() && (p_doc->cellAt(cell_range.lastRow(), cell_range.lastColumn()) == 0)) {
				is_success = true;
				break;
			}

			for (int i = 2; i <= cell_range.lastRow(); i++) {
				if (p_doc->cellAt(i, key_column_) == 0) {
					key = "";
				}
				else {
					key = p_doc->cellAt(i, key_column_)->value().toString().trimmed();
				}

				if (p_doc->cellAt(i, column) == 0) {
					translate = "";
				}
				else {
					translate = p_doc->cellAt(i, column)->value().toString().trimmed();
				}

				TranslateModel model;
				model.setKey(key);
				model.setTranslate(translate);

				if (!model.isEmpty()) {
					trans_list.append(model);
					//qDebug("translate model key:%s, translate:%s", qUtf8Printable(model.getKey()), qUtf8Printable(model.getTranslate()));
				}
			}
		} while (0);
		
		if (!suffix.isEmpty()) {
			list[suffix] = trans_list;
			is_success = true;
		}
	}
	

	return is_success;
}