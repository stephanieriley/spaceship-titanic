#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(gtsummary)
library(gt)
library(ggpubr)

# dat <- read.csv("data/data.csv")



# Define server logic required to draw a histogram
function(input, output, session) {
  
data<- reactive({

  dat <- read.csv("data/data.csv")

  return(dat)
})


# Data dictionary
output$datadic<- renderTable({
  data_dictionary<- read.csv("data/data_dictionary.csv")
  
  data_dictionary
})


# Numerical summary table
output$mygt<- gt::render_gt(
  data() %>%
    select(c(Transported, Age, RoomService:VRDeck, HomePlanet, Destination, DeckCat, Side, VIP, CryoSleep)) %>%
    tbl_summary(by = "Transported") %>%
    modify_header(update = all_stat_cols(FALSE) ~ "**{level}**<br>N = {n}") %>%
    add_overall() %>%
    as_gt()
  
)


# Graphical summary plot
#Depends on input: Categorical or Continuous
output$summaryplot<- renderPlot ({
  
  
  
  if(input$predtype == "cont"){
    #Define vectors containing continuous and categorical variables
    cont<- c("Age", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck")
    
    #Create density plots for continuous variables
    for (i in 1:length(cont)) {
      assign(paste("p",i, sep=""),
             ggplot(data(), aes_string(x = cont[i], fill = "Transported")) +
               geom_density(alpha = 0.4) +
               theme_classic()
      )
    }
    #Arrange on one plot
    ggarrange(p1, p2, p3, p4, p5, p6, ncol=3, nrow = 2, common.legend = T, legend = "bottom")
  } else
    if(input$predtype == "cat"){
    #Define vectors containing categorical variables
    cat<- c("HomePlanet", "Destination", "DeckCat", "Side", "VIP", "CryoSleep")
    
    #Create barplots for categorical variables
    for (j in 1:length(cat)) {
      assign(paste("p",j,sep=""),
             ggplot(data(), aes_string(x = cat[j], fill = "Transported")) +
               geom_bar(position = "dodge") +
               theme_classic()
      )
    }
    #Arrange on one plot
    ggarrange(p1, p2, p3, p4, p5, p6, ncol=3, nrow = 2, common.legend = T, legend = "bottom")
  }
  
  })

}













