target_grade_module_ui <- function(id){
  
  ns <- NS(id)
  
  uiOutput(outputId = ns("value_box"))
  
}


target_grade_module <- function(input, output, session, target_grade, tidy_performance){
  
  # ni <- tidy_performance()[tidy_performance()$`Assessment`]
  
  output$value_box <- renderUI({
    valueBox(
      value = paste(),
      subtitle = "Target Score",
      icon = icon(),
      color = "blue"
    )
  })
  
}