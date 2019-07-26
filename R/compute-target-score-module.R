compute_target_score_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    uiOutput(outputId = ns("select_input")),
    
    br(),
    
    uiOutput(outputId = ns("numeric_input")),
    
    br(),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}


compute_target_score_module <- function(input, output, session, grade_categories, scores, tidy_performance, current_grade){
  
  output$select_input <- renderUI({
    selectInput(
      inputId = session$ns("target_grade_category"), 
      label = "Choose grade category:", 
      choices = grade_categories()
    )
  })
  
  output$numeric_input <- renderUI({
    sliderInput(
      inputId = session$ns("target_grade"), 
      label = "What is your target grade?", 
      min = 0, max = 100, value = current_grade(),
      post = "%"
    )
  })

  
  target_score <- eventReactive(input$submit, {
    
    ni <- tidy_performance()[tidy_performance()$`Grade Categories` == input$target_grade_category, "Counts"]
    wi <- tidy_performance()[tidy_performance()$`Grade Categories` == input$target_grade_category, "Weights"] / 100
    
    sum_wi <- sum(tidy_performance()$Weights) / 100
    partial_sum_weigthed_avg <- sum(tidy_performance()[tidy_performance()$`Grade Categories` != input$target_grade_category, "Weighted Average"])
    sum_Xik <- sum(scores()[[input$target_grade_category]])
    G_star <- input$target_grade

    out <- (ni + 1) * (((sum_wi * G_star) - partial_sum_weigthed_avg) / wi) - sum_Xik
    
    round(out, 2)
  })
  
  target_score_2 <- eventReactive(input$submit, {
    
    ni <- tidy_performance()[tidy_performance()$`Grade Categories` == input$target_grade_category, "Counts"]
    wi <- tidy_performance()[tidy_performance()$`Grade Categories` == input$target_grade_category, "Weights"] / 100
    xi_bar <- tidy_performance()[tidy_performance()$`Grade Categories` == input$target_grade_category, "Percentage Average"]
    
    sum_wi <- sum(tidy_performance()$Weights) / 100
    sum_weighted_avg <- sum(tidy_performance()[, "Weighted Average"])
    partial_sum_weigthed_avg <- sum(tidy_performance()[tidy_performance()$`Grade Categories` != input$target_grade_category, "Weighted Average"])
    sum_Xik <- sum(scores()[[input$target_grade_category]])
    G_star <- input$target_grade
    
    out <- ((ni + 1) * sum_wi) - sum_Xik + ((ni + 1) / wi) * ((xi_bar * sum_wi) - partial_sum_weigthed_avg)
    
    round(out, 2)
  })
  
  observeEvent(input$submit, {
    
    print(paste("Target score (first formula) is:", target_score()))
    print(paste("Target score (second formula) is:", target_score_2()))
    
  })
  
  return(list(
    return_value = target_score,
    click = reactive({ input$submit })
  ))
  
  
}