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

# Get the prefix of the image
$imagePrefix = "nwodtuhs/exegol"

# Get the matching containers
$matchingContainers = Get-MatchingContainers -imagePrefix $imagePrefix

# If no containers are available, display an error message
if ($null -eq $matchingContainers) {
    Write-Host "No containers with image prefix '$imagePrefix' found." -ForegroundColor Red
    return
}

# If only one container is available, enter exec mode directly
if ($matchingContainers.Count -eq 1) {
    $matchingContainers = $matchingContainers -split "\t"

    if ($matchingContainers[3].Contains("Exited")) {
        Start-Container -containerId $matchingContainers[0]
    }
    Exec-Container -containerId $matchingContainers[0]
    return
}

# If multiple containers are available, display the list and allow the user to choose a container
Write-Host "List of available containers:"
for ($i = 0; $i -lt $matchingContainers.Count; $i++) {
    $containerArray = $matchingContainers[$i] -split "\t"
    $containerId = $containerArray[0]
    $containerImage = $containerArray[1]
    $containerNames = $containerArray[2]
    Write-Host "${i} : $containerImage`t$containerNames" -ForegroundColor Yellow
}

# Ask the user to choose a container
$choice = Read-Host "Choose a container (number) "

# Start the container if necessary and enter exec mode for the chosen container
$containerIdArray = $matchingContainers[$choice] -split "\t"
if ($containerIdArray[3].Contains("Exited")) {
    Start-Container -containerId $containerIdArray[0]
}
Exec-Container -containerId $containerIdArray[0]
