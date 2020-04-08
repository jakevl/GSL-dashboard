# Breach

library(crosstalk)

breach_date_range=c(min(breach_data_wide$Date)-120, max(breach_data_wide$Date))
breach_flow_dates=data.frame(seq(min(breach_data_wide$Date)-120, max(breach_data_wide$Date), 1))
names(breach_flow_dates)='sample_dt'

## Calculate SA 120d moving average salinity
sa_sal=subset(wq_data, Bay=='Gilbert' & rel_depth=='Surface' & sample_dt>=breach_date_range[1] & sample_dt<=breach_date_range[2] & sal_pct>8)
sa_sal=aggregate(sal_pct~sample_dt, sa_sal, FUN='mean')
sa_sal=merge(sa_sal, breach_flow_dates, all.y=T)

sa_sal=within(sa_sal, {
	sa_sal_avg120d=caTools::runmean(sal_pct, 120, alg='C', endrule='constant')
})

sa_sal=subset(sa_sal, sample_dt>=breach_date_range[1])
#plot(sal_pct~sample_dt, sa_sal)
#points(sa_sal_avg120d~sample_dt, sa_sal, type='l')

## Calculate NA 120d moving average salinity
na_sal=subset(wq_data, site_no==10010100 & sample_dt>=breach_date_range[1] & sample_dt<=breach_date_range[2])
na_sal=aggregate(sal_pct~sample_dt, na_sal, FUN='mean')
na_sal=merge(na_sal, breach_flow_dates, all.y=T)

na_sal=within(na_sal, {
	na_sal_avg120d=caTools::runmean(sal_pct, 120, alg='C', endrule='constant')
})

na_sal=subset(na_sal, sample_dt>=breach_date_range[1])
#plot(sal_pct~sample_dt, na_sal)
#points(na_sal_avg120d~sample_dt, na_sal, type='l')


## Join SA & NA 120d salinities to discharge data
breach_data_wide$cumsum=cumsum(breach_data_wide$Net)
breach_data_wide=merge(breach_data_wide, na_sal[,c('sample_dt', 'na_sal_avg120d')], by.x='Date', by.y='sample_dt')
breach_data_wide=merge(breach_data_wide, sa_sal[,c('sample_dt', 'sa_sal_avg120d')], by.x='Date', by.y='sample_dt')
breach_data_wide=within(breach_data_wide, {
	


})


share_df=highlight_key(breach_data_wide)
breach_disch_ts=plot_ly(data=share_df, x=~Date) %>%
	add_markers(y=~Net)  %>%
	#add_markers(y=~`N to S`)  %>%
	#add_markers(y=~`S to N`)# %>%
	#highlight(on = "plotly_selected", dynamic = TRUE)
	highlight(
		on = "plotly_selected",
		off = "plotly_deselect",
		dynamic = FALSE, 
		selectize = FALSE, 
		selected = attrs_selected(opacity = 0.8)
	) %>%
	layout(
		xaxis = list(title = ""),
		yaxis = list(title = 'Daily mean net discharge (cfs, S to N)')
	) %>% 
	config(displaylogo = FALSE,
		modeBarButtonsToRemove = c(
			'sendDataToCloud',
			'hoverClosestCartesian',
			'hoverCompareCartesian'
		)
	)


breach_disch_hist=plot_ly(data=share_df, x=~Net, type='histogram') %>% layout(barmode = "overlay", showlegend = FALSE) %>%
	layout(
		yaxis = list(title = "Frequency"),
		xaxis = list(title = 'Daily mean net discharge (cfs, S to N)')
	) %>% 
	config(displaylogo = FALSE,
		modeBarButtonsToRemove = c(
			'sendDataToCloud',
			'hoverClosestCartesian',
			'hoverCompareCartesian'
		)
	)





#bscols(breach_disch_ts, breach_disch_hist)

