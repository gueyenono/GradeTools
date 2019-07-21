scores_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    p("Enter your scores:"),
    
    rHandsontableOutput(outputId = ns("scores"))
    
  )
  
}

scores_module <- function(input, output, session, counts_and_weights){
  
  
  scores_display <- reactive({
    
    if(!is.null(counts_and_weights())){
      
      max_count <- max(counts_and_weights()$Counts, na.rm = TRUE)
      
      hot <- rerun(nrow(counts_and_weights()), rep(NA_real_, max_count)) %>%
        as.data.table() %>%
        setNames(counts_and_weights()$`Assessment Types`) %>%
        rhandsontable() %>%
        hot_table(stretchH = "all")
      
      # #--
      # read_only_cols <- c(1, 2)
      # read_only_rows <- map(c(2, 3), ~ seq(from = .x+1, to = max_count, by = 1))
      # max_count <- 6
      # 
      # read_only_rows <- map(read_only_rows, ~ seq(from = .x+1, to = max_count))
      # #--
      
      read_only_cols <- which(counts_and_weights()$Counts != max(counts_and_weights()$Counts))
      read_only_rows <- map(counts_and_weights()$Counts[read_only_cols], ~ seq(from = .x+1, to = max_count, by = 1))
      
      read_only_cells <- map2(read_only_rows, as.list(read_only_cols), function(.x, .y){
        map2(rep(.x, length(.y)), .y, ~ c(.x, .y))
      }) %>%
        flatten()
        
      out <- make_read_only_cells(hot = hot, read_only_cells = read_only_cells)
      
    } else {
      
     out <- NULL
      
    }
    
    return(out)
    
  })
  
  output$scores <- renderRHandsontable({
    
    scores_display()
    
  })
  
}