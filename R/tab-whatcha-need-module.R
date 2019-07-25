tab_whatcha_need_module_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    tabName = ns("whatcha_need"),
    
    box(
      title = "Current Total Grade", solidHeader = TRUE, status = "primary", width = 4,
      valueBoxOutput(outputId = ns("total_grade"))
    ),
    
    box(
      title = "Your goal", solidHeader = TRUE, status = "primary", width = 4,
      
      uiOutput(outputId = ns("select_input")),
      
      br(),
      
      uiOutput(outputId = ns("numeric_input"))
    ),
    
    box(
      title = "Whatcha Need", solidHeader = TRUE, status = "primary", width = 4
    )
  )
}

tab_whatcha_need_module <- function(input, output, session, tab_compute_grade){
  
  output$total_grade <- renderValueBox({
    valueBox(
      value = paste(tab_compute_grade$total_grade(), "%"),
      subtitle = "Current grade", 
      icon = icon(tab_compute_grade$grade_icon()),
      color = tab_compute_grade$grade_color()
    )
  })
  
  output$select_input <- renderUI({
    selectInput(
      inputId = session$ns("grade_category"), 
      label = "Choose grade category", 
      choices = tab_compute_grade$assessments()
    )
  })
  
  output$numeric_input <- renderUI({
    sliderInput(
      inputId = session$ns("goal"), 
      label = "What is your goal?", 
      min = 0, max = 100, value = tab_compute_grade$total_grade(),
      post = "%"
    )
  })
  
}