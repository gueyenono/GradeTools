tab_compute_grade_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    fluidRow(
      
      
      bs4Card(
        id = ns("box1"), title = "Grade Categories", solidHeader = TRUE, status = "primary", closable = FALSE,
        grade_categories_module_ui(id = ns("grade-categories"))
      ),
      
      shinyjs::hidden(div(id = ns("box2"),
                          bs4Card(
                            title = "Counts and Weights", solidHeader = TRUE, status = "primary", closable = FALSE,
                            counts_and_weights_module_ui(id = ns("counts-and-weights"))
                          ))
      ),
      
      shinyjs::hidden(div(id = ns("box3"),
                          bs4Card(
                            title = "Scores", solidHeader = TRUE, status = "primary", closable = FALSE,
                            scores_module_ui(id = ns("scores"))
                          )
      ))
    ),
    
    fluidRow(
      
      shinyjs::hidden(div(id = ns("box4"),
                          bs4Card(
                            title = "Evolution of Scores", width = 4,
                            scores_evolution_module_ui(id = ns("scores-evolution"))
                          ),
                          
                          bs4Card(
                            title = "Performance by Assessment Type", width = 4,
                            performance_by_grade_category_valuebox_module_ui(id = ns("performance-by-assessment"))
                          ),
                          
                          bs4Card(
                            title = "Overall Performance", width = 4,
                            total_grade_module_ui(id = ns("total-grade"))
                          )
      ))
    )
  )
}

tab_compute_grade_module <- function(input, output, session){
  
  reactive_output <- reactiveValues()
  
  # User chooses assessment types
  
  grade_categories <- callModule(module = grade_categories_module, id = "grade-categories")
  
  observeEvent(grade_categories$click(), {
    
    if(!grade_categories$missing_input()){
      shinyjs::show(id = "box2", anim = TRUE, animType = "fade")
      shinyjs::hide(id = "box3", anim = TRUE, animType = "fade")
      shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
    } else {
      shinyjs::hide(id = "box2", anim = TRUE, animType = "fade")
      shinyjs::hide(id = "box3", anim = TRUE, animType = "fade")
      shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
    }
  })
  
  # User specifies counts and weights for each assessment type
  
  counts_and_weights <- callModule(module = counts_and_weights_module, id = "counts-and-weights", grade_categories = grade_categories$return_value)
  
  observeEvent(counts_and_weights$click(), {
    
    if(!grade_categories$missing_input() & !counts_and_weights$missing_input()){
      shinyjs::show(id = "box3", anim = TRUE, animType = "fade")
      shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
    } else {
      shinyjs::hide(id = "box3", anim = TRUE, animType = "fade")
      shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
    }
    
  })
  
  
  # User enters scores
  
  scores <- callModule(module = scores_module, id = "scores", counts_and_weights = counts_and_weights$return_value)
  
  observeEvent(scores$click(), {
    
    if(!grade_categories$missing_input() & !counts_and_weights$missing_input() & !scores$missing_input()){
      shinyjs::show(id = "box4", anim = TRUE, animType = "fade")
    } else {
      shinyjs::hide(id = "box4", anim = TRUE, animType = "fade")
    }
    
    print(scores$return_value())
    
  })
  
  # Display performance (percentages) by assessment type in value boxes
  
  tidy_performance <- callModule(module = performance_by_grade_category_valuebox_module, id = "performance-by-assessment", 
                                 counts_and_weights = counts_and_weights$return_value, scores = scores$return_value)
  
  # Display the evolution of scores by assessment type in bar plots
  
  callModule(module = scores_evolution_module, id = "scores-evolution", scores = scores$return_value)
  
  # Display the total grade
  
  total_grade <- callModule(module = total_grade_module, id = "total-grade", tidy_performance = tidy_performance)
  
  
  return(list(
    grade_categories = grade_categories,
    counts_and_weights = counts_and_weights,
    scores = scores,
    tidy_performance = tidy_performance,
    total_grade = total_grade
  ))
  
}