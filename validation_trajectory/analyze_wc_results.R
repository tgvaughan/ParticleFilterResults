#library(BSLoader)
#load.beast.scripts("EpiInf")
source("~/code/beast_and_friends/EpiInf/scripts/plotTraj.R")

getInfectedsAtTime <- function(trajectories, t, t_origin) {
    ntraj <- length(trajectories)

    res <- rep(0, ntraj)

    for (i in seq(1, ntraj)) {
        indices <- which(t_origin - trajectories[[i]]$t < t)
        if (length(indices)>0)
            res[i] <- trajectories[[i]]$I[max(indices)]
        else
            res[i] <- 1
    }

    return(res)
}

getHPD <- function(samples, alpha=0.95) {

    n <- length(samples)
    sorted <- sort(samples)

    lower <- sorted[1]
    upper <- sorted[n]
    width <- upper - lower
    
    sample_interval <- round(n*alpha)
    for (i in 1:length(samples)) {
        if (i+sample_interval>n)
            break

        thisLower <- sorted[i]
        thisUpper <- sorted[i+sample_interval]
        thisWidth <- thisUpper - thisLower

        if (thisWidth < width) {
            width <- thisWidth
            lower <- thisLower
            upper <- thisUpper
        }
    }

    ## This is the actual fraction of samples that fall within the
    ## range of values between lower and upper. For discrete values,
    ## this can be larger than alpha.
    
    trueAlpha <- (max(which(sorted==upper)) - min(which(sorted==lower)) + 1)/n

    return(list(lower=lower, upper=upper, trueAlpha=trueAlpha))
}

processResults <- function(filePrefix, seeds, t_origin) {

    i <- 0
    times <- NULL
    alphas <- NULL
    lowers <- NULL
    uppers <- NULL
    truths <- NULL
    analysisIndices <- NULL
    models <- NULL

    for (analysisIdx in seeds) {
        cat(paste0("Processing analysis ", filePrefix, ".", analysisIdx, "..."))

        data <- loadData(paste0("results/", filePrefix, ".", analysisIdx, ".traj"))
        trajectories <- parseTrajectories(data)
        trueTraj <- read.table(paste0("results/", filePrefix, ".",
                                      analysisIdx, ".truth.traj"),
                               header=T)
        

        for (t in seq(0.1, t_origin, length.out=10)) {

            ## Compute HPD of prevalence at time point.
            infectedDist <- getInfectedsAtTime(trajectories, t, t_origin)

            ## Determine whether HPD interval includes truth for this analysis.
            truth <- trueTraj$I[max(which(trueTraj$t<t))]

            for (alpha in seq(0.05, 0.95, by=0.05)) {
                hpd <- getHPD(infectedDist, alpha)

                times[i] <- t
                alphas[i] <- hpd$trueAlpha
                lowers[i] <- hpd$lower
                uppers[i] <- hpd$upper
                truths[i] <- truth
                analysisIndices[i] <- analysisIdx
                i <- i + 1
            }
        }
        cat("done!\n")
    }

    return(data.frame(time=times,
                      alpha=alphas,
                      lower=lowers,
                      upper=uppers,
                      truth=truths,
                      analysis=analysisIndices))
}


modelNames <- c("BD", "SIR", "SIS")

## Birth-death
resultsBD <- processResults("BD_psiSamp_Inference", 1:200, 10)
resultsSIR <- processResults("SIR_psiSamp_Inference", 1:200, 5)
resultsSIS <- processResults("SIS_psiSamp_Inference", 1:200, 5)

write.table(resultsBD, "resultsBD.txt")
write.table(resultsSIS, "resultsSIS.txt")
write.table(resultsSIR, "resultsSIR.txt")
