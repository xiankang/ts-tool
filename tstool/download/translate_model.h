#pragma once
#include <QString>

class TranslateModel {
public:
  explicit TranslateModel();
  TranslateModel(const TranslateModel&);
  TranslateModel &operator= (const TranslateModel&);
  ~TranslateModel();

  QString getKey() const { return key_; }
  QString getSource() const { return source_; }
  QString getTranslate() const { return translate_; }

  void setKey(const QString key) { key_ = key; }
  void setSource(const QString source) { source_ = source; }
  void setTranslate(const QString translate) { translate_ = translate; }
  
private:
  QString key_;
  QString source_;
  QString translate_;
};