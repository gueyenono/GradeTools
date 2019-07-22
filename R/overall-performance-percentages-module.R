performance_percentages_module_ui <- function(id){
  
  ns <- NS(id)
  
  uiOutput(outputId = ns("performance"))
  
}


performance_percentages_module <- function(input, output, session, counts_and_weights, scores){
  
  tidy_performance <- reactive({
    gather(scores(), key = "Assessment Types", value = "Scores") %>%
      left_join(counts_and_weights()) %>%
      filter(!is.na(Scores)) %>%
      group_by(`Assessment Types`) %>%
      summarize_at(.vars = vars(Scores, Counts, Weights), .funs = mean) %>%
      mutate(`Weighted Average` = (Scores * (Weights / 100)) / (sum(Weights) / 100)) %>%
      rename(`Percentage Average` = Scores)
  })
  
  observe({
    print(tidy_performance())
  })
  
  output$performance <- renderUI({
    
    req(tidy_performance())
    
    pmap(list(assessment_type = tidy_performance()$`Assessment Types`,
              percentage = tidy_performance()$`Percentage Average`),
         
         function(assessment_type, percentage){
           
           color <- case_when(
             percentage >= 90                   ~ "green",
             percentage < 90 & percentage >= 80 ~ "lime",
             percentage < 80 & percentage >= 70 ~ "blue",
             percentage < 70 & percentage >= 60 ~ "yellow",
             percentage < 60                    ~ "red"
           )
           
           icon <- case_when(
             percentage >= 90                   ~ "grin-stars",
             percentage < 90 & percentage >= 80 ~ "smile-beam",
             percentage < 80 & percentage >= 70 ~ "meh",
             percentage < 70 & percentage >= 60 ~ "grimace",
             percentage < 60                    ~ "sad-tear"
           )
           
           valueBox(
             value = paste(percentage, "%"), 
             subtitle = assessment_type, 
             color = color, 
             icon = icon(icon)
           )
         }) %>%
      tagList()
    
  })
  
}