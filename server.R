shinyServer(function(input, output, session){
    
    enabled <- reactiveValues(tab2 = FALSE)
    
    observe({
        if(enabled$tab2){
            removeCssClass(selector = "a[data-value = 'whatcha_need']", class = "inactiveLink")
        } else {
            addCssClass(selector = "a[data-value = 'whatcha_need']", class = "inactiveLink")
        }
    })
    
    # TAB ITEM: COMPUTE GRADE ---------------------------------------
    tab_compute_grade <- callModule(module = tab_compute_grade_module, id = "tab-compute-grade")
    
    observe({
        enabled$tab2 <- tab_compute_grade$total_grade$completed()
    })
    
    # TAB ITEM: WHATCHA NEED? ---------------------------------------
    tab_whatcha_need <- callModule(module = tab_whatcha_need_module, id = "tab-whatcha-need", tab_compute_grade = tab_compute_grade)
    

})
