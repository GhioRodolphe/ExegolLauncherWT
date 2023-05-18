# Function to get containers with matching image prefix
Function Get-Container {
    param ($imagePrefix)

    # Get the list of containers with the matching image prefix
    $containers = docker ps -a --format "{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"
    $index = 0
    # Filter the containers by the matching image prefix
    return $containers | Where-Object { $_ -match "^.*$imagePrefix-.*$" } |

        ForEach-Object {
            $containerData = $_ -split "\t"
            New-Object PSObject -Property @{
                Index  = $index
                ID     = $containerData[0]
                Image  = $containerData[1]
                Name  = $containerData[2]
                Status = $containerData[3]
            }
            $index ++
        }
}

# Function to manage a container
Function Invoke-ContainerManagement {
    param ($containerId, $status)

    # Check if container is not running and start it
    if ($status.Contains("Exited")) {
        Write-Host "Starting container '$containerId'..." -ForegroundColor Green
        docker start $containerId
    }

    Write-Host "Entering interactive mode for container '$containerId'..." -ForegroundColor Green
    docker exec -it $containerId /bin/zsh
}

Function Invoke-ExegolStart {
    Write-Host "Running 'exegol start' in interactive mode" -ForegroundColor Green
    exegol start
}

# Get the prefix of the image
$imagePrefix = "exegol"

# Get the matching containers
$matchingContainers = Get-Container -imagePrefix $imagePrefix

# Display the list of containers or launch Exegol if no containers are found
if ($matchingContainers.Count -eq 0) {
    Invoke-ExegolStart
} else {
    Write-Host "List of available containers:" -ForegroundColor Yellow
    $matchingContainers | Format-Table -AutoSize -Property Index, ID, Image, Names, Status

    # Ask the user to choose a container
    do {
        $choice = Read-Host "Choose a container index or press enter to run 'exegol start' in interactive mode "
        if ($choice -eq '') {
            Invoke-ExegolStart
            return
        }
        $chosenContainer = $matchingContainers | Where-Object { $_.Index -eq $choice }
        if ($null -eq $chosenContainer) {
            Write-Host "Invalid choice. Please enter a valid index." -ForegroundColor Red
        }
    } while ($null -eq $chosenContainer)

    Invoke-ContainerManagement -containerId $chosenContainer.ID -status $chosenContainer.Status
}
