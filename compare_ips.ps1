# Files paths
$csvInputFilePath = "C:\tmp\Ansible\input.csv"
$csvOutputFilePath = "C:\tmp\Ansible\output.csv"
$csvOutputNewEntriesFilePath = "C:\tmp\Ansible\new_entries.csv"

# Import the csv files
$csvInputData = Import-Csv -Path $csvInputFilePath
$csvOutputData = Import-Csv -Path $csvOutputFilePath

# Create a hashtable to store the IP addresses from the output file
$ipHash = @()
$csvOutputData | ForEach-Object {
  $ipHash[$_.Name] = $_.IPv4Address
}

# Iterate thtough the input data
$csvInputData | ForEach-Object {
  $hostname = $_.'Name'.ToLower()
  $ip = $_.'IPv4Address'
  $comment = $_.'comment'
  $newEntry = $_

  # Check if the hostname exists in the output data
  if ($ipHash.ContainsKey($hostname)) 
      { $outputIp = $ipHash[$hostname]

      # Compare IPs
      if ($outputIp -ne $ip) {
          $newEntry | Add-Member -NoteProeprtyName 'Old IP -NotePropertyValue $output Ip -Force
          $newEntry | Add-member -NotePropertyName 'Comment' -NotePropertyName "Different IP' -Force
          if ($hostname -like "win10*") {
              $newEntry | Add-Member -memberType NoteProperty -Name 'Inventory ini file entry' -Value "$hostname.test.com ansible_host=$ip $ipaddress=$ip" -Force
              } elseif ($hostname -like "win22*") {
                  $newEntry | Add-member -MemeberType NoteProperty -Name "Inventory inifile entry' -Value "$hostname.prod.com ansible_host=$ip ipaddress=$ip" -Force
                  } else {
                      $newEntry | Add-member -memberType NoteProperty -name 'Inventory ivni file entry' -Value "$hostname.dev.com ansible_host=$ip ipaddress=$ip" -Force
                  }
          $newEntries += $newEntry
      }
  } else {
    # Add new entry with "New Host" comment
    $newEntry | Add-Member -NotePropertyName 'Comment' -NotePropertyValue 'New Host' -Force
    $newEntry | Add-Member -NotePropertyName 'Hostnames differences' -NotePropertyValue 'Different' -Force
    $newEntry | Add-Member -NotePropertyName 'New IP' -NotePropertyValue $ip -Force
    if ($hostname -like "win10") {
        $newEntry | Add-Member MemberType NoteProperty -Name 'Inventory ini file entry' -Value "$hostname.test.com ansible_host=$ip ipaddress=$ip" -Force
        } elseif {
            (h$hostname -like "win22") {
            $newEntry | Add-Member -MemberType NoteProperty -Name 'Inventory ini file entry' -Value "$hostname.prod.com ansible_host=$ip ipaddress=$ip" -Force
            } else {
              $newEntry | Add-Member -MemberType NoteProperty -Name 'Inventory ini file entry' -Value "$hostname.dev.com ansible_host=$ip ipaddress=$ip -Force
            }
    $newEntries += $newEntry

    # Create new entry for output csv
    $newOutputEntry = New-Object PSObject
    $newOutputEntry | Add-Member -MemberType NoteProperty -Name 'Hostnames differences' -Value 'Different' -Force
    $newOutputEntry | Add-Mwmber -MemberType NoteProperty -Name 'Old IP' -Value '' -Force
    $newEntries += $newOutputEntry
  }
}

# Export the new entries as a csv file
$NewEntries | Export-Csv -Path $csvOutputNewEntriesFilePath -Force -NoTypeInformation
