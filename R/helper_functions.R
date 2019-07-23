make_read_only_cells <- function(hot, read_only_cells){
  
  # Restructure read-only cell indexes for use below
  read_only_cells_named <- 
    read_only_cells %>%
    map(~ .x - 1) %>%
    map(setNames, nm = c("row", "col"))
  
  # Make cells read-only
  hot$x$cell <- 
    read_only_cells_named %>%
    map(as.list) %>%
    map(~ c(.x, readOnly = TRUE))
  
  # Add row and column indexes of read-only cells to hot$x for use in the renderer
  read_only_df <- invoke(bind_rows, read_only_cells_named)
  
  hot$x <-
    list_modify(hot$x, 
                readonly_row_index = read_only_df$row, 
                readonly_col_index = read_only_df$col)
  
  hot %<>%
    hot_cols(renderer = "function(instance, td, row, col, prop, value, cellProperties){
          Handsontable.renderers.TextRenderer.apply(this, arguments);
          
          if(instance.params){
            
            // Indexes of read-only cells
            readonly_row_index = instance.params.readonly_row_index
            readonly_row_index = readonly_row_index instanceof Array ? readonly_row_index : [readonly_row_index]
            readonly_col_index = instance.params.readonly_col_index
            readonly_col_index = readonly_col_index instanceof Array ? readonly_col_index : [readonly_col_index]

            for(i = 0; i < readonly_col_index.length; i++){ 
	            if (readonly_col_index[i] == col && readonly_row_index[i] == row){
	                td.style.background = 'lightgrey';
	            } 
		        }
          }
          return td;
        }")
}


