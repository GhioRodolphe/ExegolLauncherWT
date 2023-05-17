# Function to get containers with matching image prefix
Function Get-MatchingContainers {
    param ($imagePrefix)

    # Get the list of containers with the matching image prefix
    $containers = docker ps -a --format "{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"

    # Filter the containers by the matching image prefix
    $matchingContainers = @()

    foreach ($container in $containers) {
        if ($container -match "^.*$imagePrefix.*$") {
            $matchingContainers += $container
        }
    }

    return $matchingContainers
}

# Function to start a container
Function Start-Container {
    param ($containerId)

    Write-Host "Starting container '$containerId'..." -ForegroundColor Green
    docker start $containerId
}

# Function to enter exec mode for a container
Function Exec-Container {
    param ($containerId)

    Write-Host "Entering exec mode for container '$containerId'..." -ForegroundColor Green
    docker exec -it $containerId /bin/zsh
}

Function Exegol-Start {
    Write-Host "Running 'exegol start' in interactive mode" -ForegroundColor Green
    exegol start
}

Function Choose-Container {
    param ($containers)

    # If no containers are available, display an error message
    if ($null -eq $matchingContainers) {
        Write-Host "No containers with image prefix '$imagePrefix' found." -ForegroundColor Red
        Exegol-Start
    }
    else {
        # Display the list and allow the user to choose a container
        Write-Host "List of available containers:"
        $index = 0
        foreach ($container in $containers) {
            $containerArray = $container -split "\t"
            $containerImage = $containerArray[1]
            $containerNames = $containerArray[2]
            Write-Host "${index} : $containerImage`t$containerNames" -ForegroundColor Yellow
            $index++
        }

        # Ask the user to choose a container
        $choice = Read-Host "Choose a container index or press enter to run 'exegol start' in interactive mode "

        if ($choice -eq '') {
            Exegol-Start
        }
        else {
            $choice = [int]$choice

            if ($choice -ge $index) {
                Write-Host "This container does not exist" -ForegroundColor Red
                Choose-Container -containers $containers
            }
            else {
                # Start the container if necessary and enter exec mode for the chosen container
                $containerIdArray = $matchingContainers[$choice] -split "\t"
                if ($containerIdArray[3].Contains("Exited")) {
                    Start-Container -containerId $containerIdArray[0]
                }
                Exec-Container -containerId $containerIdArray[0]
            }
        }
    }
}

# Get the prefix of the image
$imagePrefix = "nwodtuhs/exegol"

# Get the matching containers
[array]$matchingContainers = Get-MatchingContainers -imagePrefix $imagePrefix

Choose-Container -containers $matchingContainers