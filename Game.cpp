#include "Game.h"
#include <QDebug>
#include <algorithm>

Game::Game(QObject *parent) : QObject(parent)
{
    connect("127.0.0.1", 5678);
    notification = new NotificationReceiver(this->socket);
    notification->setParent(this);
    notification->start();
}

Game::~Game() {
    notification->stop();
    notification->wait();
}

void Game::sendRequest(const nlohmann::json& request) {
    notification->pause();
    auto wrapped = request;
    if (wrapped["type"] != "connect") {
        wrapped["sessionId"] = sessionId;
    }
    auto dump = wrapped.dump();
    socket.write(dump.c_str(), dump.size() + 1);
    socket.waitForBytesWritten();
}

nlohmann::json Game::receiveResponse() {
    char c;
    std::string raw = "";
    socket.waitForReadyRead();
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
    notification->resume();
    return nlohmann::json::parse(raw);
}

void Game::connect(const QString& hostname, quint16 port) {
    socket.connectToHost(hostname, port);
    sendRequest({
                    {"type", "connect"},
                });
    auto response = receiveResponse();
    std::string s = response.dump();
    qDebug() << s.c_str();
    if (response["status"] == "success") {
        this->sessionId = response["sessionId"];
        qDebug() << "SessionId: " << sessionId;
    }

}

void Game::login(const QString& username, const QString& password) {
    sendRequest({
                    {"type", "login"},
                    {"body", {
                         {"username", username.toStdString()},
                         {"password", password.toStdString()}
                     }}
                });

     auto response = receiveResponse();
     if (response["status"] == "error") {
         emit popupMessage(QString::fromStdString(response["errorMsg"]));
     } else {
         emit loginFinished(response["userType"]);
     }
}

void Game::signup(const QString& username, const QString& password, int userType) {
    sendRequest({
                    {"type", "register"},
                    {"body", {
                         {"username", username.toStdString()},
                         {"password", password.toStdString()},
                         {"userType", userType},
                     }}
                });

     auto response = receiveResponse();
     if (response["status"] == "error") {
         emit popupMessage(QString::fromStdString(response["errorMsg"]));
     } else {
         emit popupMessage("注册成功！");
     }
}

void Game::addWord(const QString& word) {
    sendRequest({
                    {"type", "addWord"},
                    {"body", {
                         {"word", word.toStdString()}
                     }}
                });

     auto response = receiveResponse();
     if (response["status"] == "error") {
         emit popupMessage(QString::fromStdString(response["errorMsg"]));
     } else {
         emit popupMessage("出题成功！");
     }
}

void Game::getPlayerList() {
    sendRequest({
                    {"type", "playerList"}

                });

     auto response = receiveResponse();
     if (response["status"] == "error") {
         emit popupMessage(QString::fromStdString(response["errorMsg"]));
         return;
     }
     playerList = response.at("body");
     for (auto p: playerList) {
         emit appendPlayer(
                     QString::fromStdString(p["username"]),
                     p["level"],
                     p["experience"],
                     p["achievement"],
                     p["online"]);
     }
}

void Game::getExaminerList() {
    sendRequest({
                    {"type", "examinerList"}

                });

     auto response = receiveResponse();
     if (response["status"] == "error") {
         emit popupMessage(QString::fromStdString(response["errorMsg"]));
         return;
     }
     examinerList = response.at("body");
     using jtype = decltype (*examinerList.begin());
     std::sort(examinerList.begin(), examinerList.end(), [&](jtype a, jtype b) {
         int c = a["level"];
         int d = b["level"];
         qDebug() << c << d;
         return c > d;
     });
     for (auto p: examinerList) {
         emit appendExaminer(
                     QString::fromStdString(p["username"]),
                     p["level"],
                     p["numberWord"]);
     }
}

