######################################################################################################################################
# created by Elias 3-3-20
# last modified by Elias on 3-3-20                                                     
#
# This script gets the time every computer was last restarted.
# To do this locally, you can use the following code and run it as a script:
#
# Import-Module ActiveDirectory
#
# ForEach ($computer in Get-ADComputer -Filter *) {
#
# Get-WmiObject Win32_OperatingSystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
#
# }
#
#
# Why would you want this you say? Because people will lie about rebooting and blame us for things not working.
# For example: drives missing, slow computer, no updates going through, etc.
# Also, we keep telling people to reboot and they are not doing it, so this can be used to show statistics/numbers.
# For the users that do not reboot, we can force one via group policy.
# Working to improve this script by running it automatically every month, checking what users have not rebooted in 30+ days, then forcing a reboot on those users
######################################################################################################################################




#import AD module to work in AD environment
Import-Module ActiveDirectory

#For each computer that is found via the Get-ADComputer command, do the following:
#Use WMI to get information. The command needs a computer name to point to and scan. In this case, we need to scan every single computer. Therefore, you will use the Name value that was found in every computer scanned via Get-ADComputer.
#Ignore errors and keep going.
#Look in for the LastBoottimeValue in the csname of said computer, then convert the date into something we can easily read.
#make a variable called results so that you can export all of the results to a CSV file. Otherwise, script does not know what to export.
ForEach ($computer in (Get-ADComputer -Filter *)) {
Get-WmiObject Win32_OperatingSystem -ComputerName $computer.Name | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} | Export-Csv C:\Users\elmartinez\documents\UptimeReport.csv -NoTypeInformation -Encoding UTF8 -Append
}


