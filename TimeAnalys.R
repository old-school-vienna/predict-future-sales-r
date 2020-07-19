


df_55 = df_sales3[df_sales3$shop_id == 55,]
df_ts = aggregate(data.frame(df_55$item_cnt_month), by=data.frame(df_55$month), sum)
colnames(df_ts) = c('month', 'item_cnt_month')

ggplot(df_ts, aes(x = month, y = item_cnt_month, group=1)) +
  geom_line(linetype = "solid", color='black') +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="shop 55 items per month", x='shop_id')

df_ts = aggregate(data.frame(df_sales3$item_cnt_month), by=data.frame(df_sales3$month), sum)
colnames(df_ts) = c('month', 'item_cnt_month')

ggplot(df_ts, aes(x = month, y = item_cnt_month, group=1)) +
  geom_line(linetype = "solid", color='black') +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="all shop items per month", x='shop_id')
