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
    
    tidy_scores() %>%
      filter(!is.na(Scores)) %>%
      ggplot(aes(x = Assessment, y = Scores)) +
      geom_col() +
      # geom_point(aes(x = as.numeric(as.character(Assessment)), y = Scores)) +
      # geom_line(aes(x = as.numeric(as.character(Assessment)), y = Scores)) +
      theme_bw() +
      facet_wrap(~ `Assessment Types`, 
                 ncol = 3, nrow = ceiling(ncol(scores())/3),
                 scales = "free_x") +
      scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                         labels = seq(from = 0, to = 100, by = 10))
    
  })
  
}