void Game::sortPlayerListBy(const QString& key) {
    std::string keyString = key.toStdString();
    using jtype = decltype(*playerList.begin());
    static bool order = true;
    std::sort(playerList.begin(), playerList.end(), [&](jtype a, jtype b) {
        return order ^ (a[keyString] > b[keyString]);
    });
    for (auto p: playerList) {
        emit appendPlayer(
                    QString::fromStdString(p["username"]),
                    p["level"],
                    p["experience"],
                    p["achievement"],
                    p["online"]);
    }
    order = !order;
}

void Game::sortExaminerListBy(const QString& key) {
    std::string keyString = key.toStdString();
    using jtype = decltype(*examinerList.begin());
    static bool order = true;
    std::sort(examinerList.begin(), examinerList.end(), [&](jtype a, jtype b) {
        return order ^ (a[keyString] > b[keyString]);
    });
    for (auto p: examinerList) {
        emit appendExaminer(
                    QString::fromStdString(p["username"]),
                    p["level"],
                    p["numberWord"]);
    }
    order = !order;
}

QString Game::getMyInfo() {
    sendRequest({
                    {"type", "info"}

                });
    auto response = receiveResponse();
    if (response["status"] == "error") {
        emit popupMessage(QString::fromStdString(response["errorMsg"]));
        return QString("");
    }
    if (response["body"]["userType"] == 0) {
        return QString("昵称：%1\n等级：%2\n经验值：%3\n闯关数：%4\n")
                .arg(QString::fromStdString(response["body"]["nickname"].get<std::string>()))
                .arg(response["body"]["level"].get<int>())
                .arg(response["body"]["experience"].get<int>())
                .arg(response["body"]["achievement"].get<int>())
                ;
    } else {
        return QString("昵称：%1\n等级：%2\n出题数：%3\n")
                .arg(QString::fromStdString(response["body"]["nickname"].get<std::string>()))
                .arg(response["body"]["level"].get<int>())
                .arg(response["body"]["number_word"].get<int>())
                ;
    }
}

int Game::getNextRoundNumber() {
    sendRequest({
                    {"type", "info"}

                });
    auto response = receiveResponse();
    int nextRound = response["body"]["achievement"];
    nextRound++;
    return nextRound;
}

QVariantList Game::startPVE(int round) {
    sendRequest({
                    {"type", "pve"},
                    {"body", {
                         {"round", round}
                     }}

                });
    auto response = receiveResponse();
    QVariantList wordList;
    for (auto& word: response["body"]) {
        wordList.append(QString::fromStdString(word));
    }

    return wordList;
}

void Game::submitPVEResult(bool isPassed, int round, int exp) {
    sendRequest({
                    {"type", "pveResult"},
                    {"body", {
                         {"isPassed", isPassed},
                         {"round", round},
                         {"exp", exp}
                     }}
                });
     auto response = receiveResponse();
     emit popupMessage(isPassed? QString("恭喜通关！获得经验值：%1").arg(exp) : "很遗憾，未通关……获得经验值：0");
}

void Game::startPVP(const QString& opponent) {
    sendRequest({
                    {"type", "pvp"},
                    {"body", {
                         {"opponent", opponent.toStdString()},
                     }}
                });
    auto response = receiveResponse();
    if (response["status"] == "error") {
        emit popupMessage(QString::fromStdString(response["errorMsg"]));
        return;
    }
    emit popupMessage("等待对手接受邀请……");
}

void Game::acceptInvite() {
    sendRequest({
                    {"type", "acceptInvite"},
                });
    auto response = receiveResponse();
    pvpWord = QString::fromStdString(response["body"]["pvpWord"]);
    emit pvpBegin();
}

QString Game::getPVPWord() {
    return pvpWord;
}

void Game::submitPVPResult(bool isPassed, int exp) {
    sendRequest({
                    {"type", "pvpResult"},
                    {"body", {
                         {"isPassed", isPassed},
                         {"exp", exp}
                     }}
                });
     auto response = receiveResponse();
     emit popupMessage(isPassed? QString("恭喜战胜对手！获得经验值：%1").arg(exp) : "很遗憾，未能战胜对手……获得经验值：0");
}

void Game::pvpSuccess() {
    sendRequest({
                    {"type", "pvpSuccess"},
                });
    auto response = receiveResponse();
}
