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
                menuSubItem("Graphical summary", tabName = "graphsum"))
  )
)

# Define body of shinydashboard
body<- dashboardBody(
  tabItems(
    #Welcome tab
    tabItem(tabName = "intro", h1("Welcome aboard the Spaceship Titanic!"),
            p("Welcome to the year 2912, where your data science skills are needed to solve a cosmic mystery. We've received a transmission from four lightyears away and things aren't looking good."),
            br(),
            p("The Spaceship Titanic was an interstellar passenger liner launched a month ago. With almost 13,000 passengers on board, the vessel set out on its maiden voyage transporting emigrants from our solar system to three newly habitable exoplanets orbiting nearby stars."),
            br(),
            p("While rounding Alpha Centauri en route to its first destination—the torrid 55 Cancri E—the unwary Spaceship Titanic collided with a spacetime anomaly hidden within a dust cloud. Sadly, it met a similar fate as its namesake from 1000 years before. Though the ship stayed intact, almost half of the passengers were transported to an alternate dimension!"),
            br(),
            p("Today we will attempt to build a statistical model which can predict whether or not someone will be transported off the ", strong("Spaceship Titanic"), " or not"),
            br(),
            tableOutput("datadic")),
    
    
    #Summary tabs
    tabItem(tabName = "numsum", h1("Numerical summary of predictors"),
            gt_output(outputId = "mygt")),
    
    tabItem(tabName = "graphsum", h1("Graphical summary of predictors"),
            selectInput("predtype", "Predictor type:",
                        choices = c("Categorical predictors" = "cat",
                                    "Continuous predictors" = "cont"),
                        selected = NULL),
            mainPanel(plotOutput("summaryplot",
                                 height = 700)))
  )
)

# Define UI for shiny dash
dashboardPage(
  dashboardHeader(title = "Spaceship Titanic"),
  sidebar,
  body
)
