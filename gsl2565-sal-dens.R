

dens_plot=plot_ly(data=test2, x=~sample_dt) %>%
	add_trace(type='scatter', y=~Density_gcm3, mode = 'markers', marker = list(color = cols[[5]][[1]],size = 10,line = list(color = cols[[5]][[2]],width = 2))) %>%
	layout(
		autosize = T,
		title="GSL 2565",
		xaxis = list(title = "", range=c(as.numeric(gauge_date_range[2]-365*10)*86400000,as.numeric(gauge_date_range[2])*86400000)),
		yaxis = list(side = 'left', title = 'Density (g/cm3)')
	)
sal_plot=plot_ly(data=test2, x=~sample_dt) %>%
	add_trace(type='scatter', y=~Salinity_gL, mode = 'markers', marker = list(symbol=2, color = cols[[2]][[1]],size = 10,line = list(color = cols[[2]][[2]],width = 2))) %>%
	layout(
		autosize = T,
		title="GSL 2565",
		xaxis = list(title = "", range=c(as.numeric(gauge_date_range[2]-365*10)*86400000,as.numeric(gauge_date_range[2])*86400000)),
		yaxis = list(side = 'left', title = 'Salinity (g/L)')
	)

rows=crosstalk::bscols(widths=c(12,12), dens_plot, sal_plot)
rows
htmltools::save_html(file="GSL_2565_dens_sal.html", rows)




