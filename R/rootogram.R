



prepanel.rootogram <-
    function(x, y = table(x),
             dfun = NULL,
             transformation = sqrt,
             hang = TRUE,
             ...)
{
    plot.line <- trellis.par.get("plot.line")
    stopifnot(is.function(dfun))
    yy <- transformation(y / sum(y))
    xx <- sort(unique(x))
    dotArgs <- list(...)
    dfunArgs <- names(formals(dfun))
    if (!("..." %in% dfunArgs))
        dotArgs <- dotArgs[dfunArgs[-1]]
    dd <- transformation(do.call(dfun, c(list(xx), dotArgs)))
    list(xlim = range(xx),
         ylim =
         if (hang) range(dd, dd-yy, 0)
         else range(dd, yy, 0),
         dx = diff(xx),
         dy = diff(dd))
}


panel.rootogram <-
    function(x, y = table(x),
             dfun = NULL,
             col = plot.line$col,
             lty = plot.line$lty,
             lwd = plot.line$lwd,
             alpha = plot.line$alpha,
             transformation = sqrt,
             hang = TRUE,
             ...)
{
    plot.line <- trellis.par.get("plot.line")
    ref.line <- trellis.par.get("reference.line")
    stopifnot(is.function(dfun))
    yy <- transformation(y / sum(y))
    xx <- sort(unique(x))
    dotArgs <- list(...)
    dfunArgs <- names(formals(dfun))
    if (!("..." %in% dfunArgs))
        dotArgs <- dotArgs[dfunArgs[-1]]
    dd <- transformation(do.call(dfun, c(list(xx), dotArgs)))
    panel.abline(h = 0,
                 col = ref.line$col,
                 lty = ref.line$lty,
                 lwd = ref.line$lwd,
                 alpha = ref.line$alpha)
    panel.segments(xx,
                   if (hang) dd else 0,
                   xx,
                   if (hang) (dd - yy) else yy,
                   col = col,
                   lty = lty,
                   lwd = lwd,
                   alpha = alpha,
                   ...)
    panel.lines(xx, dd)
}


rootogram <-
    function(x, ...)
    UseMethod("rootogram")





rootogram.formula <-
    function(x, data = parent.frame(),
             ylab = expression(sqrt(P(X == x))),
             prepanel = prepanel.rootogram,
             panel = panel.rootogram,
             ...)
{
    if (length(x) == 2) ## formula like ~ x
        densityplot(x, data,
                    prepanel = prepanel,
                    panel = panel,
                    ylab = ylab,
                    ...)
    else ## formula like y ~ x 
        xyplot(x, data,
               prepanel = prepanel,
               panel = panel,
               ylab = ylab,
               ...)
}
