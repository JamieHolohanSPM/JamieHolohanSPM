echo off
rem Produces a script such as this one and gives the option to run it.
rem e.g.
rem scm login -r https://jazz031.hursley.ibm.com:9443/ccm -n jazz031 -u james.smith@ie.ibm.com -P password
rem scm create workspace -r jazz031 -s "CEF-Integration-6.2.0.2" james_CEF_6202
rem scm load -r jazz031 james_CEF_6202 -d C:\RTC-Dev\CEF_6202

echo -
echo -----------------------------------------
echo -  SCRIPT TO FILL IN THE BLANKS IN THIS -
echo -----------------------------------------
echo scm login -r https://jazz031.hursley.ibm.com:9443/ccm -n jazz031 -u USERNAME -P PASSWORD
echo scm create workspace -r jazz031 -s "REMOTE_STREAM_NAME" LOCAL_STREAM_NAME
echo scm load -r jazz031 LOCAL_STREAM_NAME -d LOCAL_DIR_FOR_STREAM
echo -----------------------------------------

:ENTER_RTC_USER
@echo What is your intranet id (USERNAME above)?  
set /p RTC_USER=
::Is string empty?
IF X%RTC_USER% == X GOTO:ENTER_RTC_USER

:ENTER_RTC_PW
@echo What is your intranet password (PASSWORD above)?   
set /p RTC_PW=
::Is string empty?
IF X%RTC_PW% == X GOTO:ENTER_RTC_PW

echo -----------------------------------------
echo FOR YOUR COPY n PASTING PLEASURE, HERE'S A LIST OF ALL REMOTE_STREAM_NAME's
echo ...
scm -a y list streams -r jazz031 -n "*-Integration-*" -m 50
echo -----------------------------------------

:ENTER_STREAM_NAME_RTC
@echo What is the full name of the stream within RTC (REMOTE_STREAM_NAME above)?
set /p STREAM_NAME_RTC=
::Is string empty?
IF X%STREAM_NAME_RTC% == X GOTO:ENTER_STREAM_NAME_RTC

scm login -r https://jazz031.hursley.ibm.com:9443/ccm -n jazz031 -u %RTC_USER% -P %RTC_PW%

:ENTER_STREAM_NAME_LOCAL
@echo What do you want to name your local stream (LOCAL_STREAM_NAME above)?
set /p STREAM_NAME_LOCAL=
::Is string empty?
IF X%STREAM_NAME_LOCAL% == X GOTO:ENTER_STREAM_NAME_LOCAL

rem scm create workspace -r jazz031 -s "%STREAM_NAME_RTC%" %STREAM_NAME_LOCAL%

:ENTER_LOCAL_PATH
@echo What is the full dir path to load the stream to locally (including the new root folder name - LOCAL_DIR_FOR_STREAM above)?
set /p LOCAL_PATH=
::Is string empty?
IF X%LOCAL_PATH% == X GOTO:ENTER_LOCAL_PATH
::Does string have a trailing slash?
IF %LOCAL_PATH:~-1%==\ GOTO:ENTER_LOCAL_PATH

rem scm load -r jazz031 %STREAM_NAME_LOCAL% -d %LOCAL_PATH%

echo -
echo -----------------------------------------
echo  NEW STREAM BATCH SCRIPT (INCL LOGIN WHICH WAS ALREADY RUN)   
echo -----------------------------------------
echo scm login -r https://jazz031.hursley.ibm.com:9443/ccm -n jazz031 -u %RTC_USER% -P %RTC_PW%
echo scm create workspace -r jazz031 -s "%STREAM_NAME_RTC%" %STREAM_NAME_LOCAL%
echo scm load -r jazz031 %STREAM_NAME_LOCAL% -d %LOCAL_PATH%
echo -----------------------------------------

GOTO:ENTER_RUN_PROG
:RUN_PROG
echo on
echo Turning echo on so you can see that the 'load' gets called but takes a few minutes to complete
rem scm login -r https://jazz031.hursley.ibm.com:9443/ccm -n jazz031 -u %RTC_USER% -P %RTC_PW%
scm create workspace -r jazz031 -s "%STREAM_NAME_RTC%" %STREAM_NAME_LOCAL%
scm load -r jazz031 %STREAM_NAME_LOCAL% -d %LOCAL_PATH%
echo off
GOTO:END

:ENTER_RUN_PROG
@echo Run (y/n)?
set /p RUN_PROG=
IF %RUN_PROG% == y GOTO:RUN_PROG
:END
echo on

