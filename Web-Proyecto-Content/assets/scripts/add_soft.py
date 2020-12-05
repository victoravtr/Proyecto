import winrm
import sys
import os
import socket

try:
    CLI_IP = sys.argv[1]
    CLI_USER = sys.argv[2]
    CLI_PASSWORD = sys.argv[3]

    FILE = sys.argv[4]


    IP_SERVER = socket.gethostbyname(socket.gethostname())

    URL_DESCARGA_SERVER = "http://" + IP_SERVER + "/uploads/" + FILE
    URL_DESCARGA_CLIENT = "C:\\Users\\" + CLI_USER + "\\" + FILE

    # Creamos una sesion
    session = winrm.Session(CLI_IP, auth=(CLI_USER, CLI_PASSWORD))
    
    # Descargamos el archivo en el equipo objetivo
    COMMAND = "curl -o " + URL_DESCARGA_CLIENT + " " + URL_DESCARGA_SERVER
    session.run_ps(COMMAND)

    # Comprobamos si es un exe o un msi
    if FILE[-3:] == "msi":
        COMMAND = "msi.exe /i " + URL_DESCARGA_CLIENT + " /qn"
        session.run_ps(COMMAND)
    elif FILE[-3:] == "exe":
        # Comprobar si su product name esta en el archivo exe_switch
        # Si lo esta lo usamos como switch, si no el default
        DEFAULT_SWITCH = "/qn"
        SWITCH = DEFAULT_SWITCH
        PRODUCT_NAME = os.system("exiftool " + FILE + " | grep \"Product Name\" | cut -d \":\" -f 2 | xargs")
        COINCIDENCIA = os.system("cat /var/proyecto/general/exe_switch | grep " + FILE)
        
        if PRODUCT_NAME != "" and COINCIDENCIA != "":
            SWITCH = str(os.system("cat /var/proyecto/general/exe_switch | grep " + str(PRODUCT_NAME) + " | cut -d \":\" -f 2"))
        
        COMMAND = "Start-Process -FilePath " + URL_DESCARGA_CLIENT + " -ArgumentList " + SWITCH + " -PassThru -Verb runas"
        r = session.run_ps(COMMAND)
    else:
        raise Exception("Tipo de archivo no permitido")

    # Una vez instalado borramos el archivo
    COMMAND = "rm " + URL_DESCARGA_CLIENT
    session.run_ps(COMMAND)

    # Por ultimo lo borramos en el servidor
    os.remove("/var/www/html/uploads/" + FILE)

except Exception as e:
    # Si algo sale mal el programa retorna un 1
    print(e)
