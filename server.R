shinyServer(function(input, output, session){
    
    # TAB ITEM: COMPUTE GRADE ---------------------------------------
    tab_compute_grade <- callModule(module = tab_compute_grade_module, id = "tab-compute-grade")
    
    # TAB ITEM: WHATCHA NEED? ---------------------------------------
    tab_whatcha_need <- callModule(module = tab_whatcha_need_module, id = "tab-whatcha-need", tab_compute_grade = tab_compute_grade)
    
})
