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
source("R/helper_functions.R")
source("R/assessment-types-module.R")
source("R/counts-and-weigths-module.R")
source("R/scores-module.R")
source("R/overall-performance-percentages-module.R")

dashboardPage(
  
  dashboardHeader(title = "gradetools"),
  
  dashboardSidebar(
    
    # sidebarMenu(
    #   menuItem(text = "Assessment types", icon = icon("book-open")),
    #   menuItem(text = "Weights", icon = icon("weight"))
    # )
    
  ),
  
  dashboardBody(
    
    useShinyjs(),
    useShinyalert(),
    
    fluidRow(
      
      box(
        title = "Assessment types", solidHeader = TRUE, status = "primary", width = 4,
        assessment_types_module_ui(id = "assessment_types")
      ),
      
      box(
        title = "Counts and Weights", solidHeader = TRUE, status = "primary", width = 4,
        counts_and_weights_module_ui(id = "counts-and-weights")
      ),
      
      box(
        title = "Scores", solidHeader = TRUE, status = "primary", width = 4,
        scores_module_ui(id = "scores")
      )
    ),
    
    fluidRow(
      
      box(
        title = "Performance by Assessment Type", solidHeader = TRUE, status = "primary", width = 4,
        performance_percentages_module_ui(id = "performance-weights")
      ),
      
      box(
        title = "Overall Performance (Percentages)", solidHeader = TRUE, status = "primary", width = 4
      ),
      
      box(
        title = "Total Grade", solidHeader = TRUE, status = "primary", width = 4
      )
      
    )
  )
)
