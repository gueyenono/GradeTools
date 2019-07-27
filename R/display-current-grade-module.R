display_current_grade_module_ui <- function(id){
  
  ns <- NS(id)
  
  uiOutput(outputId = ns("grade"))
}


display_current_grade_module <- function(input, output, session, current_grade, grade_color, grade_icon){
  
  output$grade <- renderUI({
    
    valueBox(
      value = paste(current_grade(), "%"),
      subtitle = "Current grade",
      icon = icon(grade_icon()),
      color = grade_color()
    )
    
  })
  
}