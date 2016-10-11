library(shiny)


shinyUI(fluidPage(
  
  titlePanel("Word Prediction through Backoff Model"),
  h4("Coursera Data Science Capstone", style="color:black"),
  h5("Antonio Rueda-Toicen"),
  hr(),
  

  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Word prediction"), value = "The cat is "), 
      submitButton("Get next word"),
      hr(),
      p("Type in a few words and press enter or the button below to get a list of likely next words (according to the training corpus of blog posts, news, and Twitter feeds)."),
      hr(),
      a(href="http://www.aclweb.org/anthology/D07-1090.pdf", "We use a Backoff model as described by Brants et al. in \"Large Language Models for Machine Tranlation\".")
    ),
    
    # Show likely next words
    mainPanel(
      br(),
      h2(textOutput("sentence"), align="center"),
      h1(textOutput("predicted"), align="center", style="color:orange"),
      hr(),
      h3("Top Hits:", align="center"),
      div(tableOutput("alts"), align="center")
    )
  )
))