#「線グラフを書いてみよう」==================
#まずは適当に、Projectを1つ作っていただき、その中で
#このスクリプトを実行していってみてください。
#おすすめなのは、コードをご自身でタイプして
#実行結果を確認しながら進めることです。
#途中でミニ課題をいくつか入れておりますので、
#理解して使えているかの確認にお使いください。

#ここでは、次のデータを利用します。

library(tidyverse)

data(ChickWeight) #ChickWeightデータ導入

dat <- ChickWeight
dat <- as.tibble(dat) #tibble形式に変換！

rm(ChickWeight)

#View(dat)

?ChickWeight

#いきなりですが、次のグラフを描画してみてください

{
  ggplot(dat) + 
    geom_line(aes(x = Time, y = weight, color = Diet, group = Chick))
}






#できましたか？

ggplot(dat) +
   geom_line(aes(x = Time, 
                 y = weight)) #X

ggplot(dat) +
  geom_line(aes(x = Time,
                y = weight,
                color = Diet))

#??? すいません
#実は、医師が教える～で紹介した知識だけでは
#書けないグラフです。

# なぜでしょうか？
#----------------------------------------

#目的のグラフを描画しようとして、思うように
#いかない場合は、変数の数を数えてみてください。

dat

# 今回、描画使用としているグラフの変数は、
# weight
# Time
# Chick
# Diet

#の4種類です、
#ところが、

ggplot(dat) +
  geom_line(aes(x = Time,
                y = weight,
                color = Diet))

#では、aesの中が3種椎しかありません。

#Diet毎に複数のChickがふくまれてしまっている
#ため、こういうことが起こります。

#どうするか？

#なのでgroupを足して、

ggplot(dat) + 
  geom_line(aes(x = Time,
                y = weight,
                color = Diet,
                group = Chick))

#と書くことで描画できます。

#groupとcolorは入れ替えてしまうと、
ggplot(dat) + 
  geom_line(aes(x = Time,
                y = weight,
                color = Chick,
                group = Diet))

#こんな感じでまともになりません。
#この2つのコードが何を示しているかちょっと
#考えてみてください。




#考えましたか？
ggplot(dat) + 
  geom_line(aes(x = Time,
                y = weight,
                color = Chick,
                group = Diet))

#groupに設定した変数は「グループ」に分けられます
#そのため、Dietという、どんな食事を与えられたか
#という変数でグループをわけてしまうと、
#描画される「線」の数が、
dat$Diet %>% unique()
# 4種類になってしまいます。

#もちろん、このデータの性質からは、引きたい線
#は実験対象毎に、つまりは、Chick毎の、
dat$Chick %>% unique()
#50本の線を引きたいわけです。

#ということで、
ggplot(dat) + 
  geom_line(aes(x = Time, y = weight,
                color = Diet,
                group = Chick))

#とすることで、目的としたグラフが書けました！

# グラフを変数毎に分けてみる============

# 先程作った線グラフをちょっと見やすくして
# みましょう

ggplot(dat) + 
  geom_line(aes(x = Time, y = weight,
                color = Diet,
                group = Chick))


ggplot(dat) + 
  geom_line(aes(x = Time, y = weight,
                color = Diet,
                group = Chick)) +
  facet_wrap(~Diet)

#どうでしょう？
#見やすくなりましたか？
#facet_wrapは、変数毎にグラフを描画したいとき
#に非常に有用な変数です。

#基本的な書き方は、
?facet_wrap

#に書いてあります。

#全部を紹介しません(できません汗）。

#できれば、ヘルプに書いてある内容から読み問く
#試みを繰り返していただけると、
#そのうち、「見たことのない関数」
#に出会っても、自力で使い方を推測して
#わかるようになるはずです。（もちろん、
#一定程度時間はかかりますけど・・・）

#説明：
g <- ggplot(dat) + 
  geom_line(aes(x = Time, y = weight,
                color = Diet,
                group = Chick))

g

g + facet_wrap(~ Diet)

