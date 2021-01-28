library(bs4Dash)
library(shiny)
library(shinyjs)
library(shinyalert)
library(shinyWidgets)
library(magrittr)
library(purrr)
library(rhandsontable)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
source("R/tab-compute-grade-module.R")
source("R/tab-whatcha-need-module.R")
source("R/helper_functions.R")
source("R/grade-categories-module.R")
source("R/counts-and-weigths-module.R")
source("R/scores-module.R")
source("R/scores-evolution-module.R")
source("R/performance-by-grade-category-valuebox-module.R")
source("R/total-grade-module.R")
source("R/display-current-grade-module.R")
source("R/compute-target-score-module.R")
source("R/display-target-score-module.R")

shinyUI(
  
  dashboardPage(
    
    dashboardHeader(title = "Gradetools v.2.0"),

    dashboardSidebar(

      sidebarMenu(

        id = "sidebar",
        
        tags$head(tags$style(".inactiveLink {
                            pointer-events: none;
                           cursor: default;
                           }")),

        menuItem(

          text = "Compute your grade",
          tabName = "compute_grade",
          icon = icon("user-graduate")

        ),

        menuItem(

          text = "Whatcha need?",
          tabName = "whatcha_need",
          icon = icon("calculator")

        )

      )

    ),
    
    dashboardBody(
      
      useShinyjs(),
      useShinyalert(),
      tags$script(src = "script.js"),

      tabItems(
        tabItem(tabName = "compute_grade", tab_compute_grade_module_ui(id = "tab-compute-grade")),
        tabItem(tabName = "whatcha_need", tab_whatcha_need_module_ui(id = "tab-whatcha-need"))
      )

    )
    
  )
  
)