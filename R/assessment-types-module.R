assessment_types_module_ui <- function(id){
  
  ns <- NS(id)
    
  box(
    
    p("What are the assessment types in your course?"),
    
    fluidRow(
      
      selectizeInput(inputId = "assessments",
                     label = "Assessments",
                     choices = c(
                       "Homework"     = "homework",
                       "Test"         = "test",
                       "Exam"         = "exam",
                       "Quiz"         = "quiz",
                       "Presentation" = "presentation"
                     ),
                     options = list(create = TRUE))
      
    )
  )
    
}

assessment_types_module <- function(input, output, session){
  
}