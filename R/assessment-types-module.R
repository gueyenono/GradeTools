assessment_types_module_ui <- function(id){
  
  ns <- NS(id)
  
  box(
    
    title = "Assessment types", solidHeader = TRUE, status = "primary",
    
    p("Select the assessment types in your course. You can enter types, which are not available in the dropdown list."),
    
    selectizeInput(inputId = ns("assessments"), label = "Assessments", multiple = TRUE, options = list(create = TRUE),
                   choices = c(
                     "Homework"     = "homework" , 
                     "Test"         = "test",
                     "Exam"         = "exam",
                     "Quiz"         = "quiz",
                     "Presentation" = "presentation"
                   )),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}

assessment_types_module <- function(input, output, session){
  
  assessment_types <- eventReactive(input$submit, {
    input$assessments
  })
  
  return(
    assessment_types
  )
  
}