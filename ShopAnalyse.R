# Run Pred01.R until df_sales3$shopitem_id = paste(as.ch... line 45 to create the data you need
library(ggplot2)

df_shops = aggregate(data.frame(df_sales3$item_cnt_month), by=data.frame(df_sales3$shop_id, df_sales3$month), sum, na.rm=TRUE)
colnames(df_shops) = c("shop_id", "month", "item_cnt_month")

df_shops_sum = aggregate(data.frame(df_shops$item_cnt_month), by=data.frame(df_shops$shop_id), sum)
colnames(df_shops_sum) = c("shop_id", "sum")

df_shops_cnt = aggregate(data.frame(df_shops$item_cnt_month), by=data.frame(df_shops$shop_id), length)
colnames(df_shops_cnt) = c("shop_id", "cnt")

df_shops = merge(x = df_shops, y = df_shops_sum, by = "shop_id", all.x = TRUE)
names(df_shops)
df_shops = merge(x = df_shops, y = df_shops_cnt, by = "shop_id", all.x = TRUE)
names(df_shops)

ggplot(df_shops, aes(x = reorder(shop_id, sum), y = item_cnt_month)) +
  geom_point() +
  labs(title="sales of shops / sum of products", x='shop_id')

ggplot(df_shops, aes(x = reorder(shop_id, cnt), y = item_cnt_month)) +
  geom_point() +
  labs(title="sales of shops / number of products", x='shop_id')


