assessment_types_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
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
  
  missing_input <- eventReactive(input$submit, {
    length(assessment_types()) == 0
  })
  
  observeEvent(input$submit, {
    
    if(missing_input()){
      
      shinyalert(
        title = "Warning!",
        text = "You need to choose at least one assessment type.",
        type = "warning",
        closeOnEsc = TRUE,
        closeOnClickOutside = TRUE,
        showConfirmButton = TRUE,
        animation = "slide-from-top"
      )
      
      shinyjs::enable(id = "submit")
      
    } 
  })
  
  return(list(
    return_value = assessment_types,
    click = reactive({ input$submit }),
    missing_input = missing_input
  ))
  
}