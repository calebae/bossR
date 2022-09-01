
boss_filtering <- function(img, filtering_kernel = c(10,10,3), filtering_type = "diamond", verbose = TRUE){

  if (verbose) {
    messsage("# Running a Median Filtering Algorithm")
  }
  k <- shapeKernel(filtering_kernel, type=filtering_type)
  filtered_img <- mmand::medianFilter(img, k)

    return(filtered_img)
}
