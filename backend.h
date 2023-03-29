#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <QThread>
#include <qqml.h>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    QML_ELEMENT

public:
    explicit BackEnd(QObject *parent = nullptr);

    QString text();
    Q_INVOKABLE void writing(QString url, QString url2, QString info, QString lang, int n);
    void setText(const QString &text);

signals:
    void textChanged();

private:
    QString m_text;
};

class MyThread : public QThread {
private:
    void run() override {}
};


#endif // BACKEND_H
