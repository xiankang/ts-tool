#include "excel_rw.h"

#include "xlsxcellrange.h"
#include "xlsxdocument.h"

ExcelRW::ExcelRW(QObject *parent) : QObject(parent),total_count_(0), key_column_(1), source_column_(2), trans_column_(3){

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

	p_doc->selectSheet(p_doc->sheetNames().first());
	cell_range = p_doc->currentWorksheet()->dimension();

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

			if (p_doc->cellAt(i, source_column_) == 0) {
				source = "";
			}
			else {
				source = p_doc->cellAt(i, source_column_)->value().toString().trimmed();
			}

			if (p_doc->cellAt(i, trans_column_) == 0) {
				translate = "";
			}
			else {
				translate = p_doc->cellAt(i, trans_column_)->value().toString().trimmed();
			}

			TranslateModel model;
			model.setKey(key);
			model.setSource(source);
			model.setTranslate(translate);

			qDebug("translate model key:%s, source:%s, translate:%s", model.getKey(), model.getSource(), model.getTranslate());
		}
	} while (0);

	return is_success;
}