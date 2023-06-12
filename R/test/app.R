#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# app.R version 2

library(shiny)

names.df <- read.csv("https://www.finley-lab.com/files/data/name_list.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Random Names Age Analysis"),
  sidebarLayout(
    sidebarPanel(
      # Dropdown selection for Male/Female
      selectInput(inputId = "sexInput", label = "Sex:",
                  choices = c("Female" = "F", 
                              "Male" = "M", 
                              "Both" = "B"))
    ),
    mainPanel("our output will appear here")
  )
)

# Define server logic
server <- function(input, output) {}

# Create Shiny app
shinyApp(ui = ui, server = server)