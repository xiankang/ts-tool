#pragma once
#include <QString>

class TranslateModel {
public:
  explicit TranslateModel();
  TranslateModel(const TranslateModel&);
  TranslateModel &operator= (const TranslateModel&);
  ~TranslateModel();

  QString getKey() const { return key_; }
  QString getTranslate() const { return translate_; }

  void setKey(const QString key) { key_ = key; }
  void setTranslate(const QString translate) { translate_ = translate; }
  
  bool isEmpty() { return key_.isEmpty(); }
private:
  QString key_;
  QString translate_;
};