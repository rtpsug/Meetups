# PSGraph
#region setup
break;
CD C:\workspace\PSGraphPresentation
#endregion

#region Intro
@{
    Topic     = 'Working with PSGraph'
    Presenter = 'Kevin Marquette'
    Title     = 'Sr. DevOps Engineer'

    Email     = 'kevmar@gmail.com'
    Twitter   = '@kevinmarquette'
    Blog      = 'kevinmarquette.github.io'
    Github    = 'github.com/kevinmarquette/psgraph'

    ThisDemo  = 'https://github.com/KevinMarquette/PSGraphPresentation'
}



#endregion
#region GraphViz
    start 'http://www.graphviz.org'
    start 'http://www.graphviz.org/Gallery.php'


#endregion
#region Installing PSGraph

    # Install GraphViz from the Chocolatey repo
    Register-PackageSource -Name Chocolatey -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/
    Find-Package graphviz | Install-Package -ForceBootstrap

    # Install PSGraph from the Powershell Gallery
    Find-Module PSGraph -Repository PSGallery | Install-Module

    # Import Module
    Import-Module PSGraph
 
    Get-Command -Module PSGraph

#endregion
#region Getting Started

# basic graph
Graph {

    Node -Name Home
    Node -Name Work

    Edge -From Home -To Work

} | Export-PSGraph -DestinationPath $env:TEMP\graph.png

Start $env:TEMP\graph.png



# Node is optional
# Auto show graph
Graph {

    Edge -From Home -To Work
    Edge -From Work -To Home

} | Export-PSGraph -ShowGraph


# Save to variable first
$graph = Graph {
    Edge -From Home -To Work
    Edge -From Work -To Home
}
$graph | Export-PSGraph -ShowGraph


# Positional Parameters
# Sequential edges in list of nodes
Graph {

    Edge Home -To Work
    Edge a,b,c,d,a 

} | Export-PSGraph -ShowGraph


# edge attributes
Graph {

    Edge Home Work -Attributes @{label='car';color='red'}
    Edge Work Home @{color='blue'}

} | Export-PSGraph -ShowGraph


# node attributes
Graph {

    Node -Name Home -Attributes @{shape='house';label='My House'}
    Node Work @{label='loanDepot'}

    Edge Home Work
    Edge Work Home

} | Export-PSGraph -ShowGraph


# More node attributes
Graph {

    Node Home @{
        URL='http://www.google.com'
        color='blue'
        comment='comment'
        fontcolor='red'
        fontsize='14.0'
        label='My House'
        shape='house'
        width='2'
    }

    Edge Home Work 
    Edge Work Home

} | Export-PSGraph -ShowGraph

start 'https://graphviz.gitlab.io/_pages/doc/info/attrs.html'


#default attributes for node/edge
Graph {

    Node @{shape='box'}
    Edge @{color='purple'}

    Edge Home Work
    Edge Work Home

} | Export-PSGraph -ShowGraph


# top to bottom processing
Graph {

    Node Home

    Node @{shape='box'}
    Edge @{color='purple'}
    
    Edge Home Work
    Edge Work Home

} | Export-PSGraph -ShowGraph


# Graph attributes
#   Label
#   Left to Right
Graph @{label='My special graph'; rankdir='LR'} {

    Node Home @{shape='house'}

    Edge Home Work
    Edge Work Home

} | Export-PSGraph -ShowGraph


# Duplicating Nodes scenario
Graph {

    Edge Home,Work,Lunch,Work,Home

} | Export-PSGraph -ShowGraph


Graph {

    Edge Home,Work1,Lunch,Work2,Home

} | Export-PSGraph -ShowGraph


Graph {   
    
    Edge "Home","Work1","Lunch","Work2","Home"

    Node Work1,Work2 @{label='loanDepot'}

} | Export-PSGraph -ShowGraph


