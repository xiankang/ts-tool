#include "tstool_app.h"

int main(int argc, char *argv[]){

    // 执行tstool_app
	TsToolApp tsToolApp(argc, argv);

	int r;
	if (tsToolApp.init())
		r = tsToolApp.exec();
	return r;
	system("PAUSE");
}