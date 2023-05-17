# Context
This PowerShell script is designed to be used with Windows Terminal for managing Docker containers that use the "[exegol](https://github.com/ThePorgs/Exegol)" image. It allows users to start these containers if necessary, enter the exec mode, and interact with them directly from the Windows Terminal. It serves as a convenience tool for individuals who frequently use these specific Docker containers.

# Operation
The script defines and uses three main functions:

Get-MatchingContainers: This function retrieves a list of all Docker containers whose image matches a given prefix.

Start-Container: This function starts a Docker container using its ID.

Exec-Container: This function enables exec mode for a Docker container using its ID, allowing the user to interact with the container.

When the script is run, it checks for Docker containers that match the "exegol" image prefix. If it finds only one matching container, the script will automatically start it (if it's not already running) and enable exec mode. If multiple matching containers are found, the script will prompt the user to select one. The selected container is then started (if necessary) and exec mode is enabled.

# Installation
To install and use this script with Windows Terminal, follow these steps:

* Navigate to Settings > Command line in Windows Terminal.

* Add this line, replacing <path_to_the_script> with the actual path to the script:

```powershell 
powershell.exe -noprofile -noexit  <path_to_the_script>\script.ps1
```

# Contribution
Contributions to improve this script are very welcome. Users are encouraged to open issues with their suggestions, questions or bug reports. If you wish to make a more substantial contribution, please feel free to propose a pull request (PR).

Please ensure that your code follows the existing style to keep the project as consistent as possible.

Thank you for your interest in improving this Docker container management script.

# Exegol ressources
* Github: https://github.com/ThePorgs/Exegol
* Documentation: https://exegol.readthedocs.io/en/latest/