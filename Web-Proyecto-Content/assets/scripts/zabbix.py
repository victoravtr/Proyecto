import winrm
import sys

try:
    CLI_IP = sys.argv[1]
    CLI_USER = sys.argv[2]
    CLI_PASSWORD = sys.argv[3]
    URL_DESCARGA_CONFIG = sys.argv[4]
    URL_DESCARGA_EXE = sys.argv[5]

    session = winrm.Session(CLI_IP, auth=(CLI_USER, CLI_PASSWORD))

    # Descargar archivos en equipo
    COMMAND="curl -o C:\\Users\\" + CLI_USER + "\zabbix_agentd.conf " + URL_DESCARGA_CONFIG
    session.run_ps(COMMAND)
    COMMAND="curl -o C:\\Users\\" + CLI_USER + "\zabbix_agentd.exe " + URL_DESCARGA_EXE
    session.run(COMMAND)

    # Borramos el servicio Zabbix Agent si lo hubiese
    COMMAND = "sc.exe delete \"Zabbix agent\""
    session.run(COMMAND)

    # Ejecutamos el instalador
    COMMAND = "C:\\Users\\" + CLI_USER + "\\zabbix_agentd.exe  --config C:\\Users\\" + CLI_USER +"\\zabbix_agentd.conf --install"
    session.run(COMMAND)

    #Editamos el servicio para que se inicie de forma automatica
    COMMAND="Set-Service \"Zabbix Agent\" -startuptype automatic"
    session.run(COMMAND)

    print("0")
except Exception as e:
    print("1")