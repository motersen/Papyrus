/*
    Copyright (C) 2014 Aseman
    http://aseman.co

    This project is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This project is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef ASEMANAPPLICATION_H
#define ASEMANAPPLICATION_H

#include "aseman_macros.h"

#include <QFont>
#include <QVariant>
#include <QCoreApplication>
#include <QClipboard>

#ifdef QT_GUI_LIB
#include <QIcon>
#endif

#if defined(QT_WIDGETS_LIB) && defined(DESKTOP_DEVICE)
#define DEFAULT_AAPP_TYPE AsemanApplication::WidgetApplication
#else
#if defined(QT_GUI_LIB)
#define DEFAULT_AAPP_TYPE AsemanApplication::GuiApplication
#else
#if defined(QT_CORE_LIB)
#define DEFAULT_AAPP_TYPE AsemanApplication::CoreApplication
#endif
#endif
#endif

class QSettings;
class AsemanApplicationPrivate;
class AsemanApplication : public QObject
{
    Q_OBJECT
    Q_ENUMS(ApplicationType)

    Q_PROPERTY(QString homePath     READ homePath     NOTIFY fakeSignal)
    Q_PROPERTY(QString appPath      READ appPath      NOTIFY fakeSignal)
    Q_PROPERTY(QString appFilePath  READ appFilePath  NOTIFY fakeSignal)
    Q_PROPERTY(QString logPath      READ logPath      NOTIFY fakeSignal)
    Q_PROPERTY(QString confsPath    READ confsPath    NOTIFY fakeSignal)
    Q_PROPERTY(QString tempPath     READ tempPath     NOTIFY fakeSignal)
    Q_PROPERTY(QString backupsPath  READ backupsPath  NOTIFY fakeSignal)
    Q_PROPERTY(QString cameraPath   READ cameraPath   NOTIFY fakeSignal)

    Q_PROPERTY(int appType READ appType NOTIFY fakeSignal)

    Q_PROPERTY(QFont globalFont READ globalFont WRITE setGlobalFont NOTIFY globalFontChanged)

    Q_PROPERTY(QString applicationName READ applicationName WRITE setApplicationName NOTIFY applicationNameChanged)
    Q_PROPERTY(QString applicationVersion READ applicationVersion WRITE setApplicationVersion NOTIFY applicationVersionChanged)
    Q_PROPERTY(QString organizationName READ organizationName WRITE setOrganizationName NOTIFY organizationNameChanged)
    Q_PROPERTY(QString organizationDomain READ organizationDomain WRITE setOrganizationDomain NOTIFY organizationDomainChanged)

    Q_PROPERTY(QString applicationDisplayName READ applicationDisplayName WRITE setApplicationDisplayName)
    Q_PROPERTY(QString platformName READ platformName STORED false)
    Q_PROPERTY(bool quitOnLastWindowClosed  READ quitOnLastWindowClosed WRITE setQuitOnLastWindowClosed)

public:
    enum ApplicationType {
        NoneApplication,
#ifdef QT_GUI_LIB
        GuiApplication,
#endif
#ifdef QT_CORE_LIB
        CoreApplication,
#endif
#ifdef QT_WIDGETS_LIB
        WidgetApplication
#endif
    };

    AsemanApplication();
    AsemanApplication(int &argc, char **argv, ApplicationType appType = DEFAULT_AAPP_TYPE);
    ~AsemanApplication();

    static QString homePath();
    static QString appPath();
    static QString appFilePath();
    static QString logPath();
    static QString confsPath();
    static QString tempPath();
    static QString backupsPath();
    static QString cameraPath();

    static QString applicationDirPath();
    static QString applicationFilePath();
    static qint64 applicationPid();

    static void setOrganizationDomain(const QString &orgDomain);
    static QString organizationDomain();
    static void setOrganizationName(const QString &orgName);
    static QString organizationName();
    static void setApplicationName(const QString &application);
    static QString applicationName();
    static void setApplicationVersion(const QString &version);
    static QString applicationVersion();
    static void setApplicationDisplayName(const QString &name);
    static QString applicationDisplayName();

    static QString platformName();

    static QStringList arguments();

    static void setQuitOnLastWindowClosed(bool quit);
    static bool quitOnLastWindowClosed();

    static QClipboard *clipboard();

#ifdef QT_GUI_LIB
    static void setWindowIcon(const QIcon &icon);
    static QIcon windowIcon();
#endif

    static bool isRunning();
    static int appType();

    static AsemanApplication *instance();
    static QCoreApplication *qapp();

    void setGlobalFont(const QFont &font);
    QFont globalFont() const;

    static QFont font();
    static void setFont(const QFont &f);

#ifdef QT_GUI_LIB
    static QPalette palette();
    static void setPalette(const QPalette &pal);
#endif

    static QSettings *settings();

    inline operator QCoreApplication*() const { return qapp(); }

public slots:
    void refreshTranslations();
    void back();
    int exec();
    static void exit(int retcode = 0);

    void sleep(quint64 ms);
    void sendMessage(const QString &msg);

    void setSetting( const QString & key, const QVariant & value );
    QVariant readSetting( const QString & key, const QVariant & defaultValue = QVariant() );

signals:
    void fakeSignal();
    void globalFontFamilyChanged();
    void globalMonoFontFamilyChanged();
    void globalFontChanged();
    void languageUpdated();
    void backRequest();
    void clickedOnDock();

    void organizationNameChanged();
    void organizationDomainChanged();
    void applicationNameChanged();
    void applicationVersionChanged();

    void lastWindowClosed();
    void messageReceived(const QString &msg);

protected:
    bool event(QEvent *e);

private:
    AsemanApplicationPrivate *p;
};

#endif // ASEMANAPPLICATION_H
