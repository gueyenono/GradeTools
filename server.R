function(input, output, session){
    
    # User chooses assessment types
    
    assessments <- callModule(module = assessment_types_module, id = "assessment_types")
    
    # User specifies counts and weights for each assessment type
    
    counts_and_weights <- callModule(module = counts_and_weights_module, id = "counts-and-weights", assessments = assessments)
    
    # User enters scores
    
    scores <- callModule(module = scores_module, id = "scores", counts_and_weights = counts_and_weights)
    
    # Display performance (percentages) by assessment type in value boxes
    
    tidy_performance <- callModule(module = performance_by_assessment_valuebox_module, id = "performance-weights", counts_and_weights = counts_and_weights, scores = scores)
    
    # Display the evolution of scores by assessment type in bar plots
    
    callModule(module = scores_evolution_module, id = "scores-evolution", scores = scores)
    
    # Display the total grade
    
    callModule(module = total_grade_module, id = "total-grade", tidy_performance = tidy_performance)
    
  }