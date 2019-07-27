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
      out <- pmap(list(grade_category = tidy_performance()$`Grade Categories`,
                       percentage = tidy_performance()$`Percentage Average`),
                  
                  function(grade_category, percentage){
                    
                    percentage <- round(percentage, 2)
                    
                    valueBox(
                      value = paste(percentage, "%"), 
                      subtitle = grade_category, 
                      color = get_grade_color(percentage), 
                      icon = icon(get_grade_icon(percentage))
                    )
                  }) %>%
        tagList()
    }
    
    return(out)
    
  })
  
  return(tidy_performance)
  
}