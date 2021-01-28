library(shiny)
library(bs4Dash)
library(shinyjs)

ui <- dashboardPage(
  
  dashboardHeader(title = "bs4Dash + shinyjs"),
  
  dashboardSidebar(),
  
  dashboardBody(
    
    useShinyjs(),
    
    bs4Dash::box(
      id = "box",
      title = "My box",
      status = "primary",
      
      "Just some stuff here"
    ),
    
    actionButton(inputId = "btn", label = "Click")
    
  )
  
)
  

server <- function(input, output, session){
  
  observeEvent(input$btn, {
    
    shinyjs::toggle(id = "box")
    
  })
  
}

shinyApp(ui = ui, server = server)