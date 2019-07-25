performance_by_grade_category_valuebox_module_ui <- function(id){
  
  ns <- NS(id)
  
  uiOutput(outputId = ns("performance"))
  
}


performance_by_grade_category_valuebox_module <- function(input, output, session, counts_and_weights, scores){
  
  tidy_performance <- reactive({
    
    if(is.null(counts_and_weights()) | is.null(scores())){
      out <- NULL
    } else {
      out <- gather(scores(), key = "Grade Categories", value = "Scores") %>%
        left_join(counts_and_weights()) %>%
        filter(!is.na(Scores)) %>%
        group_by(`Grade Categories`) %>%
        summarize_at(.vars = vars(Scores, Counts, Weights), .funs = mean) %>%
        mutate(`Weighted Average` = (Scores * (Weights / 100))) %>%
        rename(`Percentage Average` = Scores)
    }
    return(out)
  })
  
  observe({
    print(tidy_performance())
  })
  
  output$performance <- renderUI({
    
    req(tidy_performance())
    
    if(is.null(tidy_performance())){
      out <- NULL
    } else {
      out <- pmap(list(assessment_type = tidy_performance()$`Grade Categories`,
                       percentage = tidy_performance()$`Percentage Average`),
                  
                  function(assessment_type, percentage){
                    
                    percentage <- round(percentage, 2)
                    
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
    }
    
    return(out)
    
  })
  
  return(tidy_performance)
  
}