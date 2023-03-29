#include "backend.h"
#include "qdebug.h"
#include <QFile>
#include <QTextStream>

BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
{
}

QString BackEnd::text()
{
    return m_text;
}

void BackEnd::setText(const QString &text)
{
    if (text == m_text)
        return;

    m_text = text;
    emit textChanged();
}
void BackEnd::writing(QString url, QString url2, QString info, QString lang, int n) {

    MyThread *thread = new MyThread;
    thread->start();
    QFile file(url);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
        qInfo() << "error writing";
    }
    QTextStream out(&file);
    out.setCodec("UTF-8");
    out.setGenerateByteOrderMark(true);
    out << info;
    file.flush();
    file.close();

//    QFile file2(folder + "/file.key");
    QFile file2(url2);
    qInfo() << lang << n;
    if (!file2.open(QFile::WriteOnly | QFile::Text)) {
        qInfo() << "error writing";
    }
    QTextStream out2(&file2);
    out2 << lang << n;
    file2.flush();
    file2.close();
    thread->wait();
}
