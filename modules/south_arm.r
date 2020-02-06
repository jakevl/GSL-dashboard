# South arm (Gilbert Bay) board

## Gauges
gauge_date_range=c(Sys.Date()-60, Sys.Date())

### Elevation
#### Gauge
current_sa_elev=subset(elevation, site_no=='10010000' & Date==max(Date))$elev_ft
elev_min=min(subset(elevation, site_no=='10010000')$elev_ft)
elev_max=max(subset(elevation, site_no=='10010000')$elev_ft)
elev_mean=mean(subset(elevation, site_no=='10010000')$elev_ft)

sa_elev_gauge=gauge(current_sa_elev, min=elev_min, max=elev_max, abbreviate=F, symbol = ' ft',
	sectors=gaugeSectors(
		success=c(4198,4206),
		warning=c(4196,4208),
		danger=c(elev_min, elev_max)
	)
)

#### Time series
sa_elev_ts=
	plot_ly(subset(elevation, site_no=='10010000'), x=~Date) %>%
		add_lines(y=~elev_ft, x=~Date, name=~Bay) %>%
		layout(title = "South arm elevation",
			xaxis = list(title = "", range=c(as.numeric(gauge_date_range[2]-365*20)*86400000,as.numeric(gauge_date_range[2])*86400000), rangeslider = list(type = "date")),
			yaxis = list(title = 'WSE (feet)')
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







### Salinity
#### Gauge
current_sa_sal=mean(subset(wq_data, Bay=='Gilbert' & rel_depth=='Surface' & sample_dt>=gauge_date_range[1] & sample_dt<=gauge_date_range[2])$sal_pct)
sal_min=min(subset(wq_data, Bay=='Gilbert' & Sampling_depth_m<=2)$sal_pct, na.rm=T)
sal_max=max(subset(wq_data, Bay=='Gilbert' & Sampling_depth_m<=2)$sal_pct, na.rm=T)

sa_sal_gauge=gauge(round(current_sa_sal,1), min=round(sal_min,1), max=round(sal_max,1), abbreviate=F, symbol = '%',
	sectors=gaugeSectors(
		success=c(10,16),
		warning=c(8,18),
		danger=c(round(sal_min,1), round(sal_max,1))
	)
)

#### Time series
sa_sal_ts=
	plot_ly(x=~sample_dt) %>%
		add_markers(data=wq_data[wq_data$rel_depth=="Bottom" & wq_data$Bay=="Gilbert",], x=~sample_dt, y=~sal_pct, name="Bottom", visible=T,
			text=~site_no,
			marker = list(color = cols[[3]][[1]],size = 10,line = list(color = cols[[3]][[2]],width = 2))
		) %>% 
		add_markers(data=wq_data[wq_data$rel_depth=="Surface" & wq_data$Bay=="Gilbert",], x=~sample_dt, y=~sal_pct, name="Surface", visible=T, 
			text=~site_no,
			marker = list(symbol=2, color = cols[[6]][[1]],size = 10,line = list(color = cols[[6]][[2]],width = 2))
		) %>%

		layout(title = "South Arm salinity",
			xaxis = list(title = "", range=c(as.numeric(gauge_date_range[2]-365)*86400000,as.numeric(gauge_date_range[2])*86400000), rangeslider = list(type = "date")),
			yaxis = list(side = 'left', title = 'Salinity (%)')
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

	






## Plotly gauge option
#plot_ly(
#  domain = list(x = c(0, 1), y = c(0, 1)),
#  value = current_sa_elev,
#  title = list(text = "Elevation"),
#  type = "indicator",
#  mode = "gauge+number+delta",
#  delta = list(reference = elev_mean),
#  gauge = list(
#	bar = list(color = "darkgray"),
#    axis =list(range = list(elev_min, elev_max)),
#    steps = list(
#      list(range = c(elev_min, elev_max), color = cols[[10]][[1]]),
#      list(range = c(4196, 4208), color = cols[[9]][[1]]),
#      list(range = c(4198, 4206), color = cols[[8]][[1]])
#	 )
#  ))%>%
#  layout(margin = list(l=20,r=30))
#


