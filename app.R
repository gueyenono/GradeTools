# library(shiny)
# library(shinyjs)
# library(magrittr)
# 
# 
# # APP USER INTERFACE
# 
# ui <- fluidPage(
#   
#   useShinyjs(),
#   
#   headerPanel("Wanna know your grade?"),
#   
#   sidebarPanel(
#     
#     # Select evaluation types
#     uiOutput(outputId = "dynout_evals"),
#     
#     tags$hr(), # Horizontal line
#     
#     # Dynamic output for selected evaluations
#     uiOutput(outputId = "dynout1"),
#     
#     # Submit button
#     actionButton(inputId = "submit", label = "Submit")
#   ),
#   
#   #
#   mainPanel(
#     
#     # Dynamic output for entering scores
#     uiOutput(outputId = "dynout2"),
#     
#     # The "Calculate Grade" action button
#     actionButton(inputId = "calculate", label = "Calculate grade"),
#     
#     br(), br(),
#     
#     htmlOutput(outputId = "txt")
#   )
# )
# 
# 
# # APP SERVER LOGIC
# 
# server <- function(input, output, session){
#   
#   evals <- c("Homework", "Exam", "Quiz", "Final")
#   evalabbs <- c("Homework" = "hw", "Exam" = "ex", "Quiz" = "qz", "Final" = "fn")
#   wt_react <- reactiveValues()
#   
#   # Dynamically create checkboxGroupInput for the evaluations'types
#   output$dynout_evals <- renderUI({
#     checkboxGroupInput(inputId = "evals", label = "Select evaluation types", choices = evals)
#   })
#   
#   # Numeric and slider inputs for number of evaluations and weights (hidden)
#   output$dynout1 <- renderUI({
#     n_wt <- lapply(seq(length(evals)), function(i){
#       list(div(id = evalabbs[evals[i]],
#                numericInput(inputId = paste0("n_", evalabbs[evals[i]]), label = paste0("Number of ", evals[i]), value = 1, min = 1, max = 10),
#                sliderInput(inputId = paste0("wt_", evalabbs[evals[i]]), label = paste0(evals[i], " weight"), value = 0, min = 0, max = 100, step = 5, post = "%"),
#                tags$hr()))}) %>% tagList
#     
#     shinyjs::hidden(n_wt)
#   })
#   
#   # Numeric inputs to enter scores (hidden)
#   output$dynout2 <- renderUI({
#     
#     sc <- lapply(evals, function(i){
#       sc0 <- lapply(1:10, function(j){
#         numericInput(inputId = paste0("sc_", evalabbs[i], j), label = paste0(i, " ", j, " score"), value = 0, min = 0, max = 110)
#       }) %>% tagList
#     }) %>% tagList
#     
#     shinyjs::hidden(sc)
#   })
#   
#   # Disable the "Calculate grade" action button when the app initializes
#   shinyjs::disable(id = "calculate")
#   
#   # Show/hide inputs for number of evals and weights based on checkboxGroupInput
#   observe({
#     for(i in evals){
#       if(i %in% input$evals){
#         shinyjs::show(id = paste0(evalabbs[i]))
#       } else {
#         shinyjs::hide(id = paste0(evalabbs[i]))
#       }
#     }
#   })
#   
#   # Click the submit button after number of evals and weights have been selected
#   observeEvent(eventExpr = input$submit, handlerExpr = {
#     
#     if(length(input$evals) == 0){
#       
#       shinyjs::disable(id = "calculate")
#       
#       lapply(evals, function(i){
#         lapply(seq(10), function(j){
#           shinyjs::hide(id = paste0("sc_", evalabbs[i], j))
#         })
#       })
#     } else {
#       
#       shinyjs::enable(id = "calculate")
#       
#       lapply(evals, function(i){
#         if(i %in% input$evals){
#           n <- input[[paste0("n_", evalabbs[i])]] %>% seq
#           wt_react[[i]] <- input[[paste0("wt_", evalabbs[i])]]
#           lapply(seq(10), function(j){
#             if(j %in% n){
#               shinyjs::show(id = paste0("sc_", evalabbs[i], j))
#             } else {
#               shinyjs::hide(id = paste0("sc_", evalabbs[i], j))
#             }
#           })
#         } else {
#           lapply(seq(10), function(j){
#             shinyjs::hide(id = paste0("sc_", evalabbs[i], j))
#           })
#         }
#       })
#     }
#   })
#   
#   # Click the "Calculate grade" button
#   observeEvent(eventExpr = input$calculate, handlerExpr = {
#     
#     # Compute the percentages per evaluation
#     pct_list <- lapply(input$evals, function(i){
#       
#         scores <- sapply(seq(input[[paste0("n_", evalabbs[i])]]), function(j){
#           input[[paste0("sc_", evalabbs[i], j)]]
#         })
#         
#         (sum(scores) / input[[paste0("n_", evalabbs[i])]]) * (input[[paste0("wt_", evalabbs[i])]] / 100)
#       
#     })
#     
#     names(pct_list) <- input$evals
#     
#     output$txt <- renderUI({
#       
#       a <- Reduce(f = "+", x = pct_list)
#       b <- Reduce(f = "+", x = reactiveValuesToList(wt_react)) / 100
#       c <- round(a/b, 2)
#       w <- Reduce(f = "+", x = reactiveValuesToList(wt_react))
#       
#       d <- lapply(input$evals, function(i){
#         HTML(paste0(i, ": "), pct_list[[i]], " /", wt_react[[i]], "<br/>")
#       })
#       
#       list(d, HTML("Total weights: ", paste0(w), "%", "<br/>", "<br/>", "Total grade: ", paste0(c))) %>% tagList
#       
#     })
#   })
# }
# 
# shinyApp(ui = ui, server = server)