import winrm
import sys

try:
    CLI_IP = sys.argv[1]
    CLI_USER = sys.argv[2]
    CLI_PASSWORD = sys.argv[3]

    session = winrm.Session(CLI_IP, auth=(CLI_USER, CLI_PASSWORD))
    COMMAND="Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.0.3-1.msi -OutFile wazuh-agent.msi; ./wazuh-agent.msi /qn WAZUH_MANAGER='" + SERVER_IP + "' WAZUH_REGISTRATION_SERVER='" + SERVER_IP + '"
    session.run_ps(COMMAND)
except Exception as e:
    # Si algo sale mal el programa retorna un 1
    print(e)
