shinyServer(function(input, output, session){
    
    # User chooses assessment types
    
    assessments <- callModule(module = assessment_types_module, id = "assessment_types")
    
    # User specifies counts and weights for each assessment type
    
    counts_and_weights <- callModule(module = counts_and_weights_module, id = "counts-and-weights", assessments = assessments)
    
    # User enters scores
    
    scores <- callModule(module = scores_module, id = "scores", counts_and_weights = counts_and_weights)
    
    # Display weighted averages
    
    callModule(module = performance_percentages_module, id = "performance-weights", counts_and_weights = counts_and_weights, scores = scores)
    
    # observe({ 
    #     print(counts_and_weights())
    #     print(scores())
    # })
    
  })