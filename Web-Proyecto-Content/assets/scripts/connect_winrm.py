import winrm
import sys

try:
    s = winrm.Session(sys.argv[1], auth=(sys.argv[2], sys.argv[3]))
    r = s.run_cmd('ipconfig', ['/all'])
    print("0")
except Exception as e:
    print("1")