#このチルダ（～）で始まるものは、Rでは、
#Formulaと呼ばれています。
#結構色々な場所ででてくるので、
#「こういうもんか」という形でとりあえずは納得
#してください。
#感覚的な理解としては、
#Rでは＝記号は特別な意味を持つため、
#数式でよくでてくる＝記号を使いづらい場面が
#でてくる場合に、＝のかわりに～を使っている
#くらいの感覚でよいと思います。
#(モデリングのlm glm関数でも利用しましたね)

g + facet_wrap(~ Diet, nrow = 1)
#こうすると、行が1つになるのでY軸方向の比較
#しやすくなりました。


g + facet_wrap(~ Diet, ncol = 1)
#かえって差がわかりにくいですね


g + facet_wrap(~ Diet, nrow = 1, scales="free")
#違いわかりますか？
#先程は、Y軸のスケールが全て統一されていた
g + facet_wrap(~ Diet, nrow = 1)
#のが、scales="free"をたすと、
g + facet_wrap(~ Diet, nrow = 1, scales="free")
#ばらばらです。
#end_004
#----------
#また、よく遭遇する「こまったこと」として、
g2 <- dat %>% 
  filter(Diet != "1") %>% 
ggplot() + 
  geom_line(aes(x = Time, y = weight,
                color = Diet,
                group = Chick))

g2 #あえて、Diet==1のデータが全て欠損している
#場合を考えてみましょう。

g2$data$Diet %>% summary()

#このように、グラフ$dataから、データを取り出す
#ことができますが、今回のように、
#欠損したものがFactorだった場合は、

g2 + facet_wrap(~Diet, nrow = 1)

g2 + facet_wrap(~Diet, nrow = 1, drop = FALSE)

#こんな風に、欠損しているものを含めて描画する
#ことができます。

#ここでの、利用方法は、あんまりメリットを感じ
#にくいかもしれませんがたとえば、次のような場合はどうでしょう？
tempdat <- dat %>% 
  filter(Diet != "1") 

ggplot(tempdat) + 
  geom_bar(aes(x = Diet))


tempdat$Diet %>% summary()

#Diet全部が欠損するケースは通常実験のやり直しかそもそも含めないはずなので
#不自然ではありますが、ggplotの機能として、基本的にこういうケースでは
#全く描画されません。
#これだと、欠損して存在していないのか、
#そもそも測定されていないのかがわからないので、

ggplot(tempdat) + 
  geom_bar(aes(x = Diet)) + 
  scale_x_discrete(drop=FALSE)

#と、Ｘ軸（因子型の描画をしているので、disrete）の設定を
#drop=FALSEを追加してあげることで、明示することができます。
#このDropの使い方、結構見落としがちなので、
#「因子型が表示されない！」という時は思い出してみてください。
#（私が初めてこの問題に遭遇したときは、数時間あれこれ悩みました。。。）

#end_006
#end_007(on slide)
#グラフを重ね合わせる1==========

ggplot(dat) + 
  geom_line(aes(x     = Time,
                y     = weight,
                color = Diet,
                group = Chick) )


#さて、このグラフの見やすさを向上させるために、
#ちょっとデータ毎に点を打って見ましょう。

ggplot(dat) +
  geom_point(aes(x  = Time,
                 y  = weight,
                 color = Diet))

# 実は、ggplotではgeom + geomという記載で
#　グラフを重ね合わせることができます。

g <- ggplot(dat) + 
  geom_line(aes(x     = Time,
                y     = weight,
                color = Diet,
                group = Chick) ) +
  geom_point(aes(x  = Time,
                 y  = weight,
                 color = Diet))

g
#どうでしょうか？
#見た目の問題ですが、線グラフのデータポイントを
#よりはっきりと描画できましたね？

#ちょっとごちゃごちゃしているので、
g + facet_wrap(~Diet)

#としてもよいかもしれません。
#感覚的な理解をするために一度スライドへ！

#end_008
#スライドから：

#少し解説用のスクリプトを見やすくするために
#変数名を変更します。

dat <- dat %>% 
  rename(x = Time, y = weight,
         D = Diet, C = Chick)

dat

ggplot(data = dat) +
  geom_line( aes(x = x, y = y, color = D, group = C))+
  geom_point(aes(x = x, y = y, color = D))

#ggplot(data=dat)と最初のdataの内容がそれぞれのgeomに
#わたされているという説明は納得できましたか？