# Rank keyword
Graph {

    Edge Home,Work1,Lunch,Work2,Home
 
    Node Work1,Work2 @{label='Work'}

    Rank Work1,Work2

} | Export-PSGraph -ShowGraph


# SubGraph keyword

Graph {   

    Edge Home,Work1,Lunch,Work2,Home

    SubGraph {
        Node Lunch        
        Node Work1,Work2 @{label='Work'}         
        Rank Work1,Work2
    }

} | Export-PSGraph -ShowGraph


#endregion
#region Building graphs


# Server infrastructure
graph {
    # External/DMZ nodes
   
    node loadbalancer @{shape='house'}
    node Web @{shape='rect'}

    edge loadbalancer -To Web
      
    # Internal API
    edge Web -To Api
    
    # Database Servers
    node DB @{shape='octagon'}
    edge Api -To DB
        
}  | Export-PSGraph -ShowGraph


# With server nodes
#   using arrays for node/edge
graph {
    # External/DMZ nodes
    
    node loadbalancer @{shape='house'}
    
    node Web1,Web2 @{shape='rect'} 
    rank Web1,Web2   
    edge loadbalancer -To Web1,Web2     

    # Internal API servers    
    node Api1,Api2,Api3 
    rank Api1,Api2,Api3  
    edge Web1,Web2 -To Api1,Api2,Api3
    
    # Database Servers    
    node DB1 @{shape='octagon'}
    rank DB1
    edge Api1,Api2,Api3 -To DB1
    
}  | Export-PSGraph -ShowGraph


# Using variables
$webServers = 'Web1','Web2','Web3'
$apiServers = 'Api1','Api2','Api3','Api5'
$databaseServers = 'DB1','DB2'

graph {
    # External/DMZ nodes    
    node loadbalancer @{shape='house'}
    
    node $webServers @{shape='rect'}
    rank $webServers
    edge loadbalancer -To $webServers
 
    # Internal API servers    
    node $apiServers 
    rank $apiServers  
    edge $webServers -To $apiServers
    
    # Database Servers    
    node $databaseServers @{shape='octagon'}
    rank $databaseServers
    edge $apiServers -To $databaseServers
      
}  | Export-PSGraph -ShowGraph


# From datasource
$servers = Import-Csv .\large.csv 
$servers | Out-GridView

$webServers = $servers | Where Role -eq 'Web' | Select -ExpandProperty ComputerName
$apiServers = $servers | Where Role -eq 'Api' | Select -ExpandProperty ComputerName
$databaseServers = $servers | Where Role -eq 'DB' | Select -ExpandProperty ComputerName

graph {
    # External/DMZ nodes    
    node loadbalancer @{shape='house'}
    
    node $webServers @{shape='rect'}
    rank $webServers
    edge loadbalancer $webServers
 
    # Internal API servers    
    node $apiServers 
    rank $apiServers  
    edge $webServers -to $apiServers
    
    # Database Servers    
    node $databaseServers @{shape='octagon'}
    rank $databaseServers
    edge $apiServers -to $databaseServers
      
}  | Export-PSGraph -ShowGraph


# With IP address

graph {
    # External/DMZ nodes    
    node loadbalancer @{shape='house'}
    
    node $webServers @{shape='rect'}
    rank $webServers
    edge loadbalancer $webServers
 
    # Internal API servers    
    node $apiServers 
    rank $apiServers  
    edge $webServers -to $apiServers
    
    # Database Servers    
    node $databaseServers @{shape='octagon'}
    rank $databaseServers
    edge $apiServers -to $databaseServers
    
    $servers | ForEach-Object {
        Node -Name $_.ComputerName @{ label = '{0}\n{1}' -f $_.ComputerName, $_.IP }
    }

}  | Export-PSGraph -ShowGraph


# Add process time checks
function Test-ServerConnection
{
    param($InputObject)
    if ((Get-Random -Minimum 0 -Maximum 100) -gt 20)
    {
        $true
    }
    else
    {
        $false
    }
}

