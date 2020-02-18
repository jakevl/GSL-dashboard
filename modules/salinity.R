# Salinity

## Gauges
sal_min=min(min(subset(wq_data, Bay=='Gilbert' & Sampling_depth_m<=2)$sal_pct, na.rm=T),min(subset(wq_data, site_no==10010100)$sal_pct, na.rm=T))
sal_max=max(max(subset(wq_data, Bay=='Gilbert' & Sampling_depth_m<=2)$sal_pct, na.rm=T),max(subset(wq_data, site_no==10010100)$sal_pct, na.rm=T))

current_sa_sal=mean(subset(wq_data, Bay=='Gilbert' & rel_depth=='Surface' & sample_dt>=gauge_date_range[1] & sample_dt<=gauge_date_range[2])$sal_pct, na.rm=T)

sa_sal_gauge=gauge(round(current_sa_sal,1), min=round(sal_min,1), max=round(sal_max,1), abbreviate=F, symbol = '%', label='Gilbert Bay salinity',
	sectors=gaugeSectors(
		colors=gauge_cols,
		success=c(10,16),
		warning=c(8,18),
		danger=c(round(sal_min,1), round(sal_max,1))
	)
)

current_na_sal=mean(subset(wq_data, site_no==10010100 & sample_dt>=gauge_date_range[1] & sample_dt<=gauge_date_range[2])$sal_pct, na.rm=T)

na_sal_gauge=gauge(round(current_na_sal,1), min=round(sal_min,1), max=round(sal_max,1), abbreviate=F, symbol = '%', label='Gunnison Bay salinity',
	sectors=gaugeSectors(
		colors=gauge_cols,
		success=c(10,16),
		warning=c(8,18),
		danger=c(round(sal_min,1), round(sal_max,1))
	)
)


## Time series
sal_ts=
	plot_ly(x=~sample_dt) %>%
		add_markers(data=wq_data[wq_data$rel_depth=="Bottom" & wq_data$Bay=="Gilbert",], x=~sample_dt, y=~sal_pct, name="Gilbert bottom", visible=T,
			text=~site_no,
			marker = list(color = cols[[5]][[1]],size = 10,line = list(color = cols[[5]][[2]],width = 2))
		) %>% 
		add_markers(data=wq_data[wq_data$rel_depth=="Surface" & wq_data$Bay=="Gilbert",], x=~sample_dt, y=~sal_pct, name="Gilbert surface", visible=T, 
			text=~site_no,
			marker = list(symbol=2, color = cols[[2]][[1]],size = 10,line = list(color = cols[[2]][[2]],width = 2))
		) %>%
		add_markers(data=subset(wq_data, site_no==10010100), x=~sample_dt, y=~sal_pct, name="Gunnison", visible=T, 
			text=~site_no,
			marker = list(symbol=3, color = cols[[4]][[1]],size = 10,line = list(color = cols[[4]][[2]],width = 2))
		) %>%
		layout(
			xaxis = list(title = ""),
			yaxis = list(side = 'left', title = 'Salinity (%)'),
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

