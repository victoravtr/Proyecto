import winrm
import sys
import os
import socket

try:
    CLI_IP = sys.argv[1]
    CLI_USER = sys.argv[2]
    CLI_PASSWORD = sys.argv[3]

    DOM_IP = sys.argv[4]
    DOM_USER = sys.argv[5]
    DOM_PASSWORD = sys.argv[6]
    DOM_NAME = sys.argv[7]

    IP_SERVER = socket.gethostbyname(socket.gethostname())

    URL_DESCARGA_SERVER = "http://" + IP_SERVER + "/uploads/join_domain.ps1"
    URL_DESCARGA_CLIENT = "C:\\Users\\" + CLI_USER + "\\join_domain.ps1"

    session = winrm.Session(CLI_IP, auth=(CLI_USER, CLI_PASSWORD))
    # Descargamos el archivo en el equipo objetivo
    COMMAND = "curl -o " + URL_DESCARGA_CLIENT + " " + URL_DESCARGA_SERVER
    session.run_ps(COMMAND)

    # Ejecutamos el archivo
    COMMAND = URL_DESCARGA_CLIENT + " " + CLI_IP + " " + DOM_IP + " " + DOM_USER + " " + DOM_PASSWORD + " " + DOM_NAME + " -Verb runas"
    r = session.run_ps(COMMAND)
    print(r.std_err)

    # Una vez instalado borramos el archivo
    COMMAND = "rm " + URL_DESCARGA_CLIENT
    session.run_ps(COMMAND)

    # Por ultimo lo borramos en el servidor
    os.remove("/var/www/html/uploads/join_domain.ps1")

    # Si todo sale bien el programa retorna un 0
    print("0")
except Exception as e:
    # Si algo sale mal el programa retorna un 1
    print("1")
