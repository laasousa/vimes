
## This file contains functions which are not exported. The API may
## change, so use ::: at your own risk.


## This function will get a set of graphical settings defined in a
## named list (typically returned by vimes.graph.opt) and use them to
## store new graphical options in a igraph object.

set.igraph.opt <- function(g, opt){
    ## check class
    if(!inherits(g, "igraph")) stop("g is not a igraph object")

    ## find clusters ##
    groups <- clusters(g)

    ## layout ##
    set.seed(opt$seed)
    g$layout <- opt$layout(g)

    ## vertices ##
    groups$color <- rep("lightgrey", groups$no) # groups of size 1 are grey
    groups$color[groups$csize>1] <- opt$col.pal(sum(groups$csize>1))
    V(g)$color <- groups$color[groups$membership]

    ## size
    V(g)$size <- opt$vertex.size

    ## font
    V(g)$label.family <- opt$label.family

    ## font color
    V(g)$label.color <- opt$label.color

    ##  edges ##
    ## labels
    if(length(E(g))>0 && opt$edge.label) {
        E(g)$label <- E(g)$weight
    }

    ## color
    E(g)$label.color <-  opt$label.color

    ## font
    ##    E(g)$label.family <- "sans" # bugs for some reason

    return(g)
}




## This has been written by Rich Fitzjohn. This function will modify a
## list with default values using a list of new values. Trying to add
## items not defined as default will trigger an error.

modify.defaults <- function(defaults, x){
    extra <- setdiff(names(x), names(defaults))
    if (length(extra) > 0L){
        stop("Additional invalid options: ", paste(extra, collapse=", "))
    }
    modifyList(defaults, x)
} # end modify.defaults