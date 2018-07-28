#include "tstoolui_app.h"

int main(int argc, char *argv[]){

    // 执行tstool_app
	TsToolUIApp app(argc, argv);

	int r;
	if (app.init())
		r = app.exec();
	return r;
	system("PAUSE");
}