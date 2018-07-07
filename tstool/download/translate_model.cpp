#include "translate_model.h"

TranslateModel::TranslateModel() {

}

TranslateModel::TranslateModel(const TranslateModel &other) {
	key_ = other.getKey();
	translate_ = other.getTranslate();
}

TranslateModel &TranslateModel::operator=(const TranslateModel &other) {
	if (&other != this) {
		key_ = other.getKey();
		translate_ = other.getTranslate();
	}

	return *this;
}

TranslateModel::~TranslateModel() {

}