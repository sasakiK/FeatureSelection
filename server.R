# upload
# server.R

library(shiny)
library(randomForest)
library(caret)
library(e1071)
library(DT)
library(FSelector)

function(input, output) {
  output$contents <- renderDataTable({
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    df <- read.csv(inFile$datapath, header=TRUE, sep=',', 
             quote=input$quote,encoding = "Shift-JIS")
    return(df)
    options = list(
      autoWidth = TRUE
      #columnDefs = list(list(width = '40px', targets = "_all"))
    )
  })
  
  output$plot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    df <- read.csv(inFile$datapath, header=TRUE, sep=',', 
                   quote=input$quote,encoding = "Shift-JIS")
  
    index <- colnames(df) != input$text
    features <- df[index]
    labels<- df[input$text]

    labels<-as.factor(labels[[1]])

    classifier<-randomForest(x=features,y=labels,importance=T)
    
    varImpPlot(classifier,main="Variable Importance",sort=T)
    
        output$importance <-  DT::renderDataTable(rownames = TRUE,{
          data.frame(importance(classifier))[,c("MeanDecreaseAccuracy","MeanDecreaseGini")]
        })
        
        output$importance2 <-  DT::renderDataTable({
          res2 <- information.gain(labels ~., data= features)
          res3 <- gain.ratio(labels ~., data= features)
          set.seed(123)
          res4 <- relief(labels ~., data = features)
          out <- cbind(res2,res3,res4)
          names(out) <- c("information.gain","gain.ratio","relief")
          return(out)
        })
    })
}
