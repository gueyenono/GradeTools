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
source("R/scores-evolution-module.R")
source("R/performance-by-assessment-valuebox-module.R")
source("R/total-grade-module.R")


dashboardPage(
  
  dashboardHeader(title = "gradetools"),
  
  dashboardSidebar(),
  
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
        title = "Evolution of Scores", solidHeader = TRUE, status = "primary", width = 4,
        scores_evolution_module_ui(id = "scores-evolution")
      ),
      
      box(
        title = "Performance by Assessment Type", solidHeader = TRUE, status = "primary", width = 4,
        performance_by_assessment_valuebox_module_ui(id = "performance-weights")
      ),
      
      box(
        title = "Overall Performance", solidHeader = TRUE, status = "primary", width = 4,
        total_grade_module_ui(id = "total-grade")
      )
    )
  )
)

