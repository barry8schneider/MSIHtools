$webappurl = "http://staging2013.nationalchildrensstudy.gov" 
$webapp =Get-SPWebApplication $webappurl
$webapp.FileNotFoundPage

$webapp.FileNotFoundPage = "Custom404NCS.html"
$webapp.update()
#To verify that the property is set by running the following command:
$webapp.FileNotFoundPage