#include <stdlib.h>
#include "tstool_app.h"

int main(int argc, char *argv[]){
	TsToolApp app(argc, argv);
	int r;
	if(app.init())
		r = app.exec();
	return r;
	system("PAUSE");
}