#それでは、簡単な実習です。次の続きを書いて
#今表示されているものと同じグラフを
#描画してみてください。


#1: ggplot() +
  
  
  
  
#:2 ggplot(data = dat, mapping = aes(x = x  
  
  
#できましたか？
  
ggplot() +  
  geom_line(data = dat,
            aes(x=x, y=y, color=D, group=C)) +
  geom_point(data = dat,
             aes(x=x, y=y, color=D))

ggplot(data = dat, mapping = aes(x=x, y=y, color=D, group=C)) + 
  geom_line() +
  geom_point()


ggplot(data = dat, mapping = aes(x=x, y=y, color=D)) +
  geom_line() + 
  geom_point()
#end_010

# グラフを重ね合わせる2=====
#(別のデータを足してみる)

#蛇足ですが、aesを変数に収納しても正常に描画できます。

xyDC <- aes(x=x,y=y,color=D,group=C)

#これでも、次のように書けば正常に描画されます。

ggplot(dat) +
  geom_line(xyDC) +
  geom_point(xyDC)

#さて、1つ前では、geomどうしを足しあわせることが
#可能と説明しました。
#また、

ggplot() +
  geom_line(data = dat, xyDC) +
  geom_point(data = dat, xyDC)

#のように、書く事もできました。

#ということで、
#もうお気づきかも知れませんが、
#全く別のデータから描画されるグラフを重ねることも
#可能になります。

#Chick Weightのデータだと、ちよっとごちゃごちゃしすぎるので、別のデータを利用します。

#ここでは、上手い具合にわかれている
#beaver1 と　beaver2　のデータを加工して
#描画してみます。

?beaver1

summary(beaver1)

dat1 <- beaver1 %>% 
  mutate(day = day - 345)

summary(dat1)

summary(beaver2)

dat2 <- beaver2 %>% 
  mutate(day = day - 306)

summary(dat1)
summary(dat2)

#これで、day変数の内容がdat1とdat2で一致しました。

#ここまでできているとして、

#X軸をtime、y軸を体温,日付でグループわけして、
#dat1とdat2を重ねあわせた線グラフを
#描画してみてください。
#(ここまでの知識ではきれいなグラフにはなりません。
#ただし、それを修正しつつレクチャーを進めていくので
#一旦、ここで考えて描画しようとしてみてください）












ggplot() +
  geom_line(data=dat1, 
            aes(x=time, 
                y=temp, 
                group=day), color="red") +
  geom_line(data=dat2,
            aes(x=time,
                y=temp,
                group=day), color="orange")

#どうでしょうか？
#このようにして、別々のデータを重ねて描画する
#ことができましたね？

#ここからは、このグラフを

{
  dat1 <- beaver1 %>% 
    mutate(day2 = lubridate::as_date(day-345, origin="1990-1-1")) %>% 
    mutate(time2 = formatC(time, 
                           width=4,
                           flag="0",
                           big.mark = ":",
                           big.interval = 2)) %>% 
    mutate(time2 = hms::parse_hm(time2)) %>% 
    mutate(time4 = str_c(day2, " ", time2)) %>% 
    mutate(time4 = lubridate::as_datetime(time4, tz="US/Central"))
    
  
  dat2 <- beaver2 %>% 
    mutate(day2 = lubridate::as_date(day-306, origin="1990-1-1")) %>% 
    mutate(time2 = formatC(time, 
                           width=4,
                           flag="0",
                           big.mark = ":",
                           big.interval = 2)) %>% 
    mutate(time2 = hms::parse_hm(time2)) %>% 
    mutate(time4 = str_c(day2, " ", time2)) %>% 
    mutate(time4 = lubridate::as_datetime(time4, tz="US/Central"))
  
  ggplot() + 
    geom_line(data=dat1,aes(x=time4,y=temp),color="red")+
    geom_line(data=dat2,aes(x=time4,y=temp),color="blue")+
    scale_x_datetime(date_breaks = "60 mins",
                     labels = scales::time_format()) +
    theme(axis.text.x = element_text(angle=45, hjust=1))
}

# となるように加工していく過程で日付・時刻型のデータの取扱と
# グラフの描画に関する
# 知識をお伝えできればと思います。



