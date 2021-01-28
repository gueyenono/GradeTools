grade_categories_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    p("Select the grade categories in your course. If a category is not available in the dropdown list below, you can type it."),
    
    selectizeInput(inputId = ns("grade_categories"), label = "Grade Category", multiple = TRUE, options = list(create = TRUE),
                   choices = c("Homework", "Test", "Exam", "Quiz", "Presentation")),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}

grade_categories_module <- function(input, output, session){
  
  grade_categories <- eventReactive(input$submit, {
    input$grade_categories
  })
  
  missing_input <- eventReactive(input$submit, {
    length(grade_categories()) == 0
  })
  
  observeEvent(input$submit, {
    
    req(grade_categories())
    req(missing_input())
    
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
    return_value = grade_categories,
    click = reactive({ input$submit }),
    missing_input = missing_input
  ))
  
}