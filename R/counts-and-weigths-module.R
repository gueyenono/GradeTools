counts_and_weights_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    p("Provide the count and weight for each assessment type:"),
    
    rHandsontableOutput(outputId = ns("counts_and_weights")),
    
    br(),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}

counts_and_weights_module <- function(input, output, session, grade_categories){
  
  output$counts_and_weights <- renderRHandsontable({
    
    if(length(grade_categories()) == 0){
      out <- NULL
    } else {
      out <- data.table(
        "Grade Categories" = grade_categories(),
        "Counts" = NA_integer_,
        "Weights" = NA_real_
      ) %>%
        rhandsontable(rowHeaders = NULL) %>%
        hot_col(col = "Grade Categories", readOnly = TRUE) %>%
        hot_col(col = "Weights", format = "0.00%") %>%
        hot_table(stretchH = "all")
    }
    
  })
  
  missing_input <- eventReactive(input$submit, {
    
    map_lgl(as.list(hot_to_r(input$counts_and_weights)), ~ any(is.na(.x))) %>%
      any()
    
  })
  
  
  user_inputs <- eventReactive(input$submit, {
    
    df <- hot_to_r(input$counts_and_weights)
    
    if(any(is.na(df$Counts)) | any(is.na(df$Weights))){
      out <- NULL
    } else {
      out <- df
    }
    
    return(out)
    
  })
  
  observeEvent(input$submit, {
    
    if(is.null(user_inputs())){
      
      shinyalert(
        title = "Warning!",
        text = "You have not provided all the necessary \"Counts and Weights\" values.",
        type = "warning",
        closeOnEsc = TRUE,
        closeOnClickOutside = TRUE,
        showConfirmButton = TRUE,
        animation = "slide-from-top"
      )
      
      shinyjs::enable(id = "submit")
      
    } 
  })
  
  return(list(
    return_value = user_inputs,
    click = reactive({ input$submit }),
    missing_input = missing_input
  ))
  
}