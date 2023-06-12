#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(gt)


# Define shinydashboard sidebar
sidebar<- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "intro", icon = icon("rocket", "rocket")),
    
    menuItem("Exploratory analysis", tabName = "eda", icon = icon("chart-line"),
             startExpanded = FALSE,
                menuSubItem("Numerical summary", tabName = "numsum"),
                menuSubItem("Graphical summary", tabName = "graphsum")),
    
    menuItem("Build your model", tabName = "modelbuild", icon = icon("screwdriver-wrench"))
  )
)

# Define body of shinydashboard
body<- dashboardBody(
  tabItems(
    #Welcome tab
    tabItem(tabName = "intro", h1("Welcome aboard the Spaceship Titanic!"),
            p("Welcome to the year 2912, where your data science skills are needed to solve a cosmic mystery. We've received a transmission from four lightyears away and things aren't looking good."),
            p("The Spaceship Titanic was an interstellar passenger liner launched a month ago. With almost 9,000 passengers on board, the vessel set out on its maiden voyage transporting emigrants from our solar system to three newly habitable exoplanets orbiting nearby stars."),
            p("While rounding Alpha Centauri en route to its first destination—the torrid 55 Cancri E—the unwary Spaceship Titanic collided with a spacetime anomaly hidden within a dust cloud. Sadly, it met a similar fate as its namesake from 1000 years before. Though the ship stayed intact, more than half of the passengers were transported to an alternate dimension!"),
            br(),
            p("Today we will attempt to build a statistical model which can predict whether someone will be ", strong("Transported"), " or ", strong("Not Transported"), " off the Spaceship Titanic!"),
            p("The table below shows which variables are available to use to make predictions. The data are available from ", a(href = "https://www.kaggle.com/competitions/spaceship-titanic/overview", "Kaggle.")),
            tableOutput("datadic")),
    
    
    #Summary tabs
    tabItem(tabName = "numsum", h1("Numerical summary of predictors"),
            gt_output(outputId = "mygt")),
    
    tabItem(tabName = "graphsum", h1("Graphical summary of predictors"),
            selectInput("predtype", "Predictor type:",
                        choices = c("Categorical predictors" = "cat",
                                    "Continuous predictors" = "cont")),
            mainPanel(plotOutput("summaryplot",
                                 height = 700))),
    
    #Build the model
    #First select predictor variables
    tabItem(tabName = "modelbuild", h1("Build your model"),
            p("Select which variables you would like to include in the prediction model"),
            selectInput("preds", "Predictor variables:",
                        c("Age", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck", "HomePlanet", "Destination", "DeckCat", "Side", "VIP", "CryoSleep"),
                        multiple = TRUE),
            actionButton("build", "Build model"),
            p("Summary of the model"),
            verbatimTextOutput("modelsum"))
    
    
  )
)

# Define UI for shiny dash
dashboardPage(
  dashboardHeader(title = "Spaceship Titanic"),
  sidebar,
  body
)
