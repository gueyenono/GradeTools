library(shiny)
library(shinydashboard)
library(shinyjs)
library(magrittr)
library(purrr)
source("R/assessment-types-module.R")
source("R/counts-and-weigths-module.R")

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
    
    fluidRow(
      column(width = 6, assessment_types_module_ui(id = "assessment_types")),
      column(width = 6, counts_and_weights_module_ui(id = "counts-and-weights"))
    )
    
  )
  
)
