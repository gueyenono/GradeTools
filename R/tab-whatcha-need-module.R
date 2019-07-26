tab_whatcha_need_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    fluidRow(
      
      box(
        title = "Current Total Grade", solidHeader = TRUE, status = "primary", width = 4,
        display_current_grade_module_ui(id = ns("display-current-grade-module"))
      ),
      
      box(
        title = "Set Your Target", solidHeader = TRUE, status = "primary", width = 4,
        compute_target_score_module_ui(id = ns("set-targets-module"))
      ),
      
      box(
        title = "Whatcha Need", solidHeader = TRUE, status = "primary", width = 4,
        display_target_score_module_ui(id = ns("target-grade-module"))
      )
      
    )
  )
}



tab_whatcha_need_module <- function(input, output, session, tab_compute_grade){
  
  callModule(module = display_current_grade_module, id = "display-current-grade-module",
             current_grade = tab_compute_grade$total_grade$grade,
             grade_color = tab_compute_grade$total_grade$grade_color,
             grade_icon = tab_compute_grade$total_grade$grade_icon)
  
  target_score <- callModule(module = compute_target_score_module, id = "set-targets-module",
                             grade_categories = tab_compute_grade$grade_categories$return_value,
                             scores = tab_compute_grade$scores$return_value,
                             tidy_performance = tab_compute_grade$tidy_performance,
                             current_grade = tab_compute_grade$total_grade$grade)
  
  callModule(module = display_target_score_module, id = "target-grade-module", target_score = target_score)
  
}