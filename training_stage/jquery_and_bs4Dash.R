library(shiny)
library(bs4Dash)
library(shinyjs)
library(magrittr)

buttonList <- tagList(
  actionButton(inputId = "button1", label = "Show Card 1"),
  actionButton(inputId = "button2", label = "Show Card 2"),
  actionButton(inputId = "button3", label = "Show Card 3")
)

body <- bs4DashBody(
  
  useShinyjs(),
  
  tags$head(
    tags$script(
      "$(function(){
        var cards = $('.card');
        cards.each(function(e){
         $(cards[e]).attr('id', e);
         // hide the newly created id
         $('#' + e).hide();
        });
      });
      "
    )
  ),
  
  fluidRow(
    bs4Card(title = "Card 1", width = 4),
    bs4Card("card2", title = "Card 2", width = 4),
    bs4Card("card3", title = "Card 3", width = 4)
  ),
  
  buttonList
)

shiny::shinyApp(
  
  ui = bs4DashPage(
    old_school = FALSE,
    sidebar_collapsed = FALSE,
    controlbar_collapsed = FALSE,
    title = "Basic Dashboard",
    navbar = bs4DashNavbar(),
    sidebar = bs4DashSidebar(),
    controlbar = bs4DashControlbar(),
    footer = bs4DashFooter(),
    body = body
  ),
  
  server = function(input, output, session ){
    lapply(seq_along(buttonList), function(i) {
      observeEvent(input[[buttonList[[i]]$attribs$id]], {
        print("Pouet")
        shinyjs::toggle(selector = paste0("#", i - 1))
      })
    })
  }
)