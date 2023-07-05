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


# Define shinydashboard header
header<- dashboardHeader(
  title = "Spaceship Titanic",
  
  tags$li(class = "dropdown",
          tags$a(href = 'https://github.com/stephanieriley/spaceship-titanic',
                 tags$div(HTML('<i class="fa-brands fa-github" style = "color:#ffffff;"></i>'))
                 )
          ),
  dropdownMenuOutput('messageMenu')
)


# Define shinydashboard sidebar
sidebar<- dashboardSidebar(
  sidebarMenu(
    
    menuItem(img(src="UoP2.png",width="100%")),
    
    menuItem("Introduction", tabName = "intro", icon = icon("rocket", "rocket")),
    
    menuItem("Exploratory analysis", tabName = "eda", icon = icon("chart-line"),
             startExpanded = FALSE,
                menuSubItem("Numerical summary", tabName = "numsum"),
                menuSubItem("Graphical summary", tabName = "graphsum")),
    
    menuItem("Build your model", tabName = "modelbuild", icon = icon("screwdriver-wrench")),
    
    menuItem("Predict transport probability", tabName = "predprob", icon = icon("user-astronaut"))
  )
)


# Define body of shinydashboard
body<- dashboardBody(

  
  #Customise text according to www/custom_style.css
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom_style.css")
  ),
  
  #Customise style according to www/custom_style.css
  tags$style(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom_style.css")
    ),

  tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #31b4ed;
                                }

                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #31b4ed;
                                }

                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #31b4ed;
                                }

                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #31b4ed;
                                color: #ffffff;
                                }

                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: #31b4ed;
                                color: #000000;
                                }

                                '))),
  
  
  tabItems(
    #Welcome tab
    tabItem(tabName = "intro", h2("Welcome aboard the Spaceship Titanic!"),
            p("Welcome to the year 2912, where your data science skills are needed to solve a cosmic mystery. We've received a transmission from four lightyears away and things aren't looking good."),
            p("The Spaceship Titanic was an interstellar passenger liner launched a month ago. With over 6,500 passengers on board, the vessel set out on its maiden voyage transporting emigrants from our solar system to three newly habitable exoplanets orbiting nearby stars."),
            p("While rounding Alpha Centauri en route to its first destination—the torrid 55 Cancri E—the unwary Spaceship Titanic collided with a spacetime anomaly hidden within a dust cloud. Sadly, it met a similar fate as its namesake from 1000 years before. Though the ship stayed intact, more than half of the passengers were transported to an alternate dimension!"),
            h2("Your mission..."),
            p("Today we will attempt to build a statistical model which can predict whether someone will be ", strong("Transported"), " or ", strong("Not Transported"), " off the Spaceship Titanic!"),
            p("The table below shows which variables are available to use to make predictions. The data are available from ", a(href = "https://www.kaggle.com/competitions/spaceship-titanic/overview", "Kaggle.")),
            tableOutput("datadic")),
    
    
    #Summary tabs
    tabItem(tabName = "numsum", h2("Numerical summary of predictors"),
            gt_output(outputId = "mygt")),
    
    tabItem(tabName = "graphsum", h2("Graphical summary of predictors"),
            selectInput("predtype", "Predictor type:",
                        choices = c("Categorical predictors" = "cat",
                                    "Continuous predictors" = "cont")),
            mainPanel(plotOutput("summaryplot",
                                 height = 700))),
    
    #Build the model
    #First select predictor variables
    tabItem(tabName = "modelbuild", h2("Build your model"),
            #fluidRow(
              p("The binary multiple regression model that we discussed looks like"),
              uiOutput("formula"),
            #),
            fluidRow(
              column(width=12,
                     box(
                       p("Select which variables you would like to include in the prediction model"),
                       selectInput("preds", "Predictor variables:",
                                   c("Age", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck", "HomePlanet", "Destination", "DeckCat", "Side", "VIP", "CryoSleep"),
                                   multiple = TRUE),
                       actionButton("build", "Build model"),
                       p("Summary of the model"),
                       tableOutput("modelsum"),
                       br()
                       ),
                     
                     box(
                       p("Remember, you are trying to build the best prediction model based on the following metrics"),
                       p(strong("R-squared"), ": the percentage of variation explained by the selected predictors. Values closer to 100% indicate better model fit."),
                       p(strong("Akaike's Information Criterion (AIC)"), ": numerical value we can assign a model to see how well it “fits” our data. It can take any positive value. Lower values indicate better model fit."),
                       
                       p("We are also looking for the simplest possible model. The best model will contain as little number of predictors as possible without compromising how well it performs."),
                       box(
                         infoBoxOutput("rsquaredBox", width = 5.5)
                       ),
                       box(infoBoxOutput("aicBox", width = 5.5))
                     )
                     )
              
              )
            ),
    
    tabItem(tabName = "predprob", h2("Predict your probability of being transported"),
            fluidRow(
              column(width=12,
                     box(
                       p("Using ", strong("backward elimination"), " we identified that the following predictors gave us the “best” model"),
                       tableOutput("coeftable")
                     ),
                     
                     box(
                       numericInput("age", "Age: ", value = 20),
                       radioButtons("home", "Home planet: ",
                                    choices = c("Earth","Europa","Mars")),
                       radioButtons("dest", "Destination:",
                                    choices = c("55 Cancri e","PSO J318.5-22","TRAPPIST-1e")),
                       radioButtons("deckcat", "Deck:",
                                    choices = c("Lower", "Middle", "Upper")),
                       radioButtons("side", "Side:",
                                    choices = c("Port", "Starboard")),
                       radioButtons("vip", "VIP:",
                                    choices = c("False", "True")),
                       actionButton("predict", "Predict"),
                       box(
                         infoBoxOutput("predprobBox", width = 12)
                       )
                       )
              ) 
            )
            )
    
  )
)

# Define UI for shiny dash
dashboardPage(
  # dashboardHeader(title = "Spaceship Titanic"),
  header,
  sidebar,
  body
)
