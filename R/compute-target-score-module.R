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
    
    ni <- tidy_performance()$Counts[tidy_performance()$`Grade Categories` == input$target_grade_category]
    wi <- tidy_performance()$Weights[tidy_performance()$`Grade Categories` == input$target_grade_category] / 100
    
    sum_wi <- sum(tidy_performance()$Weights, na.rm = TRUE) / 100
    partial_sum_weighted_avg <- sum(tidy_performance()$`Weighted Average`[tidy_performance()$`Grade Categories` != input$target_grade_category], na.rm = TRUE)
    sum_Xik <- sum(scores()[[input$target_grade_category]], na.rm = TRUE)
    G_star <- input$target_grade

    out <- (ni + 1) * (((sum_wi * G_star) - partial_sum_weighted_avg) / wi) - sum_Xik
    
    round(out, 2)
  })
  
  # observeEvent(input$submit,{
  #   
  #   ni <- tidy_performance()$Counts[tidy_performance()$`Grade Categories` == input$target_grade_category]
  #   wi <- tidy_performance()$Weights[tidy_performance()$`Grade Categories` == input$target_grade_category] / 100
  #   
  #   sum_wi <- sum(tidy_performance()$Weights, na.rm = TRUE) / 100
  #   partial_sum_weighted_avg <- sum(tidy_performance()$`Weighted Average`[tidy_performance()$`Grade Categories` != input$target_grade_category], na.rm = TRUE)
  #   sum_Xik <- sum(scores()[[input$target_grade_category]], na.rm = TRUE)
  #   G_star <- input$target_grade
  #   
  #   out <- (ni + 1) * (((sum_wi * G_star) - partial_sum_weighted_avg) / wi) - sum_Xik
  #   
  #   print(lst(out, ni, wi, sum_wi, partial_sum_weighted_avg, sum_Xik, G_star))
  # })
  
  
  target_score_2 <- eventReactive(input$submit, {

    np <- tidy_performance()$Counts[tidy_performance()$`Grade Categories` == input$target_grade_category]
    wp <- tidy_performance()$Weights[tidy_performance()$`Grade Categories` == input$target_grade_category] / 100
    G_star <- input$target_grade
    G <- current_grade()
    avg_p <- tidy_performance()$`Percentage Average`[tidy_performance()$`Grade Categories` == input$target_grade_category]
    weighted_avg_p <- tidy_performance()$`Weighted Average`[tidy_performance()$`Grade Categories` == input$target_grade_category]
    sum_scores_p <- sum(scores()[[input$target_grade_category]], na.rm = TRUE)
    sum_w <- sum(tidy_performance()$Weights / 100, na.rm = TRUE)

    out <- ((np+1) / wp) * ((G_star*sum_w) - G + weighted_avg_p) - (np*avg_p)

    lst(out, np, wp, G_star, G, sum_w, weighted_avg_p, sum_scores_p)

  })

  observeEvent(input$submit, {
    print(target_score())
    print(target_score_2())
  })
  
  return(list(
    return_value = target_score,
    click = reactive({ input$submit })
  ))
  
  
}