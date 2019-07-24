shinyServer(function(input, output, session){
    
    # User chooses assessment types
    
    assessments <- callModule(module = assessment_types_module, id = "assessment_types")
    
    observeEvent(assessments$click(), {
        
        if(assessments$complete()$complete){
            shinyjs::show(id = "box2", anim = TRUE, animType = "fade")
        } else {
            shinyjs::hide(id = "box2", anim = TRUE, animType = "fade")
            shinyjs::hide(id = "box3", anim = TRUE, animType = "fade")
            shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
        }
    })
    
    # User specifies counts and weights for each assessment type
    
    counts_and_weights <- callModule(module = counts_and_weights_module, id = "counts-and-weights", assessments = assessments$return_value)
    
    observeEvent(counts_and_weights$click(), {
        
        print(counts_and_weights$complete()$complete)
        
        if(counts_and_weights$complete()$complete){
            shinyjs::show(id = "box3", anim = TRUE, animType = "fade")
        } else {
            shinyjs::hide(id = "box3", anim = TRUE, animType = "fade")
            shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
        }
        
    })
    
    
    # User enters scores
    
    scores <- callModule(module = scores_module, id = "scores", counts_and_weights = counts_and_weights$return_value)
    
    observeEvent(scores$click(), {
        
        print(scores$complete()$complete)
        
        if(scores$complete()$complete){
            shinyjs::show(id = "box4", anim = TRUE, animType = "fade")
        } else {
            shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
        }
        
    })
    
    # Display performance (percentages) by assessment type in value boxes
    
    tidy_performance <- callModule(module = performance_by_assessment_valuebox_module, id = "performance-by-assessment", 
                                   counts_and_weights = counts_and_weights$return_value, scores = scores$return_value)
    
    # Display the evolution of scores by assessment type in bar plots
    
    callModule(module = scores_evolution_module, id = "scores-evolution", scores = scores$return_value)
    
    # Display the total grade
    
    callModule(module = total_grade_module, id = "total-grade", tidy_performance = tidy_performance)
    
})
