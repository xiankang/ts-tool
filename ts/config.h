#include <QObject>
#include <QMap>

class Config : public QObject {
	Q_OBJECT
public:
	Config(QObject* parent = 0);
	~Config();

	//excel下载路径
	QString excel_src_path_;
	//下载的翻译文件保存路径
	QString translate_path_;

	//ts文件路径
	QString ts_path_;

	//语言到后缀map
	QMap<QString, QString> lan_to_suffix_;
};