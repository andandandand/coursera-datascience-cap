source('predictWord.R')
library(shiny)
library(RSQLite)

shinyServer(function(input, output) {
  db <- dbConnect(SQLite(), dbname="train.db")
  dbout <- reactive({ngram_backoff(input$text, db)})
  
  output$sentence <- renderText({input$text})
  output$predicted <- renderText({
    out <- dbout()
    if (out[[1]] == "Not enough data in the corpus to predict the next word using backoff.") {
      return(out) #no n-gram found
    } else {
      return(unlist(out)[1]) #found words
    }})
  output$alts <- renderTable({dbout()})
})