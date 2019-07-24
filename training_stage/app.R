library(shiny)
library(shinydashboard)
library(shinyjs)

ui <- dashboardPage(
  
  dashboardHeader(title = "The mtcars app"),
  dashboardSidebar(),
  dashboardBody(
    
    useShinyjs(),
    
    fluidRow(
      box(
        textInput(inputId = "var1", label = "variable 1"),
        textInput(inputId = "var2", label = "variable 2"),
        actionButton(inputId = "submit", label = "Submit"),
        width = 4
      ),
      
      shinyjs::hidden(
        div(id = "plot",
            box(
              plotOutput(outputId = "scatterplot")
            ))
      )
    )
    
  )
  
)

server <- function(input, output, session){
  
  var1 <- eventReactive(input$submit, {
    sqrt(mtcars[, input$var1])
  })
  
  var2 <- eventReactive(input$submit, {
    sqrt(mtcars[, input$var2])
  })
  
  missing_input <- reactive({
    length(input$var1) == 0 & length(input$var2) == 0
  })
  
  observe({
    if(!missing_input()){
      shinyjs::show(id = "plot")
    } else {
      shinyjs::hide(id = "plot")
    }
  })
  
  output$scatterplot <- renderPlot({
    
    plot(x = var1(), y = var2())
    
  })
  
}

shiny::shinyApp(ui = ui, server = server )