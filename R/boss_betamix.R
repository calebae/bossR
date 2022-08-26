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
boss_betamix <- function(img, min.intensity, mix.num, threshold.percentile = 0.8){

  x.nifti <- img
  x<-as.vector(x.nifti)

  x<-x[x>min.intensity]
  original.scale.x <- range(x)

  threshold <- quantile(x, threshold.percentile)

  x <- scales::rescale(x, to = c(0.0001,0.9999), from = range(x))

  x.beta <- data.frame(y = x)
  m <- betamix(y ~ 1, data = x.beta, k = 1:mix.num)


  if(length(unique(clusters(m)))>1){

    mu <- plogis(coef(m)[,1])
    phi <- exp(coef(m)[,2])

    a <- mu * phi
    b <- (1 - mu) * phi
    cl <- clusters(m)

    ys <- seq(0, 1, by = 0.01)


    if(mu[1]>mu[2]){
      density.difference = dbeta(ys, shape1 = a[1], shape2 = b[1]) -
        dbeta(ys, shape1 = a[2], shape2 = b[2])}else{
          density.difference = dbeta(ys, shape1 = a[2], shape2 = b[2]) -
            dbeta(ys, shape1 = a[1], shape2 = b[1])
        }

    intersection.point <- (which(diff(density.difference > 0) != 0) + 1)
    if(any(intersection.point>=100)){
      intersection.point <- intersection.point[-which(intersection.point>=100)]}

    for(i in 1:length(intersection.point)){
      if(density.difference[intersection.point[i]+1] - density.difference[intersection.point[i]-1]>0){
        before.threshold <- ys[intersection.point[i]]
      }
    }
    threshold <- scales::rescale(before.threshold, to = original.scale.x, from = c(0.0001,0.9999))
  }

  return(threshold)
}
