library(reshape2)

set.seed(12345)

Pathcsv = "C://Users//karlb//Documents//SASUniversityEdition//myfolders//Predict Future Sales//"
# Pathcsv = "C://Users//Win10//Documents//SASUniversityEdition//myfolders//Predict Future Sales//" # Intel NUK

csvfile = paste(Pathcsv, "sales_train.csv", sep="")
df_sales = read.csv2(csvfile, sep=",", header=TRUE, dec=".", stringsAsFactors=TRUE)

csvfile = paste(Pathcsv, "items.csv", sep="")
df_items = read.csv2(csvfile, sep=",", header=TRUE, dec=".", stringsAsFactors=TRUE)

#csvfile = paste(Pathcsv, "item_categories.csv", sep="")
#df_itemcats = read.csv2(csvfile, sep=",", header=TRUE, dec=".", stringsAsFactors=TRUE)

#csvfile = paste(Pathcsv, "shops.csv", sep="")
#df_shops = read.csv2(csvfile, sep=",", header=TRUE, dec=".", stringsAsFactors=TRUE)

csvfile = paste(Pathcsv, "sample_submission.csv", sep="")
df_submit = read.csv2(csvfile, sep=",", header=TRUE, dec=".", stringsAsFactors=TRUE)

csvfile = paste(Pathcsv, "test.csv", sep="")
df_test = read.csv2(csvfile, sep=",", header=TRUE, dec=".", stringsAsFactors=TRUE)

# Additional Features
df_sales2 = merge(df_sales, df_items[2:3], by="item_id")  # merge item_cat
df_sales2$year  = substring(as.character(df_sales2$date), 7, 10)
df_sales2$month = paste(substring(as.character(df_sales2$date), 7, 10), substring(as.character(df_sales2$date), 4, 5), sep="-")
df_sales2$day   = paste(df_sales2$month, substring(as.character(df_sales2$date), 1, 2), sep="-")
df_sales2$shopitem_id = paste(as.character(df_sales2$shop_id), as.character(df_sales2$item_id), sep="-")

# Vorherzusagende Shop-Item-Kombis
test_shopitems = unique(paste(as.character(df_test$shop_id), as.character(df_test$item_id), sep="-"))

# Nur die Shop-Item-Kombis aus Test
df_sales2 = subset(df_sales2, subset=(shopitem_id %in% test_shopitems))
# Sortieren...
df_sales3 = df_sales2[order(df_sales2$shop_id, df_sales2$item_id, df_sales2$day), ]
colnames(df_sales3)[3] = "month_nr"

# Summe item_cnt group by month, shop, item
df_sales4 = aggregate(data.frame(df_sales3$item_cnt_day), by=data.frame(df_sales3$shop_id, df_sales3$item_id, df_sales3$month_nr), sum, na.rm=TRUE)
colnames(df_sales4) = c("shop_id", "item_id", "month_nr", "item_cnt")
# Mittelw price group by month, shop, item
df_sales4a = aggregate(data.frame(df_sales3$item_price), by=data.frame(df_sales3$shop_id, df_sales3$item_id, df_sales3$month_nr), mean, na.rm=TRUE)
colnames(df_sales4a) = c("shop_id", "item_id", "month_nr", "item_price")
df_sales4 = merge(df_sales4, df_sales4a, by=c("shop_id", "item_id", "month_nr"))

# Test-Shop-Item-kombis für alle 33 Test-Monate
df_train = df_test[2:3]
df_train$month_nr = 1
for (k in(2:33)) {df_train = rbind(df_train, cbind(df_test[2:3], data.frame(month_nr=rep(k, nrow(df_test)))))}

df_train = merge(df_train, df_sales4, by=c("shop_id", "item_id", "month_nr"), all.x=TRUE)
df_train$item_cnt = ifelse(is.na(df_train$item_cnt), 0, df_train$item_cnt)

# Export Csv
expfile = paste(paste(Pathcsv, "TrainMonthly", sep=""), ".csv", sep="")
write.csv(df_train, row.names=FALSE, file=expfile)



