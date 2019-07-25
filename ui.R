library(shiny)
library(shinydashboard)
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
source("R/tab_compute_grade_module.R")
source("R/helper_functions.R")
source("R/assessment-types-module.R")
source("R/counts-and-weigths-module.R")
source("R/scores-module.R")
source("R/scores-evolution-module.R")
source("R/performance-by-assessment-valuebox-module.R")
source("R/total-grade-module.R")


shinyUI(dashboardPage(
  
  dashboardHeader(title = "gradetools"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Compute Grade", tabName = "compute_grade", icon = icon("user-graduate")),
      menuItem(text = "Whatcha need?", tabName = "whatcha_need", icon = icon("calculator"))
    )
  ),
  
  dashboardBody(
    
    useShinyjs(),
    useShinyalert(),
    
    tabItems(
      
      tabItem(tabName = "compute_grade",  tab_compute_grade_module_ui(id = "tab-compute-grade")
      ),
      
      tabItem(
        tabName = "whatcha_need",
        
        box(
          title = "Current Total Grade", solidHeader = TRUE, status = "primary", width = 4
        ),
        
        box(
          title = "Your goal", solidHeader = TRUE, status = "primary", width = 4
        ),
        
        box(
          title = "Whatcha Need", solidHeader = TRUE, status = "primary", width = 4
        )
      )
    )
  )
))
  
  
  