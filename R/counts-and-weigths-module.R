counts_and_weights_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    p("Provide the count and weight for each assessment type:"),
    
    rHandsontableOutput(outputId = ns("counts_and_weights")),
    
    br(),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}

counts_and_weights_module <- function(input, output, session, assessments){
  
  output$counts_and_weights <- renderRHandsontable({
    
    if(length(assessments()) != 0){
      
      dat <- data.table(
        "Assessment Types" = stringr::str_to_title(assessments()),
        "Counts" = NA_integer_,
        "Weights" = NA_real_
      ) %>%
        rhandsontable(rowHeaders = NULL) %>%
        hot_col(col = 1, readOnly = TRUE) %>%
        hot_table(stretchH = "all")
      
    } else {
      
      dat <- NULL
      
    }
    
    return(dat)

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
      
    }
    
  })
  
  return(user_inputs)
  
}