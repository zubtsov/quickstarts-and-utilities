Function Get-AllNestedGitRepos
{
    param (
        [Parameter(Mandatory = $false)]
        [string]$path = "."
    )

    Get-ChildItem -Path $path | ForEach-Object -Process {
        if ($_.PSIsContainer)
        {
            $currentDir = $_.PSPath
            $gitDirPath = (Join-Path -Path $currentDir -ChildPath ".git")
            $isGitRepo = (Test-Path -Path $gitDirPath -PathType Container)

            if ($isGitRepo)
            {
                $_
            }
            else
            {
                Write-Debug "Recursively checking subfolder of the current folder '$( $currentDir )'"
                Get-AllNestedGitRepos -Path $currentDir
            }
        }
        else
        {
            Write-Debug "Skipping '$( $_.PSPath )' as it's not a directory"
        }
    }
}

Function Invoke-CommandForNestedGitRepos
{
    param (
        [Parameter(Mandatory = $false)]
        [string]$gitCommand = "git status"
    )

    Get-AllNestedGitRepos | ForEach-Object -Process {
        $gitRepoDir = $_.PSPath
        Push-Location -Path $gitRepoDir
        try
        {
            Write-Debug "Executing: '$( $gitCommand )' inside '$( $gitRepoDir )'"
            Invoke-Expression $gitCommand
        }
        catch
        {
            Write-Output "'$( $gitCommand )' threw an exception:"
            Write-Output $_
        }
        Pop-Location
    }
}
