# ExegolLuncherWT

This script lists all containers from the "exegol" images present on the machine and allows the user to choose one to enter into exec mode with the /bin/zsh shell.

## Get the name of the exegol image
$imageName = Read-Host "Enter the name of the exegol image (example: nwodtuhs/exegol)"

## List all containers from the exegol image on the machine
$containers = docker ps --filter ancestor=$imageName --format "{{.Names}}"

## If only one container is available, choose it automatically
if ($containers.Count -eq 1) {
  $container = $containers[0]
} else {
  # Ask the user to choose a container
  Write-Host "Choose a container:"
  for ($i = 0; $i -lt $containers.Count; $i++) {
    Write-Host "$i: $($containers[$i])"
  }
  $containerIndex = Read-Host "Enter the index of the container"
  $container = $containers[$containerIndex]
}

## Execute the container in exec mode with the /bin/zsh shell
docker exec -it $container /bin/zsh
