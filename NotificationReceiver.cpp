#include "NotificationReceiver.h"
#include "Game.h"

NotificationReceiver::NotificationReceiver(QTcpSocket& socket) : socket(socket)
{

}

void NotificationReceiver::run() {
    auto game = ((Game *)parent());
    while (!stoped) {
        this->msleep(10);
        lock.lock();
        if (socket.bytesAvailable()) {
            auto message = receive();
            if (message["type"] == "invite") {
                emit game->inviteCame();
            }
            if (message["type"] == "opponentAccepted") {
                emit game->closePopup();
                game->pvpWord = QString::fromStdString(message["pvpWord"]);
                emit game->pvpBegin();

            }
            if (message["type"] == "opponentSuccess") {
                emit game->pvpFailed();
            }


        }
        lock.unlock();
    }
}

void NotificationReceiver::pause() {
    if (!locked) {
        lock.lock();
        locked = true;
    }
}

void NotificationReceiver::resume() {
    if (locked) {
        lock.unlock();
        locked = false;
    }
}

void NotificationReceiver::stop() {
    stoped = true;
}

nlohmann::json NotificationReceiver::receive() {
    char c;
    std::string raw = "";
    while (true) {
        auto result = socket.read(&c, 1);
        if (result != 1) {
            qDebug() << result;
            return {{"status", "error"}, {"errorMsg", "TCP Receive Error"}};
        }
        if (c == '\0') {
            break;
        }
        raw += c;
    }
    qDebug() << raw.c_str();
    return nlohmann::json::parse(raw);
}
