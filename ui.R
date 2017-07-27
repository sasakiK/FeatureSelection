# upload
# ui.R

library(shiny)
library(randomForest)
library(caret)
library(e1071)
library(DT)
library(FSelector)

fluidPage(theme = "bootstrap.css",
  titlePanel("Feature Selection"),
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Write the name of Y"), 
                value = "y"),
      
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$hr(),
      
      #checkboxInput('header', 'Header', TRUE),
    

          
      selectInput("select_eval", label = h3("Choose : evaluation"), 
                  choices = c( "MeanDecreaseGini" = 1,
                               "MeanDecreaseAccuracy" = 2), 
                  selected = 1)
    ),
    mainPanel(
      
      helpText(
                p("RandomForest Variable importance"),
                p("upload csv with header"),
                br()
                ),
      
      tabsetPanel(
        tabPanel('original data',
                 dataTableOutput("contents",width = "70%")),
        tabPanel('importance',
                 dataTableOutput("importance",width = "70%")),
        tabPanel('infomation gain',
                 dataTableOutput("importance2",width = "70%"))
      ),
      
      plotOutput('plot')
   
    )
  )
)
