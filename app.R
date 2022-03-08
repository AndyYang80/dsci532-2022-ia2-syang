library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(dplyr)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

olympic_data <- na.omit(readr::read_csv(here::here('data', 'olympics_data.csv')))
olympic_data$medal <- factor(olympic_data$medal, levels=c("Gold", "Silver","Bronze"))

app$layout(
  htmlDiv(
    list(
      dccGraph(id='height_hist'),
      dccRangeSlider(
        id='age_slider',
        min=0,
        max=75,
        step=1,
        value=list(0, 75)
      )
    )
  )
)

app$callback(
    output('height_hist', 'figure'),
    list(input('age_slider', 'value')),
    function(year_range) {
# 
        minage = year_range[1]
        maxage = year_range[2]
        plot_data <- filter(olympic_data, between(age, minage, maxage))

        p <- ggplot(plot_data) +
            geom_histogram(aes(x=age, fill=medal), bins=30) + 
            scale_fill_manual(values = c('#FFD700', '#C0C0C0', '#CD7F32')) +
            xlab("Age range") + 
            ylab("medals earned")
        ggplotly(p)
    }
)
# app$run_server(debug = T)
app$run_server(host = '0.0.0.0')
