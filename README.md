# Context

This PowerShell script, designed for Windows Terminal, assists in managing Docker containers utilizing the "[exegol](https://github.com/ThePorgs/Exegol)" image. This tool provides an easy interface to start containers, launch them in exec mode, and interact directly from the Windows Terminal. It is particularly useful for individuals who frequently work with these specific Docker containers.

# Functionality

The script employs several functions:

1. `Get-Container`: This function retrieves a list of all Docker containers with an image name that matches a given prefix.

2. `Invoke-ContainerManagement`: This function manages a Docker container using its ID. If the container isn't running, it starts it. Then, it launches the container in interactive mode.

3. `Invoke-ExegolStart`: This function runs the 'exegol start' command in interactive mode.

When the script is executed, it locates Docker containers that align with the "exegol" image prefix. If it finds multiple matching containers, the script will display a list of these containers, asking the user to select one. The chosen container is started (if needed) and the interactive mode is enabled.

# Installation

To use this script with the Windows Terminal, follow the instructions below:

* Navigate to `Settings > Command line` in Windows Terminal.

* Insert the following line, substituting `<path_to_the_script>` with the exact path to the script:

```powershell 
powershell.exe -noprofile -noexit <path_to_the_script>\script.ps1
```

# Contribution

We encourage contributions to enhance this script. Users can open issues to suggest improvements, ask questions, or report bugs. For those wishing to make significant contributions, feel free to propose a pull request (PR).

Please ensure your code adheres to the existing style for the sake of consistency within the project.

Thank you for your interest in improving this Docker container management script.

# Exegol Resources

* GitHub: [Exegol on GitHub](https://github.com/ThePorgs/Exegol)
* Documentation: [Exegol Documentation](https://exegol.readthedocs.io/en/latest/)