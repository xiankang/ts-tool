#include <QObject>
#include <QMap>

class Config : public QObject {
	Q_OBJECT
public:
	Config(QObject* parent = 0);
	~Config();

	//excel����·��
	QString excel_src_path_;
	//���صķ����ļ�����·��
	QString translate_path_;

	//ts�ļ�·��
	QString ts_path_;

	//���Ե���׺map
	QMap<QString, QString> lan_to_suffix_;
};