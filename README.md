# COVID-19 Dashboard

This is a simple dashboard to illustrate RShiny's uses and capabilities. The dashboard allows for linear modelling of longitudinal COVID-19 data sourced from the Our World in Data repository. Further description of the data can be found: https://github.com/owid/covid-19-data/blob/master/public/data/README.md

## Description

The dashboard is created in R using RShiny. 

### Dependencies

The following code can be run in your R console to install the required R packages:
```
install.packages(c("shiny", "magrittr", "dplyr", "ggplot2"))
```

### Installing

The zip file can be installed right from GitHub. Alternatively, the dashboard can be called straight from the R console (see Executing program). 

### Executing program

If the code was downloaded using a zip file. 
```
runApp(covid-dashboard.R)
```

Alternatively, the dashboard can be run straight from the R console:
```
library(shiny)
runGitHub("covid19-dashboard", "gaudet-d")
```

<!-- ## Help (Known issues, etc.)

## Authors

## Version History 

## License

## Acknowledgements 

## References -->

  
