@taskkill /F /IM memcached.exe*  /T
memcached.exe -d -l 127.0.0.1 -p 11234 -vvv 2> error_11234.log > output_11234.log
memcached.exe -d -l 127.0.0.1 -p 11235 -vvv 2> error_11235.log > output_11235.log
memcached.exe -d -l 127.0.0.1 -p 11236 -vvv 2> error_11236.log > output_11236.log

memcached.exe -d -l 127.0.0.1 -p 15000 -vvv 2> error_15000.log > output_15000.log
