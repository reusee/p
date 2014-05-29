#include <QApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>

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

signals:
  void videosChanged();
};

#include "object.ccc"

extern "C" {

void run(int argc, char **argv) {
  QApplication app(argc, argv);
  QQmlApplicationEngine engine;

  auto data = new Data;
  for (int i = 1; i < argc; i++) {
    data->addVideo(argv[i]);
  }
  engine.rootContext()->setContextObject(data);

  engine.load(QUrl(QStringLiteral("main.qml")));
  app.exec();
}

}
