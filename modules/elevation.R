# Elevation
## Gauges
elev_summ=dplyr::summarize(elevation, elev_min=round(min(elev_ft),1), elev_max=round(max(elev_ft),1), elev_mean=round(mean(elev_ft),1))

current_sa_elev=subset(elevation, site_no=='10010000' & Date==max(Date))$elev_ft
sa_elev_gauge=gauge(current_sa_elev, min=elev_summ$elev_min, max=elev_summ$elev_max, abbreviate=F, symbol = ' ft',
	sectors=gaugeSectors(
		colors=gauge_cols,
		success=c(4198,4206),
		warning=c(4196,4208),
		danger=c(elev_summ$elev_min, elev_summ$elev_max)
	)
)


current_na_elev=subset(elevation, site_no=='10010100' & Date==max(Date))$elev_ft

na_elev_gauge=gauge(current_na_elev, min=elev_summ$elev_min, max=elev_summ$elev_max, abbreviate=F, symbol = ' ft',
	sectors=gaugeSectors(
		colors=gauge_cols,
		success=c(4198,4206),
		warning=c(4196,4208),
		danger=c(elev_summ$elev_min, elev_summ$elev_max)
	)
)





#### Time series
elev_ts=
	plot_ly(elevation, x=~Date) %>%
		add_lines(y=~elev_ft, x=~Date, name=~Bay) %>%
		layout(title = "Lake elevation",
			xaxis = list(title = "", range=c(as.numeric(gauge_date_range[2]-365*20)*86400000,as.numeric(gauge_date_range[2])*86400000), rangeslider = list(type = "date")),
			yaxis = list(title = 'WSE (feet)'),
			legend = list(x = 0.01, y = 0.1)
		) %>% 
		config(displaylogo = FALSE,
			modeBarButtonsToRemove = c(
				'sendDataToCloud',
				'hoverClosestCartesian',
				'hoverCompareCartesian',
				'lasso2d',
				'select2d'
			)
		)



