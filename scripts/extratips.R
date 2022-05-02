#補足　limitとcoord_cartesian
#でのグラフの切り取りとズームイン

#例としては、
temp <- diamonds

ggplot(temp) + 
  geom_point(aes(x = carat, y = price, color = color))

ggplot(temp) +
  geom_point(aes(x = carat, y = price, color = color)) +
  scale_x_continuous(limits = c(2,3)) +
  scale_y_continuous(limits = c(5000, 10000))

ggplot(temp) +
  geom_boxplot(aes(x = color, y = price)) +
  scale_y_continuous(limits = c(10000,15000))

ggplot(temp) +
  geom_boxplot(aes(x = color, y=price)) +
  scale_y_continuous(limits = c(5000, 10000))

#========================================
#補足　エラーバーの書き方

#補足　色の指定の仕方