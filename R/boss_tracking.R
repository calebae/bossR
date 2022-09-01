
boss_tracking <- function(img, output_directory, maxZ, maxT, tracking_kernel = c(21, 21, 3, 3), tracking_type = "box",
                          post_processing = TRUE, min.size = NULL, verbose = TRUE, retimg = TRUE){

  if (verbose) {
    messsage("# Running a Connecting Component Algorithm")
  }

  k <- shapeKernel(tracking_kernel, type=tracking_type)
  my.roi.all <- mmand::components(img, k)

  roi.array.final1 <- c()
  final.index <- c()
  for(k in 1:maxT){
    if(k <maxT){
      for(i in 1:maxZ){
        index <- unique(as.vector(my.roi.all[,,i,k]))
        index.next <- unique(as.vector(my.roi.all[,,i,k+1]))
        #index.next.next <- unique(as.vector(my.roi[,,i+2]))
        for(j in index){
          if(j %in% index.next){
            final.index <- c(final.index, j)
          }else{
            final.index <- final.index
          }
        }
      }
    }else{
      for(i in 1:maxZ){
        index <- unique(as.vector(my.roi.all[,,i,k]))
        final.index <- c(final.index, index)
      }
    }
  }

  final.index <- unique(final.index)
  unique.value <- final.index[-1]



  tracking.table <- c()
  roi.array.final4 <- c()

  for(k in 1:maxT){
    l = 1:maxZ
    final.index2 <- unique(as.vector(my.roi.all[,,l,k]))[unique(as.vector(my.roi.all[,,l,k])) %in% unique.value]


    my.roi <- my.roi.all[,,l,k]

    final.index1 <- c()

    for(i in 1:(length(l)-1)){
      index <- unique(as.vector(my.roi[,,i]))
      index.next <- unique(as.vector(my.roi[,,i+1]))
      for(j in index){
        if(j %in% index.next){
          final.index1 <- c(final.index1, j)
        }else{
          final.index1 <- final.index1
        }
      }
    }


    final.index1 <- unique(final.index1)

    final.index <- final.index1[final.index1 %in% final.index2]


    size <- rep(0, length(final.index))
    index.x <- rep(0, length(final.index))
    index.y <- rep(0, length(final.index))
    index.z <- rep(0, length(final.index))

    for(i in 1:length(final.index)){
      size[i] <- length(which(my.roi==final.index[i]))
      index.xyz <- which(my.roi==final.index[i],arr.ind = TRUE)
      xyz <- apply(index.xyz, 2, mean)
      index.x[i] <- xyz[1]
      index.y[i] <- xyz[2]
      index.z[i] <- xyz[3]
    }

    my.roi.table <- data.frame(index = final.index, size = size, X = index.x, Y = index.y, Z = index.z, T = k)
    my.roi.table <- my.roi.table[my.roi.table$size>min.size,]

    roi.array <- c()
    roi.array <- cbind(my.roi.table[,1],k)
    roi.array.final1 <- rbind(roi.array.final1, roi.array)

    tracking.table <- bind_rows(tracking.table, my.roi.table)

  }

  addition_table <- c()
  deletion_table <- c()
  roi.array.final4 <- as.data.frame(roi.array.final1)

  for(j in 1:(maxT-1)){
    roi.j <- roi.array.final4 %>% filter(k== j)
    roi.j1 <- roi.array.final4 %>% filter(k == j+1)

    addition_table[j] <- length(roi.j1$V1) - sum(roi.j1$V1 %in% roi.j$V1)
    deletion_table[j] <- length(roi.j$V1) - sum(roi.j$V1 %in% roi.j1$V1)
  }

  write.csv(tracking.table, file = paste0(output_directory, "tracking_table.csv"))
  write.csv(addition_table, file = paste0(output_directory, "addition_table.csv"))
  write.csv(deletion_table, file = paste0(output_directory, "deletion_table.csv"))

}





### Post-processing 있는지 확인
