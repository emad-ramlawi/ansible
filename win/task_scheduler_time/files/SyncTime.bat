net.exe Time \\10.226.18.5 /SET /YES
tzutil /s "Pacific Standard Time"
schtasks /Create /XML "C:\AnsTemp\SyncTime.xml" /TN "\Microsoft\SyncTime"
