#pragma once
#include <QObject>
#include <QMap>

class Config : public QObject {
	Q_OBJECT
public:
	Config(QObject* parent = 0);
	~Config();

	const QString getExcelUrl() { return excel_url_; }
	const QString getTranslatePath() { return translate_path_; }
	const QString getTsPath() { return ts_path_; }
	const QMap<QString, QString>& getLanToSuffixMap() { return lan_to_suffix_; }
	const QString getSheetName() { return sheet_name_; }
	const QString getRegionSheetName() { return region_sheet_name_; }
	const QString getRegionSheetName2() { return region_sheet_name2_; }
	const QString getLan() { return lan_; }
	const QString getLanToChinese() { return lan_to_chinese_; }
private:
	//excel下载路径
	QString excel_url_;
	//下载的翻译文件保存路径
	QString translate_path_;

	//pc端总表sheet name
	QString sheet_name_;

	//区域表sheet_name
	QString region_sheet_name_;
	QString region_sheet_name2_;

	//language to chinese
	QString lan_;
	QString lan_to_chinese_;

	//ts文件路径
	QString ts_path_;

	//语言到后缀map
	QMap<QString, QString> lan_to_suffix_;

	static QString config_file_;
	static QString region_code_file_;
private:
	void readConfig();
	void readReginCode();
};