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
  
  grade_color <- reactive({
    
    if(is.null(grade())){
      out <- NULL
    } else {
      out <- case_when(
        grade() >= 90                ~ "green",
        grade() < 90 & grade() >= 80 ~ "blue",
        grade() < 80 & grade() >= 70 ~ "yellow",
        grade() < 70 & grade() >= 60 ~ "orange",
        grade() < 60                 ~ "red"
      )
    }
    return(out)
  })
  
  grade_icon <- reactive({
    
    if(is.null(grade())){
      out <- NULL
    } else {
      out <- case_when(
        grade() >= 90                ~ "grin-stars",
        grade() < 90 & grade() >= 80 ~ "smile-beam",
        grade() < 80 & grade() >= 70 ~ "meh",
        grade() < 70 & grade() >= 60 ~ "grimace",
        grade() < 60                 ~ "sad-tear"
      )
    }
    
  })
  
  output$total_grade <- renderUI({
    
    valueBox(
      value = paste(grade(), "%"), 
      subtitle = "Total Grade", 
      color = grade_color(), 
      icon = icon(grade_icon())
    )
    
  })
  
  return(list(
    grade = grade,
    grade_color = grade_color,
    grade_icon = grade_icon
  ))
  
}