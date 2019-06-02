#ifndef NOTIFICATIONRECEIVER_H
#define NOTIFICATIONRECEIVER_H

#include <QObject>
#include <QThread>
#include <QMutex>
#include <QTcpSocket>
#include <nlohmann/json.hpp>

class NotificationReceiver : public QThread
{
public:
    NotificationReceiver(QTcpSocket& socket);
    void run();
    void pause();
    void resume();
    void stop();
    nlohmann::json receive();
private:
    QMutex lock;
    QTcpSocket& socket;
    bool stoped = false;
    bool locked = false;
};

#endif // NOTIFICATIONRECEIVER_H
