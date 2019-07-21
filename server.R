shinyServer(function(input, output, session){
    
    enabled <- reactiveValues(counts_and_weights = FALSE, scores = FALSE)
    
    # User chooses assessment types
    
    assessments <- callModule(module = assessment_types_module, id = "assessment_types")
    
    observe({
        if(length(assessments()) != 0){
            enabled$counts_and_weights = TRUE
        }
    })
    
    
    # User specifies counts and weights for each assessment type
    
    counts_and_weights <- callModule(module = counts_and_weights_module, id = "counts-and-weights", assessments = assessments)
    
    
    # User enters scores
    
    scores <- callModule(module = scores_module, id = "scores", counts_and_weights = counts_and_weights)
    
    observe({ print(counts_and_weights()) })
    
  })