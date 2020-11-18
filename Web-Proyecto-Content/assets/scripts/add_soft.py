import winrm
import sys
import os

try:
    IP = sys.argv[1]
    USER = sys.argv[2]
    PASS = sys.argv[3]
    FILE = sys.argv[4]
    URL_DESCARGA_SERVER = "http://" + IP + "/uploads/" + FILE
    URL_DESCARGA_CLIENT = "C:\Users" + USER + "\\" + FILE

    s = winrm.Session(IP, auth=(USER, PASS))

    # Descargamos el archivo en el equipo objetivo
    COMMAND = "curl -o " + URL_DESCARGA_CLIENT + " " + URL_DESCARGA_SERVER
    session.run_ps(COMMAND)

    # Ejecutamos el archivo
    COMMAND = "Start-Process -Wait -FilePath " + URL_DESCARGA_CLIENT + " -ArgumentList /S -PassThru"
    session.run_ps(COMMAND)

    # Una vez instalado borramos el archivo
    COMMAND = "rm " + URL_DESCARGA_CLIENT
    session.run_ps(COMMAND)

    # Por ultimo lo borramos en el servidor
    os.remove(URL_DESCARGA_SERVER)
    
    # Si todo sale bien el programa retorna un 0
    print("0")
except Exception as e:
    # Si algo sale mal el programa retorna un 1
    print("1")