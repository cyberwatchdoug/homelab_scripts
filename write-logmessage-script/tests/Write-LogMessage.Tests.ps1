# Pester tests for Write-LogMessage.ps1

#$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Describe "Write-LogMessage" {

    BeforeAll {
        . "$PSScriptRoot\..\src\Write-LogMessage.ps1"
    }
    AfterAll {
        if (Test-Path $script:testLogDir) { Remove-Item $script:testLogDir -Recurse -Force }
    }
    BeforeEach {
        $script:testLogDir = "$PSScriptRoot\test-logs"
        $script:testLogFile = "$script:testLogDir\test.log"
        if (Test-Path $script:testLogDir) { Remove-Item $script:testLogDir -Recurse -Force }
        New-Item -ItemType Directory -Path $script:testLogDir | Out-Null
        New-Item -ItemType File -Path $script:testLogFile | Out-Null
    }

    It "writes a log message to a file" {
        Write-LogMessage -Message "Test message" -LogFilePath $script:testLogFile -CreateLogPath -CreateLogFile | Out-Null
        (Get-Content $script:testLogFile) | Should -Match "Test message"
    }

    It "writes a log message with the correct log level" {
        Write-LogMessage -Message "Warning message" -LogFilePath $script:testLogFile -Level WARNING -CreateLogFile | Out-Null
        (Get-Content $script:testLogFile -Raw) | Should -Match "\[WARNING\] - Warning message"
    }

    It "writes to host when -WriteToHost is specified" {
        { Write-LogMessage -Message "Host message" -LogFilePath $script:testLogFile -WriteToHost -CreateLogFile } | Should -Not -Throw
    }

    It "returns the log message string" {
        $result = Write-LogMessage -Message "Return message" -LogFilePath $script:testLogFile -CreateLogFile
        $result | Should -Match "Return message"
    }

    It "creates log directory if -CreateLogPath is set" {
        $newDir = "$script:testLogDir\newdir"
        $newFile = "$newDir\log.txt"
        Write-LogMessage -Message "Dir create" -LogFilePath $newFile -CreateLogPath -CreateLogFile | Out-Null
        Test-Path $newDir | Should -BeTrue
        Test-Path $newFile | Should -BeTrue
    }

    It "throws error if log directory does not exist and -CreateLogPath is not set" {
        $badDir = "$script:testLogDir\bad"
        $badFile = "$badDir\log.txt"
        { Write-LogMessage -Message "Should fail" -LogFilePath $badFile -CreateLogFile -ErrorAction Stop} | Should -Throw
    }

    It "throws error if log file does not exist and -CreateLogFile is not set" {
        $noFile = "$script:testLogDir\nofile.log"
        if (Test-Path $noFile) { Remove-Item $noFile }
        { Write-LogMessage -Message "Should fail" -LogFilePath $noFile -CreateLogPath -ErrorAction Stop} | Should -Throw
    }

    It "uses custom timestamp format" {
        Write-LogMessage -Message "Custom time" -LogFilePath $script:testLogFile -TimestampFormat "yyyy" | Out-Null
        (Get-Content $script:testLogFile -Raw) | Should -Match "^\d{4} \[INFO\] - Custom time"
    }

    It "accepts pipeline input" {
        "Pipeline message" | Write-LogMessage -LogFilePath $script:testLogFile -CreateLogPath -CreateLogFile | Out-Null
        (Get-Content $script:testLogFile -Raw) | Should -Match "Pipeline message"
    }
}