graph {
    # External/DMZ nodes    
    node loadbalancer @{shape='house'}
    
    node $webServers @{shape='rect'}
    rank $webServers
    edge loadbalancer $webServers
 
    # Internal API servers    
    node $apiServers 
    rank $apiServers  
    edge $webServers -to $apiServers
    
    # Database Servers    
    node $databaseServers @{shape='octagon'}
    rank $databaseServers
    edge $apiServers -to $databaseServers
    
    $servers | ForEach-Object {
        if(Test-ServerConnection $_.ComputerName){
            $color = 'green'
        }
        else
        {
            $color = 'red'
        }
        Node -Name $_.ComputerName @{
            label = '{0}\n{1}' -f $_.ComputerName, $_.IP
            color = $color
        }
    }
}  | Export-PSGraph -ShowGraph



# OrgChart
#  Enumerating objects
$people = Import-Csv .\orgChart.csv
$people | Out-GridView

graph orgChart {
    Node @{shape='rect'}

    $people | ForEach-Object {
        Node -Name $_.ID @{ label = "{0}\n{1}" -f $_.Name, $_.Title }
    }

    $people | Where Manager | ForEach-Object {
        Edge -From $_.Manager -To $_.ID
    }
} | Show-PSGraph


# Inline Object Enumeration
$people = Import-Csv .\orgChart.csv
$people | Out-GridView

graph orgChart {
    Node @{shape='rect'}

    Node $people -NodeScript {$_.ID} @{ label = {"{0}\n{1}" -f $_.Name, $_.Title} }
    
    Edge -Node ($people | Where Manager) -FromScript {$_.Manager} -ToScript {$_.ID}

} | Show-PSGraph

#endregion
#region Other graphs

# Parent and Child processes
$process = Get-CimInstance -ClassName CIM_Process
$process | Ft ProcessName, ProcessID, ParentProcessID

graph processes @{rankdir='LR'} {
    node @{shape='box'}
    node $process -NodeScript {$_.ProcessId} -Attributes @{label={$_.ProcessName}}
    edge $process -FromScript {$_.ParentProcessId} -ToScript {$_.ProcessId}
} | Show-PSGraph


# Network Connections
$netstat = Get-NetTCPConnection -State Established,TimeWait

graph network @{rankdir='LR'}  {
    Node @{shape='rect'}

    $EdgeParam = @{
        Node       = $netstat
        FromScript = {$_.LocalAddress}
        ToScript   = {$_.RemoteAddress}
        Attributes = @{label={'{0}:{1}' -f $_.LocalPort,$_.RemotePort}}
    }
    Edge @EdgeParam
} | Export-PSGraph -ShowGraph


# Process Connections
$netstat = Get-NetTCPConnection | where LocalAddress -EQ '192.168.86.60'
$process = Get-Process | where id -in $netstat.OwningProcess

graph network @{rankdir='LR'} {
    node @{shape='rect'}
    node $process -NodeScript {$_.ID} @{label={$_.ProcessName}}

    $netParam = @{
        Node = $netstat
        FromScript = {$_.OwningProcess}
        ToScript   = {$_.RemoteAddress}
        Attributes = @{label={'{0}:{1}' -f $_.LocalPort,$_.RemotePort}}
    }
    edge @netParam
} | Export-PSGraph -ShowGraph


# Services
$services = Get-Service
graph services {
    Node @{shape='box'}
    Node $services -NodeScript {$_.name} @{
        label={$_.DisplayName}
        color={If($_.Status -eq 'Running'){'blue'}else{'red'}}
    }
} | Export-PSGraph -ShowGraph -LayoutEngine Radial


# Dependent services
Get-Service | Format-Table Name,ServicesDependedOn 

