counts_and_weights_module_ui <- function(id){
  
  ns <- NS(id)
  
  box(
    
    title = "Counts and Weights", solidHeader = TRUE, status = "primary",
    
    p("Provide the count and weight for each assessment type:"),
    
    uiOutput(outputId = ns("counts_and_weights")),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}

counts_and_weights_module <- function(input, output, session, assessments){
  
  output$counts_and_weights <- renderUI({
    
    lapply(assessments(), function(x){
      
      p(x)
      
    }) %>% tagList()
    
  })
  
}