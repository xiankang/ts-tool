#include "excel_rw.h"

#include "xlsxcellrange.h"
#include "xlsxdocument.h"

ExcelRW::ExcelRW(QObject *parent) : QObject(parent), sheet_index_(6), key_column_(1), trans_columns_(9){

}

ExcelRW::~ExcelRW() {

}

bool ExcelRW::readXlsx(QList<QList<TranslateModel>> &list, QString path) {
	bool is_success = false;
	list.clear();

	QString key, source, translate;

	QXlsx::CellRange cell_range;

	QXlsx::Document* p_doc = new QXlsx::Document(path);

	if (p_doc == nullptr) {
		return is_success;
	}

	if (p_doc->sheetNames().isEmpty()) {
		return is_success;
	}

	foreach(QString sheet_name, p_doc->sheetNames()) {
		qDebug(qUtf8Printable(sheet_name));
	}

	if (p_doc->sheetNames().size() <= sheet_index_) {
		qDebug("未存在主播端（总表）");
		return is_success;
	}
	
	//选择第sheet_index表
	p_doc->selectSheet(p_doc->sheetNames().at(sheet_index_));

	cell_range = p_doc->currentWorksheet()->dimension();

	for (int column = 2; column <= trans_columns_; column++) {
		//
		QList<TranslateModel> trans_list;

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
					qDebug("translate model key:%s, translate:%s", qUtf8Printable(model.getKey()), qUtf8Printable(model.getTranslate()));
				}
			}
		} while (0);
		list.append(trans_list);
	}
	

	return is_success;
}