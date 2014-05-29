#include <QApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>

extern "C" {
  char* fmtTime(int, int, int);
}

class Data : public QObject {
  Q_OBJECT

  Q_PROPERTY(QList<QString> videos READ getVideos NOTIFY videosChanged)

  QList<QString> videos;

public:

  QList<QString> getVideos() {
    return videos;
  }

  void addVideo(char *v) {
    videos.append(v);
  }

  Q_INVOKABLE QString formatTime(int position, int duration, int rate) {
    return QString(fmtTime(position, duration, rate));
  }

signals:

  void videosChanged();

};

#include "object.ccc"

extern "C" {

void run(int argc, char **argv, char *qml_path) {
  QApplication app(argc, argv);
  QQmlApplicationEngine engine;

  auto data = new Data;
  for (int i = 1; i < argc; i++) {
    data->addVideo(argv[i]);
  }
  engine.rootContext()->setContextObject(data);

  engine.load(QUrl(qml_path));
  app.exec();
}

}
