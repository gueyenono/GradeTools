total_grade_module_ui <- function(id){
  
  ns <- NS(id)
  
  uiOutput(outputId = ns("total_grade"))
  
}

total_grade_module <- function(input, output, session, tidy_performance){
  
  grade <- reactive({
    
    if(is.null(tidy_performance())){
      out <- NULL
    } else {
      out <- sum(tidy_performance()$`Weighted Average`) / (sum(tidy_performance()$Weights)/100)
      out <- round(out, 2)
    }
    
    return(out)
  })
  
  observe({
    print(grade())
  })
  
  output$total_grade <- renderUI({
    
    if(is.null(grade())){
      NULL
    } else {
      color <- case_when(
        grade() >= 90                ~ "green",
        grade() < 90 & grade() >= 80 ~ "lime",
        grade() < 80 & grade() >= 70 ~ "blue",
        grade() < 70 & grade() >= 60 ~ "yellow",
        grade() < 60                 ~ "red"
      )
      
      icon <- case_when(
        grade() >= 90                ~ "grin-stars",
        grade() < 90 & grade() >= 80 ~ "smile-beam",
        grade() < 80 & grade() >= 70 ~ "meh",
        grade() < 70 & grade() >= 60 ~ "grimace",
        grade() < 60                 ~ "sad-tear"
      )
      
      valueBox(
        value = paste(grade(), "%"), 
        subtitle = "Total Grade", 
        color = color, 
        icon = icon(icon)
      )
    }
    
  })
  
}