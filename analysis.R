library("ggplot2")
getwd()

avg_slope_diff__county__pct_lead__winner <- read.csv("output/avg_slope_diff__county__pct_lead__winner.csv")
attach(avg_slope_diff__county__pct_lead__winner)
hist(avg_slope_diff)
hist(pct_lead)
hist(winner)
qplot(pct_lead, avg_slope_diff)
#binning
tapply(pct_lead, cut(pct_lead, 200), FUN = function(x) length(x))
#original data with color
#sp <- qplot(avg_slope_diff,pct_lead,color=factor(winner))
#excludes outliers and colors
sp <- qplot(avg_slope_diff[abs(avg_slope_diff) < .01],pct_lead[abs(avg_slope_diff) < .01],color=factor(winner[abs(avg_slope_diff) < .01]))
sp_clinton <- qplot(avg_slope_diff[abs(avg_slope_diff) < .01 & winner=="Clinton"],pct_lead[abs(avg_slope_diff) < .01 & winner=="Clinton"],color=factor(winner[abs(avg_slope_diff) < .01 & winner=="Clinton"]))
sp_clinton + scale_color_manual(values=c("#0000FF", "#FF0000"))
sp + scale_color_manual(values=c("#0000FF", "#FF0000"))
cor()
t.test(slope_diff~winner)
detach(avg_slope_diff__county__pct_lead__winner)

#clinton data
avg_slope_diff__county__pct_lead__winner.clinton <- subset( avg_slope_diff__county__pct_lead__winner, winner == "Clinton" & abs(avg_slope_diff) < .01)
attach(avg_slope_diff__county__pct_lead__winner.clinton)
#original data with color
sp <- qplot(avg_slope_diff,pct_lead) 
sp + stat_smooth(color="blue") + geom_point() + xlab("Average Stock Slope Difference") + ylab("Clinton % Lead")
#calculate correlation
cor(pct_lead,avg_slope_diff)
summary(lm(avg_slope_diff~pct_lead))
detach(avg_slope_diff__county__pct_lead__winner.clinton)

#trump data
avg_slope_diff__county__pct_lead__winner.trump <- subset( avg_slope_diff__county__pct_lead__winner, winner == "Trump" & abs(avg_slope_diff) < .01)
attach(avg_slope_diff__county__pct_lead__winner.trump)
#original data with color
sp <- qplot(avg_slope_diff,pct_lead) 
#calculate correlation
sp + stat_smooth(color="red") + xlab("Average Stock Slope Difference") + ylab("Trump % Lead")
cor(avg_slope_diff,pct_lead)
summary(lm(avg_slope_diff~pct_lead))
detach(avg_slope_diff__county__pct_lead__winner.trump)

#excludes outliers
nrow(company_slope_diff_coords)
company_slope_diff_coords.clean <- subset( company_slope_diff_coords, abs(slope_diff) < .1)
attach(company_slope_diff_coords.clean)
#start with categorical box plot
#sector boxplot ordered by median
ggplot(company_slope_diff_coords.clean, aes(x = reorder(sector, slope_diff, FUN=median), y = slope_diff)) + geom_boxplot() + coord_flip() + ylab("Stock Slope Difference") + xlab("Company Sector")
detach(company_slope_diff_coords.clean)


results__fips <- read.csv("~/Google_Drive/Comp321/stock-election-db/output/results__fips.csv")
companies__slope__coords <- read.csv("~/Google_Drive/Comp321/stock-election-db/output/companies__slope__coords.csv")
#maps take 2
attach(results__fips)
library(choroplethrMaps)
#import state map data
library(maps)
#load us map data
all_states <- map_data("state")
#import county map data
data(county.map)
county <- county.map

county$fips <- county$region
nrow(county)
#before had all.x=TRUE param
Results <- merge(county,results__fips, by="fips", all.x=TRUE)
#Results <- merge(x = county, y = results__fips, by="fips")

#sort
Results <- Results[order(Results$order),]
#remove row nums
rownames(Results) <- NULL
#remove Alaska & Hawaii
Results<-Results[(Results$long > -130 & Results$lat > 23),]
#Results<-Results[(Results$STATE == "Connecticut"),]
rownames(Results) <- NULL
nrow(Results)
head(Results,100)
#graph
#plot all states with ggplot
p <- ggplot(data=Results)
p <- p + geom_polygon( data=all_states, aes(x=long, y=lat, group = group),color="grey", fill="#cccccc" )
p <- p + geom_polygon( aes(x=long, y=lat, group = group, fill=factor(Results$winner),alpha=Results$pct_lead))
#custom coloring

p <- p + scale_fill_manual(name="Election Results", values=c("#0000FF","#FF0000"))
#add in jittering so points don't overlap so much
p <- p + geom_point( data=companies__slope__coords, aes(x=longitude, y=latitude, size = abs(slope_diff), color = factor(slope_diff < 0 ), alpha=.4, shape = factor(slope_diff < 0 )), position = position_jitter(w = 0.5, h = 0.5))
p <- p + scale_size_continuous(name="Slope Diff")
#p <- p + scale_shape_manual(values=c(24,25))
p <- p + scale_color_manual(name="Slope Diff", values=c("green", "black")) 
p


detach(results__fips)
