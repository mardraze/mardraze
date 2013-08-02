echo off
taskkill /F /IM memcached.exe*  /T
c:\memcached\memcached.exe -d -l 127.0.0.1 -p 11234 -vvv 2> error_11234.log > output_11234.log
c:\memcached\memcached.exe -d -l 127.0.0.1 -p 11235 -vvv 2> error_11235.log > output_11235.log
c:\memcached\memcached.exe -d -l 127.0.0.1 -p 11236 -vvv 2> error_11236.log > output_11236.log

