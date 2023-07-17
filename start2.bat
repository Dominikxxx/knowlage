@echo off

set  ip=0.0.0.0
set  port=3000
netstat  -ano|findstr %ip%:%port%|findstr -i LISTENING
if  ERRORLEVEL 1 (goto err)  else  (goto ok)
 
:err
echo  Port 3000 is not running
cd/d  e:/codesysknowlage && docsify serve

 
:ok  
echo  PortMap Services is running %Date:~0,4%-%Date:~5,2%-%Date:~8,2% %Time:~0,2%:%Time:~3,2%
cmd /k "cd/d C:/Program Files (x86)/Microsoft/Edge/Application && msedge.exe http://localhost:3000"