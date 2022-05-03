library(shiny)
library(magrittr)
library(dplyr)
library(ggplot2)

mydat = read.csv('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv')
mydat$date = as.Date(mydat$date, format='%Y-%m-%d')
country.name = unique(mydat$location)

ui = fluidPage(
  h1("Smoothed Covid-19 Cases Over Time"),
  p(paste("Data last updated:", max(mydat$date), sep=" ")),
  paste("Select a country to see the daily COVID-19 case counts, hospitalizations, and vaccination data. Note that fully vaccinated refers to two doses of an approved vaccine - however the definition of fully vaccinated may differ per country. This data is collected from"),
  tags$em("Our World in Data.", inline=T),
  uiOutput("src", inline=T), tags$br(),
  selectizeInput("countryID", label=NULL, choices = country.name, options = list(maxItems=1, maxOptions=5, placeholder="Select a country name.")),
  tableOutput("pop"),
  plotOutput("casesPlot"),
  fluidRow(
    splitLayout(cellWidths=c("50%","50%"), plotOutput("hospPlot"), plotOutput("vxPlot"))
  ),
  p("Note that some countries may not have all features of the data - therefore some plots may appear empty.", inline=T)
)

server = function(input, output){
  #Reactive filtering of dataset when the selected country is changed.
  df = reactive({
    mydat %>% filter(location==input$countryID)
  })
  #Plot the new daily COVID-19 cases.
  output$casesPlot = renderPlot({ #Plot of new COVID-19 cases. 
    cases = ggplot(df(), aes(x=date)) + geom_line(aes(y=new_cases_smoothed), color="darkred", lwd=1) + 
      labs(y="Smoothed daily COVID-19 cases", x="Date", title="Smoothed Daily COVID-19 Cases") 
    cases + theme_bw() + theme(text=element_text(size=12))
  })
  #Plot hospitalizations, ICU cases, deaths
  output$hospPlot = renderPlot({ #Plot of hospitalizations and patients in ICU
    hosp = ggplot(df(), aes(x=date)) + geom_line(aes(y=icu_patients, color="ICU"), lwd=1) + geom_line(aes(y=hosp_patients, color="Hospitalized"), lwd=1) + 
      geom_line(aes(y=new_deaths, color="Deaths"), lwd=1) + 
      labs(y="Number of patients", x="Date", title="Patients hospitalized, in ICU and deceased due to COVID-19") +
      scale_color_manual("",
                         breaks = c("ICU", "Hospitalized", "Deaths"),
                         values = c("forestgreen", "steelblue", "darkred"))
    hosp + theme_bw() + theme(legend.position=c(0.2, 0.85), text=element_text(size=12))
  })
  #Plotted vaccination rates for country
  output$vxPlot = renderPlot({ #Plot of total vaccinations
    vx = ggplot(df(), aes(x=date, y=people_vaccinated)) + geom_line(aes(color="At least one dose"), lwd=1) + 
      geom_line(aes(y=people_fully_vaccinated, color="Fully vaccinated"), lwd=1) +
      geom_line(aes(y=total_boosters, color="At least one booster"), lwd=1) +
      labs(x="Date", title=paste("Total COVID-19 vaccinations,\n", round(max(df()$people_fully_vaccinated, na.rm=T)/mean(df()$population, na.rm=T), digits=4)*100, "% fully vaccinated", sep=" ")) +
      scale_color_manual("",
                         breaks = c("At least one dose", "Fully vaccinated", "At least one booster"),
                         values = c("#780116", "#DB7C26", "#F7B538"))
    vx + theme_bw() + theme(legend.position=c(0.2, 0.85), text=element_text(size=12))
  })
  #Table of the country's population and population density.
  output$pop = renderTable({ #Population and population density table
    r1 = c("Population", "Population Density")
    r2 = c(mean(df()$population, na.rm=T), mean(df()$population_density, na.rm=T))
    rbind(r1,r2)
  }, colnames=F)
  url = a("github.com/owid/", href="https://github.com/owid/covid-19-data/blob/master/public/data/README.md")
  output$src = renderUI({
    tagList("The data was accessed from:", url)
  })
}

shinyApp(ui, server)
