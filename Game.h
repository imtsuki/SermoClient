#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QQuickItem>
#include <QTcpSocket>
#include <QString>
#include "NotificationReceiver.h"
#include <nlohmann/json.hpp>

class Game : public QObject
{
    Q_OBJECT
public:
    explicit Game(QObject *parent = nullptr);
    ~Game();
    QString pvpWord;

signals:
    void popupMessage(const QString& message);
    void loginFinished(int userType);
    void appendPlayer(const QString& username, const int level, const int experience, const int achievement, const bool online);
    void appendExaminer(const QString& username, const int level, const int numberWord);
    void pvpBegin();
    void inviteCame();
    void pvpFailed();
    void closePopup();

public slots:
    void login(const QString& username, const QString& password);
    void connect(const QString& hostname, quint16 port);
    void signup(const QString& username, const QString& password, int userType);
    void addWord(const QString& word);
    void getPlayerList();
    void getExaminerList();
    QString getMyInfo();
    int getNextRoundNumber();
    void sortPlayerListBy(const QString& key);
    void sortExaminerListBy(const QString& key);
    QVariantList startPVE(int round);
    void submitPVEResult(bool isPassed, int round, int exp);
    void startPVP(const QString& opponent);
    void acceptInvite();
    QString getPVPWord();
    void pvpSuccess();
    void submitPVPResult(bool isPassed, int exp);
private:
    QTcpSocket socket;
    int sessionId;

    void sendRequest(const nlohmann::json& request);
    nlohmann::json receiveResponse();

    NotificationReceiver *notification;

    nlohmann::json playerList;
    nlohmann::json examinerList;




};

#endif // GAME_H
