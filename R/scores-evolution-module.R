scores_evolution_module_ui <- function(id){
  
  ns <- NS(id)
  
  plotOutput(outputId = ns("performance"))
  
}


scores_evolution_module <- function(input, output, session, scores){
  
  tidy_scores <- reactive({
    scores() %>%
      mutate(Assessment = as.factor(row_number())) %>%
      gather(key = "Assessment Types", value = "Scores", -Assessment)
      
  })
  
  output$performance <- renderPlot({
    
    ggplot(data = tidy_scores(), aes(x = Assessment, y = Scores)) +
      geom_col() +
      theme_bw() +
      facet_wrap(~ `Assessment Types`)
    
  })
  
}