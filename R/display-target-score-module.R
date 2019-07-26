display_target_score_module_ui <- function(id){
  
  ns <- NS(id)
  
  uiOutput(outputId = ns("value_box"))
  
}


display_target_score_module <- function(input, output, session, target_score){
  
  # output$value_box <- renderUI({
  #   valueBox(
  #     value = paste(target_score(), "%"),
  #     subtitle = "Target Score",
  #     color = get_grade_color(target_score()),
  #     icon = icon(get_grade_icon(target_score()))
  #   )
  # })
  
}