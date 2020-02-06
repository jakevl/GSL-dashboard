# Initial setup

## Packages
library(dataRetrieval)
library(plotly)
library(flexdashboard)

## Colors list
cols=list(
	list('rgba(60, 230, 70, 0.5)','rgb(60, 230, 70)'),
	list('rgba(230, 200, 50, 0.5)','rgb(230, 200, 50)'),
	list('rgba(15, 32, 128, 0.5)','rgb(15, 32, 128)'),
	list('rgba(200, 30, 30, 0.5)','rgb(200, 30, 30)'),
	list('rgba(195, 30, 200, 0.5)','rgb(195, 30, 200)'),
	list('rgba(245, 121, 58, 0.5)','rgb(245, 121, 58)'),
	list('rgba(169, 90, 161, 0.5)','rgb(169, 90, 161)'),
	list('rgba(255,0,0,0.5)','rgb(255,0,0)'),
	list('rgba(255,165,0,0.5)','rgb(255,165,0)'),
	list('rgba(0,128,0,0.5)','rgb(0,128,0)')
	)

## Data imports

### Sites
site_list=read.csv(file="site_list.csv")

### Elevation
elevation=dataRetrieval::readNWISdv(siteNumbers=site_list$SiteNumber[site_list$SiteType=="Elevation gauge"],parameterCd="62614")
elevation=dplyr::rename(elevation, elev_ft=X_62614_00003)
elevation=merge(elevation, site_list, by.x='site_no', by.y='SiteNumber')

### Discharge (not performing currently)
#discharge=dataRetrieval::readNWISuv(siteNumbers=site_list$SiteNumber[site_list$SiteType=="Discharge gauge"],parameterCd="00060", tz="America/Denver", startDate = "2010-01-01", endDate = Sys.Date())
#discharge=dplyr::rename(discharge, discharge_cfs=X_00060_00000)


### Salinity
wq_data=dataRetrieval::readNWISqw(expanded=F,tz="America/Denver",startDate="01-01-2010", endDate=Sys.Date(),
		siteNumbers=site_list$SiteNumber[site_list$SiteType %in% c("Lake", "Lake, DBL", "Discharge gauge", "Causeway breach")],
		parameterCd=c(
			"00098",			
			"70305",
			"72263",
			"00095")
)

wq_data=dplyr::rename(wq_data,
	Sampling_depth_m=p00098,
	Salinity_gL=p70305,
	Density_gcm3=p72263,
	SpecCond_uScm=p00095)

wq_data=within(wq_data, {
	sal_pct=(((Density_gcm3-1)*1000)/0.63)/(Density_gcm3*10)
	rel_depth=NA
	rel_depth[Sampling_depth_m<=1]="Surface"
	rel_depth[Sampling_depth_m>=4]="Bottom"
	month=lubridate::month(sample_dt)
})


dim(wq_data)
wq_data=merge(wq_data, site_list, by.x='site_no', by.y='SiteNumber')
dim(wq_data)
	


