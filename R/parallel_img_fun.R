
parallel_img_fun <- function(img, i){
  roi_file <- img[,,i]
  if(max(roi_file)==0){return(c("NA"))}else{

    threshold<- img_betamix(img = roi_file, min.intensity = min.intensity.vector[i], mixnum = 2, threshold.percentile = threshold.percentile)

    return(threshold)}
}
