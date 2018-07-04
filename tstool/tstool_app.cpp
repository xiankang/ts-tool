#include "tstool_app.h"

TsToolApp::TsToolApp(int &argc, char **argv) : QGuiApplication(argc, argv) {

}

TsToolApp::~TsToolApp() {

}

bool TsToolApp::init() {
  try{
    p_engine_ = new QQmlApplicationEngine(this);
  }
  catch(const char* error) {
    qDebug(error);
    return false;
  }

  return true;
}