$services = Get-Service
$graph = graph services  @{rankdir='LR'} {
    Node @{shape='box'}
    Node $services -NodeScript {$_.name} @{
        label={$_.DisplayName}
        color={If($_.Status -eq 'Running'){'blue'}else{'red'}}
    }
    $linkedServices = $services | where{$_.ServicesDependedOn}
    Edge $linkedServices -FromScript {$_.Name} -ToScript {$_.ServicesDependedOn.Name}
} 
$graph | Export-PSGraph -ShowGraph -LayoutEngine Hierarchical


#  Custom format
Set-NodeFormatScript { $_.tolower()}
Graph g {

    Edge -From Home -To work
    Edge -From Work -To Home

} | Export-PSGraph -ShowGraph

Set-NodeFormatScript 

# Dependent services with normalized node names
$services = Get-Service
Set-NodeFormatScript {$_.tolower()}
$graph = graph services  @{rankdir='LR'} {
    Node @{shape='box'}

    
    Node $services -NodeScript {$_.name} @{
        label={$_.DisplayName}
        color={If($_.Status -eq 'Running'){'blue'}else{'red'}}
    }
    $linkedServices = $services | where{$_.ServicesDependedOn}
    Edge $linkedServices -FromScript {$_.Name} -ToScript {$_.ServicesDependedOn.Name}
    
} 
Set-NodeFormatScript 
$graph | Export-PSGraph -ShowGraph -LayoutEngine Hierarchical

#endregion


#region Module Help details

$moduleFilter = 'Microsoft.PowerShell.Management'
$commandFilter = '.+'
$graph = graph {
    node @{shape='rectangle'}
 
  # Create all the cmdlets and modules
  Get-Module | ? { $_.Name -match $moduleFilter } | ForEach-Object -Process {
    $ModuleName = $_.name
    Write-Progress -Activity "Parsing $ModuleName" -Status "Importing Commands"
    Node $ModuleName @{shape='folder'}
    
    #Invoke-Cypher("CREATE (:Module { name:'$ModuleName'})")

    Get-Command -Module $_ | ? { $_.Name -match $commandFilter } | ForEach-Object -Process {
      $CommandName = $_.Name
      Edge $moduleName -To $CommandName @{label='HAS_COMMAND'}      
    }
  }

  # Create all the cmdlets and modules
  Get-Module | ? { $_.Name -match $moduleFilter } | ForEach-Object -Process {
    $ModuleName = $_.name
    Write-Progress -Activity "Parsing $ModuleName"
    Get-Command -Module $_ | ? { $_.Name -match $commandFilter } | ForEach-Object -Process {
      $ThisCommandName = $_.Name

      Write-Progress -Activity "Parsing $ModuleName" -Status "Creating links for $ThisCommandName"
      $thisURI = $null
      (Get-Help $_).relatedLinks.navigationLink | ForEach-Object -Process {
        $HelpLink = $_

        # Ignore anything that is a real URI
        if ($HelpLink.uri -eq '') {
          $ThatCommandName = $HelpLink.linkText
          Edge $ThisCommandName -To $ThatCommandName
          
        } else {
          $thisURI = $HelpLink.uri
        }
      }

      if ($thisURI -ne $null) {

        Node $ThisCommandName @{URL=$thisURI}
        
      }
    }
  }
}

$graph | Export-PSGraph -ShowGraph

#endregion ...

#region More resources
$info = @{
    Topic       = 'Working with PSGraph'
    Presenter   = 'Kevin Marquette'
    Title       = 'Sr. DevOps Engineer'

    Email       = 'kevmar@gmail.com'
    Twitter     = '@kevinmarquette'

    Blog        = 'kevinmarquette.github.io'
    Github      = 'github.com/kevinmarquette/psgraph' 
    ReadTheDocs = 'http://psgraph.readthedocs.io'
    GraphViz    = 'graphviz.org' 
    MoreExamples = 'https://github.com/mcmiv413/PS-Diagram'  
}

#endregion
