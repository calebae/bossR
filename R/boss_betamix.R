#' Obtain intersection value to binarize the image into background and ROI
#'
#' @param img Image to be binarized
#' @param min.intensity Minimum intensity value to be considered to be ROI
#' @param mix.num Number of the clusters to be considered in mixture model.
#' @param threshold.percentile Thresholding value if the mixture model is failed to be recognized.
#'
#' @return Thresholding value
#' @export
#' @examples
#' boss_betamix(img, 0.8, 2)
#'
boss_betamix <- function(img, maxZ = NULL, min.intensity.percentile = 0.98, mix.num = 2, threshold.percentile = 0.8,
                cores = 1, verbose = TRUE, retimg = TRUE){

  if (verbose) {
    messsage("# Loading data...")
  }


  if (verbose) {
  messsage("# Running Intensity Modeling Algorithm")
  }


  min.intensity.vector <- apply(img, 3, quantile, probs = min.intensity.percentile)
  if(is.null(maxZ)){
    threshold <- mclapply(1:dim(img)[3], parallel_img_fun, img = img, mc.cores = cores)
    threshold.value <- unlist(threshold)
    if (verbose) {
      messsage("# Binarizing the ROI and background")
    }
    roi.img <- array(NA, dim = dim(img))

    for(i in 1:dim(img)[3]){
      roi_file <- img[,,i]

      is_roi <- (roi_file >= threshold.value[i])

      is_roi[which(is_roi==0)] <- NA
      roi.img[,,i] <- is_roi
    }

  }else{
    threshold <- mclapply(1:maxZ, parallel_img_fun, img = img, mc.cores = cores)
    threshold.value <- unlist(threshold)
    if (verbose) {
      messsage("# Binarizing the ROI and background")
    }
    roi.img <- array(NA, dim = c(dim(img)[1:2],maxZ))

    for(i in 1:maxZ){
      roi_file <- img[,,i]

      is_roi <- (roi_file >= threshold.value[i])

      is_roi[which(is_roi==0)] <- NA
      roi.img[,,i] <- is_roi
    }
  }

  roi.img[which(roi.img==1)] <- 1
  roi.img[which(is.na(roi.img))] <- 0

    return(roi.img)

}
