library(shiny)
library(shinydashboard)
library(shinyjs)
library(magrittr)
source("R/assessment-types-module.R")

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
    
    
    
  )
  
)