# Initial setup

## Packages
library(dataRetrieval)
library(plotly)
library(flexdashboard)

## 120 day date range
gauge_date_range=c(Sys.Date()-120, Sys.Date())

## Colors list
cols=list(
	list('rgba(200, 30, 30, 0.5)','rgb(200, 30, 30)'),      #red 1
	list('rgba(245, 121, 58, 0.5)','rgb(245, 121, 58)'),    #orange 2
	list('rgba(230, 200, 50, 0.5)','rgb(230, 200, 50)'),    #yellow 3
	list('rgba(60, 230, 70, 0.5)','rgb(60, 230, 70)'),      #green 4
	list('rgba(15, 32, 128, 0.5)','rgb(15, 32, 128)'),      #blue 5
	list('rgba(169, 90, 161, 0.5)','rgb(169, 90, 161)')    #purple 6
	)


gauge_cols=c(cols[[4]][[2]],cols[[2]][[2]],cols[[1]][[2]])

## Data imports

### Sites
site_list=read.csv(file="site_list.csv")

### Elevation
elevation=dataRetrieval::readNWISdv(siteNumbers=site_list$SiteNumber[site_list$SiteType=="Elevation gauge"],parameterCd="62614")
elevation=dplyr::rename(elevation, elev_ft=X_62614_00003)
elevation=merge(elevation, site_list, by.x='site_no', by.y='SiteNumber')


### Breach discharge
breach_data=dataRetrieval::readNWISuv(siteNumbers=subset(site_list, SiteType=="Causeway breach")$SiteNumber, parameterCd="00060", tz="America/Denver", startDate = "2010-01-01", endDate = Sys.Date())
breach_data=dplyr::rename(breach_data, discharge_cfs=X_00060_00000)


### Discharge (not performing currently)
#discharge=dataRetrieval::readNWISuv(siteNumbers=site_list$SiteNumber[site_list$SiteType=="Discharge gauge"],parameterCd="00060", tz="America/Denver", startDate = "2010-01-01", endDate = Sys.Date())
#discharge=dplyr::rename(discharge, discharge_cfs=X_00060_00000)


### Salinity (water quality) - Gilbert
wq_data=dataRetrieval::readNWISqw(expanded=F,tz="America/Denver",startDate="01-01-2010", endDate=Sys.Date(),
		siteNumbers=site_list$SiteNumber[site_list$SiteType %in% c("Lake", "Lake, DBL", "Discharge gauge", "Causeway breach","Elevation gauge")],
		parameterCd=c(
			"00098",			
			"70305",
			"72263",
			"00095",
			"72012",
			"72013")
)

wq_data=dplyr::rename(wq_data,
	Sampling_depth_m=p00098,
	Salinity_gL=p70305,
	Density_gcm3=p72263,
	SpecCond_uScm=p00095,
	SG=p72013,
	SG_temp=p72012)

wq_data=within(wq_data, {
	sg_20c=SG/((SG_temp-20)*0.0002+1)
	sal_pct=(((Density_gcm3-1)*1000)/0.63)/(Density_gcm3*10)
	sal_pct=ifelse(is.na(sal_pct) & site_no=='10010100', (((sg_20c-1)*1000)/0.63)/(sg_20c*10), sal_pct)
	rel_depth=NA
	rel_depth[Sampling_depth_m<=1]="Surface"
	rel_depth[Sampling_depth_m>=4]="Bottom"
	month=lubridate::month(sample_dt)
})

wq_data=merge(wq_data, site_list, by.x='site_no', by.y='SiteNumber')

