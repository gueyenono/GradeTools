scores_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    p("Enter your scores:"),
    
    rHandsontableOutput(outputId = ns("scores")),
    
    br(),
    
    actionButton(inputId = ns("submit"), label = "Submit")
    
  )
  
}

scores_module <- function(input, output, session, counts_and_weights){
  
  # Initial display
  
  # >> Determine the position of read-only cells
  
  read_only_cells <- reactive({
    
    req(counts_and_weights())
    isolate(counts_and_weights())
    
    max_count <- max(counts_and_weights()$Counts, na.rm = TRUE)
    
    read_only_cols <- which(counts_and_weights()$Counts != max(counts_and_weights()$Counts))
    read_only_rows <- map(counts_and_weights()$Counts[read_only_cols], ~ seq(from = .x+1, to = max_count, by = 1))
    
    read_only_cells <- map2(read_only_rows, as.list(read_only_cols), function(.x, .y){
      map2(rep(.x, length(.y)), .y, ~ c(.x, .y))
    }) %>%
      flatten()
  })
  
  # >> Display
  
  output$scores <- renderRHandsontable({
    
    isolate(counts_and_weights())
    
    if(is.null(counts_and_weights())){
      out <- NULL
    } else {
      max_count <- max(counts_and_weights()$Counts, na.rm = TRUE)
      
      out <- rerun(nrow(counts_and_weights()), rep(NA_real_, max_count)) %>%
        as.data.table() %>%
        setNames(counts_and_weights()$`Assessment Types`) %>%
        rhandsontable() %>%
        hot_table(stretchH = "all") %>%
        make_read_only_cells(read_only_cells = read_only_cells())
    }
    
    return(out)

  })
  
  
  # Determines if user failed to enter a required inputs
  
  missing_input <- eventReactive(input$submit, {
    
    map2_lgl(as.list(hot_to_r(input$scores)), as.list(counts_and_weights()$Counts),
         ~ ifelse(sum(!is.na(.x)) == .y, FALSE, TRUE)) %>%
      any()
    
  })
  
  user_inputs <- eventReactive(input$submit, {
    
    df <- hot_to_r(input$scores)
    
    if(missing_input()){
      out <- NULL
    } else {
      out <- df
    }
    
    return(out)
    
  })
  
  observeEvent(input$submit, {
    
    if(missing_input()){
      
      shinyalert(
        title = "Warning!",
        text = "You have not provided all the necessary \"Scores\" values.",
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