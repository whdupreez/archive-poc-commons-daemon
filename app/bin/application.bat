@echo off
setlocal

REM ---------------------------------------------------------------------------
REM  Manages the application service.
REM
REM  Copyright 2014 Willy du Preez
REM ---------------------------------------------------------------------------

REM TODO Install as User

REM ---------------------------------------------------------------------------
REM  Initialize
REM ---------------------------------------------------------------------------

REM - Determine the location of APP_HOME.
if [%APP_HOME%]==[] (
   set "BATCH_DIR=%~dp0%"
   pushd %BATCH_DIR%..
   set "APP_HOME=%CD%"
   popd
   set BATCH_DIR=
)

REM - Set the prunsrv.exe executable and defaults.
set "PRUNSRV=%APP_HOME%\system\daemon\windows\prunsrv.exe"

set LOG_PATH=%APP_HOME%\data\log
set LOG_LEVEL=INFO

set STOP_TIMEOUT=30

set STARTUP_MODE=manual

REM - Load the Service Configuration.
if [%APPLICATION_CONF%]==[] (
   set "APPLICATION_CONF=%APP_HOME%\bin\application.conf.bat"
)
if exist "%APPLICATION_CONF%" (
   call "%APPLICATION_CONF%" %*
) else (
   echo Error: Config file not found "%APPLICATION_CONF%"
   goto :eof
)

REM ---------------------------------------------------------------------------
REM  Determine Command
REM ---------------------------------------------------------------------------

if [%1]==[]              goto cmdUsage
if /I [%1]==[install]    goto cmdInstall
if /I [%1]==[uninstall]  goto cmdUninstall
if /I [%1]==[update]     goto cmdUpdate
if /I [%1]==[run]        goto cmdRun
if /I [%1]==[start]      goto cmdStart
if /I [%1]==[stop]       goto cmdStop
if /I [%1]==[restart]    goto cmdRestart

goto :cmdUsage

REM ---------------------------------------------------------------------------
REM  Execute Command
REM ---------------------------------------------------------------------------

:cmdUsage

echo(
echo Manages the application service.
echo(
echo SERVICE install^|uninstall^|start^|stop^|restart [args]
echo(
echo   install       Installs the service.
echo   uninstall     Uninstalls the service.
echo   update        Updates the service parameters.
echo   run           Run as console application.
echo   start         Starts the service.
echo   stop          Stops the service.
echo   restart       Stops and starts the service.
echo(
echo   [args]        Command specific arguments. See description below.
echo(
echo(
echo Install args:
echo(
echo   test          Test

goto :eof

:cmdInstall

%PRUNSRV% install %APP_NAME%^
 --DisplayName=%APP_DISPLAYNAME%^
 --Description %APP_DESCRIPTION%^
 --LogLevel=%LOG_LEVEL% --LogPath="%LOG_PATH%" --LogPrefix=service^
 --StdOutput=auto --StdError=auto^
 --Classpath=%APP_HOME%\..\target\commons-daemon-0.0.1-SNAPSHOT.jar^
 --StartMode=Java --StartClass=com.willydupreez.poc.daemon.DaemonLauncher^
 --StopMode=Java --StopClass=com.willydupreez.poc.daemon.DaemonLauncher^
 --StopTimeout=%STOP_TIMEOUT%^
 --Startup=%STARTUP_MODE%^
 --PidFile=app-pid

goto :eof

:cmdUninstall

%PRUNSRV% stop %APP_NAME%
if [%errorlevel%]==[0] (
   %PRUNSRV% delete %APP_NAME%
) else (
   echo Failed to stop %APP_NAME%
)

goto :eof

:cmdUpdate

%PRUNSRV% stop %APP_NAME%
if [%errorlevel%]==[0] (
   %PRUNSRV% update %APP_NAME%
) else (
   echo Failed to stop %APP_NAME%
)

goto :eof

:cmdRun

%PRUNSRV% run %APP_NAME%

goto :eof

:cmdStart

%PRUNSRV% start %APP_NAME%

goto :eof

:cmdStop

%PRUNSRV% stop %APP_NAME%

goto :eof

:cmdRestart

%PRUNSRV% stop %APP_NAME%
if [%errorlevel%]==[0] (
   %PRUNSRV% start %APP_NAME%
) else (
   echo Failed to stop %APP_NAME%
)

goto :eof