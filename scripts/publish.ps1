param (
  [Parameter(Mandatory=$true)][string]$PACKAGE_PATH
)

# Check if $ErrorActionPreference is set to Stop to ensure the script stops immediately upon error
$ErrorActionPreference = "Stop"

# Setting environment variables
$envContent = Get-Content -Path "./env.sh"

# Iterate through each line of the file
foreach ($line in $envContent) {
    # Extract variable name and value
    if ($line -match '^export\s+(\w+)="(.*)"$') {
        $variableName = $Matches[1]
        $variableValue = $Matches[2]
        
        # Set environment variable using 'Set-Item' cmdlet
        Set-Item -Path "env:$variableName" -Value $variableValue
    }
}

# Check if $env:VARIABLE_NAME is set, if not, print an error message and exit with status 1
if (-not $PACKAGE_PATH) { Write-Host "PACKAGE_PATH needs to be set"; exit 1 }
if (-not $env:GIT_USER_EMAIL) { Write-Host "GIT_USER_EMAIL needs to be set"; exit 1 }
if (-not $env:GIT_USER_NAME) { Write-Host "GIT_USER_NAME needs to be set"; exit 1 }
if (-not $env:PACKAGE_VERSION) { Write-Host "PACKAGE_VERSION needs to be set"; exit 1 }

Write-Output "publishing ${PACKAGE_PATH} ..."
Set-Location ${PACKAGE_PATH}
# Publishing causes to change .versions file. That is why git commit happens after
meteor publish
git config user.email "$GIT_USER_EMAIL"
git config user.name "$GIT_USER_NAME"
git add --all
git commit -m "Meteor package bump version $env:PACKAGE_VERSION"
git push origin master
git tag -a v$env:PACKAGE_VERSION -m "bump version $env:PACKAGE_VERSION"
git push --tags