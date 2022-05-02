library(tidyverse)

?beaver1
dat1 <- beaver1

dat2 <- beaver2

ggplot() +
  geom_line(data=dat1, 
            aes(x=time, 
                y=temp, 
                group=day, 
                color=day)) +
  geom_line(data=dat2,
            aes(x=time,
                y=temp,
                group=day,
                color=day))


# 時間軸への加工============================

# Ｘ軸の変数はtimeです

dat1$time

dat1 %>% str()

#すべて num の数値型です。
#とりあえず、840という表記を08:40
#という形に変換してみましょう。

vec <- dat1$time

#幅をそろえて、ゼロで埋める：
#2幅毎に:を打つ
#end_014

#formatC関数：
test <- 1:10
test

#数字をそのままformatC関数に放り込むと、
formatC(test)

#こんな感じになります。
#このformatC関数内にArgumentを色々指定すること
#で、今回達成したいことが実現可能です。

#まずは、width
formatC(test, width=10)

#どうでしょうか？
#すべての数字の幅が10個分になりました。

#これは、flagをつけることで、
formatC(test, width=5, flag="0")

#足りない部分を0で埋めることができます。
#また、
formatC(4321, big.interval = 3, big.mark=",")
formatC(4321, big.interval = 2, big.mark="!")
formatC(4321, big.interval = 3, big.mark=" ")

#と装飾を与えることも可能です。ということは、
formatC(10, 
        width=4, 
        flag="0", 
        big.interval=2,
        big.mark=":")
#どうでしょうか？

test


formatC(test, width=4, flag="0", big.interval = 2, big.mark=":")






vec





vec2 <- formatC(vec, 
                width=4, 
                flag="0",
                big.mark = ":",
                big.interval = 2)

vec
vec2

#時刻へ変換
vec3 <- hms::parse_hm(vec2)

vec2
vec3
#このように、formatC　と　parse_hmを利用すれば
#目的の変換が達成できます。

#課題：dat1, dat2の time をmutateの中で
#同様に処理してみましょう。








dat1 <- as.tibble(dat1)
dat2 <- as.tibble(dat2)


dat1 <- dat1 %>% 
  mutate(time2 =  formatC(time, 
                         width=4,
                         flag="0",
                         big.mark = ":",
                         big.interval = 2)) %>% 
  mutate(time2 = hms::parse_hm(time2))

dat1

dat2 <- dat2 %>% 
  mutate(time2 =  formatC(time, 
                         width=4,
                         flag="0",
                         big.mark = ":",
                         big.interval = 2)) %>% 
  mutate(time2 = hms::parse_hm(time2))

dat2

#できましたか？
#ではdat1のグラフを書いてみてください。

tempaes <- aes(x=time2, y=temp, group=day, color=day)

ggplot() + 
  geom_line(data=dat1, tempaes)


#これで、x軸が時間軸になりました。

#時間軸の設定============================

#作戦1：時刻データを変換してみる-----------------------

dat1 %>% 
  mutate(time3 = if_else(time2 < 8*60*60, 
                         hms::as.hms(time2+24*60*60),
                         time2)) %>%
  ggplot() +
  geom_line(mapping = aes(x=time3, y=temp))
  
#うまくいきました！
#ここで何をしたか、順番にみていきましょう。

dat1 %>% 
  mutate(time3 = if_else(time2 < 8*60*60, 
                         hms::as.hms(time2+24*60*60),
                         time2)) %>% View()

#まず、この部分では、新しいtime3変数を作成しています。
#time3変数の内容は、if_else関数で条件分けされています

#***020
#if_else関数の書き方は、

#if_else(＜条件＞, 
#        ＜TRUEの場合の値＞,
#        ＜FALSEの場合の値＞ )

if_else(TRUE, "ただしいよ", "ちがうよ")

if_else(c(TRUE, FALSE, FALSE),"ttt","fff")

if_else(c(1,2,3,4,5) > 3, "ttt", "fff")

if_else(c(TRUE, FALSE, NA), "t","f", "NA!!")

if_else(c(TRUE, FALSE, NA), "t", "1" , "NA!!")

if_else(c(TRUE, FALSE, NA), 1, 2, 999)

#という形です、
#今回の場合は、条件が、time2 < 8*60*60
#です。

#021--------------------------

dat1 %>% 
  mutate(time3 = if_else(time2 < 8*60*60, 
                         hms::as.hms(time2+24*60*60),
                         time2)) %>% View()

#この変換を理解するための、if_elseについては説明
#しました。ただ、条件で8*60*60としている部分に
#ついての理解のためには、時刻データがR上でどのように
#保存されているのかを知っていないと理解が難しいです。

#=============
dat1$time2 %>% str()
# このように、time2変数は、"hms" という
# クラスがついています。
#しかも、
dat1$time2 %>% class()

dat1$time2
#ではあたかも、時分秒の形に見えていますが、

dat1$time2 %>% as.numeric()
#内容をみると、31200、31800。。。となっています。

{
  #本コースの内容を離れるので、詳しい解説は行いませんが
  #「オブジェクト指向」という考え方がプログラミング
  #にはあります。
  
  #Classというものは、Rにおけるオブジェクト指向を
  #実現するための、便利な属性みたいなものという
  #認識をしていただければ良いかと思います。
  #詳しく知りたい方は、Advanced Rという
  #本を見てみて下さい
  #（もしくは、RのOOPはとっつきにくいのでPythonなどで
  #　OOPの基本をある程度理解したうえで戻ってくると
  #　よいかもです。脱線しました。。。）
  
}

#変換を詳しく改めて見てみると、
target <- dat1$time[1:3]

target

target %>%
  formatC(width = 4, flag = "0", 
          big.interval = 2, big.mark = ":")

converted <- target %>%
  formatC(width = 4, flag = "0", 
          big.interval = 2, big.mark = ":") %>% 
  hms::parse_hm()

converted

target %>% str()

converted %>% str()
converted %>% as.numeric()

#08:40が31200という数字に置き換わりました。
#022---------------------------
?hms::as.hms

#を読むと、hms形式は、カスタムクラスを
#伴った difftime Vector と書いてあります。
#ちんぷんかんぷんで全然OKです。
#大事なのは次の部分で、
#「常に秒を単位として保存されている」
#とあります。確認してみましょう。

target
converted %>% as.numeric()

31200/60
520 %% 60 #60で割ったあまり　40
520 %/% 60 #60で割った商　　8

# ということで、31200秒は、
# 520分に相当して、
#　520分中、60分は8回、あまり40
#　つまり、31200秒は8時間と40分に相当します。

# hms Classの挙動は理解できましたか？
# 単純に、00:00:00を起点に何秒後かが保存されている

# だけです。

dat1 %>% 
  mutate(time3 = if_else(time2 < 8*60*60, 
                         hms::as.hms(time2+24*60*60),
                         time2)) %>% View()

# hmsクラスの挙動の理解があれば、この
#if_else以下で何が行われているか理解できます。

# まず、
# time2 < 8*60*60 （8時未満）　がTRUEであれば、
# time2 + 24 *60 *60 と24時間分の秒数を足しています。
#023--------------------------------------

# ただし、

dat1$time2[1] 
dat1$time2[1] + 24*60*60

#この二つの違いはどうでしょうか？

dat1$time2[1] %>% str()
(dat1$time2[1] + 24*60*60) %>% str()

#difftimeクラスをhmsへと置き換えるには、
#hms::as.hms()関数を利用する必要があります

hms::as.hms(dat1$time2[1] + 24*60*60)

#こうすることで、時刻データとなりました。

#その結果、
dat1 %>% 
  mutate(time3 = if_else(time2 < 8*60*60, 
                         hms::as.hms(time2+24*60*60),
                         time2)) %>% View()

#23:59:59以降の時刻に、24*60*60秒が足されることで
#00:00:00　->　24:00:00
#00:00:01　->　24:00:01

#という形になるわけです。
#そして、このデータをggplot関数で描画すると、

dat1 %>% 
  mutate(time3 = if_else(time2 < 8*60*60, 
                         hms::as.hms(time2+24*60*60),
                         time2)) %>%
  ggplot() +
  geom_line(mapping = aes(x=time3, y=temp)) 










#いかがですか？
dat2 %>% 
  mutate(time3 = if_else(time2 < 8*60*60,
                         hms::as.hms(time2+24*60*60),
                         time2)) %>% 
  ggplot() +
  geom_line(aes(x=time3, y=temp)) 

#024--------------------------------------------
#さらに練習です。
#これらの2つのグラフを1つにまとめてみて下さい。






#いくつか方法がありますが、
#ggplotでなんとかする

dat1ex <- dat1 %>%
  mutate(time3 = if_else(time2 < 8*60*60,
                         hms::as.hms(time2+24*60*60),
                         time2))

dat2ex <- dat2 %>% 
  mutate(time3 = if_else(time2 < 8*60*60,
                         hms::as.hms(time2+24*60*60),
                         time2))

ggplot() +
  geom_line(data = dat1ex, aes(x=time3, y=temp)) +
  geom_line(data = dat2ex, aes(x=time3, y=temp))

#色がみにくいので、
ggplot() +
  geom_line(data    = dat1ex, 
            mapping = aes(x=time3,y=temp),
            color   = "red") +
  geom_line(data    = dat2ex,
            mapping = aes(x=time3, y=temp),
            color   = "blue")

#という風に、色の名前で色を設定して見やすくもできます

#dplyrでなんとかする ちょっと複雑ですが
datcomb <- 
  bind_rows(
    {dat1 %>% mutate(type = "beaver1")}, 
    {dat2 %>% mutate(type = "beaver2")}
  ) %>%
  mutate(time3 = if_else(time2 < 8*60*60,
                         hms::as.hms(time2+24*60*60),
                         time2))

# {}を使った書き方は初めて紹介します。

#上のデータ加工は、

dat1dash <- dat1 %>% mutate(type="beaver1")
dat2dash <- dat2 %>% mutate(type="beaver2")

datcomb <- bind_rows(
  dat1dash, 
  dat2dash
) 
#を、

datcomb <- bind_rows(
  {dat1 %>% mutate(type="beaver1")},
  {dat2 %>% mutate(type="beaver2")}
)

#とかいたものと同一です。
#dat1dashなど、もう二度と使わないであろう変数
#である場合などに、効果的です。
#あんまり多様するとコードが読みにくくなるので、
#必要なときのみがよいかもしれません。


#それで

datcomb <- 
  bind_rows(
    {dat1 %>% mutate(type = "beaver1")}, 
    {dat2 %>% mutate(type = "beaver2")}
  ) %>%
  mutate(time3 = if_else(time2 < 8*60*60,
                         hms::as.hms(time2+24*60*60),
                         time2))

ggplot(datcomb) + 
  geom_line(aes(x=time3, y=temp, color=type))

#という風にもかけます。
#どちらでも、目的のグラフがかければよいです！
#どっちがよいかは、目的のグラフ次第なところ
#もありますが・・・。

#025-------------------------------------
#作戦2 日付データを含めて描画する-------------

#さて、beaverの加工にひたすら時間を
#かけていますが、次は、日時データを利用した
#X軸の描画方法について検討しましょう。

#これまでは、X軸を00:00:00からの秒数であらわす
#hmsクラスで描画していましたが、
#ここからは、Lubridateを多用して描画していきます
library(lubridate)

buf <- lubridate::as_datetime(0)
buf1 <- lubridate::as_datetime(10)

buf
buf1

#いかがでしょう?

class(buf1)

# このように,lubridate::as_datetimeを利用すると、
#1970年1月1日00:00:00を起点に何秒経過したか
#であらわすことができます。

as_datetime(-100)

#マイナスを利用すると1970年1月1日00:00:00以前の
#時間も表現することが可能です

#26----------------------------------
#lubridateは時間に関して色々と便利な
#関数を提供してくれているパッケージで、

utc <- lubridate::ymd_hms("2020-10-20 10:45:21")
as.numeric(utc)

#文字列型をdate_timeに変換することができます。
utc
#タイムゾーンの概念も含まれているので、
#日本標準時に変換することも可能です。

OlsonNames()

tz(utc)

jst <- with_tz(utc, tzone = "Asia/Tokyo")

utc
jst
#このように、時刻の変換も可能になります。

#さて、上記の知識を利用して、グラフ描画について考え
#てみましょう。

#26---------------------------
#beaverデータの日付表現とOrigin

?beaver1

#help からは、beaver1,2 のデータのdayは、
#1990年1月1日からの経過日数で表されていると
#記載されています。

# 日付のデータは、時刻のデータと同様に、
#起点を軸に何日経過したかという
#形で表現されます。

as_date(1)
as_date(0)

#datetimeでの値の表現を考えてみましょう。
dat1

#tempdayは346等の数字になっています。
#ヘルプファイルが指定しているように、
#1990年1月1日から何日が経過しているかという
#日付観点での日付型のデータへの変換には
#lubridateのas_date関数を利用します。

tempday <- as_date(346, origin="1989-12-31")
tempday

#lubridateは、日付、時刻両方に関する色々な関数が
#提供されており、

as_date(0)
as_date(0, origin = "1990-1-1")
as_date(100)
as_date(100, origin = "2018-3-4")

ymd("20180103")
ymd("2018-1-05")
mdy("04301998")

#など、日付型のデータを簡便に文字列から作ることが
#可能です。

?lubridate
#詳しくは、R studioの日付、時刻のチートシートへ。
#************************************

#027---------------------------------------------
#ビーバーデータの変換の続きです。-----------------
?beaver1
tempday <- as_date(346, origin="1989-12-31")
tempday
#timezone は "north-central Wisconsin timezone" で
#Google検索すると、CSTというtimezoneとなります。

temptime <- dat1$time2[[1]]

#ということで
tempdatetime <- str_c(tempday, " ",temptime)
tempdatetime
as_datetime(x = tempdatetime, tz   = "US/Central")

#このように変換することができました！

#それでは、課題です!
#dat1のtime2変数をdatetimeデータに
#変換してみてください。







dat1 <- dat1 %>% 
  mutate(day2 = as_date(day, origin="1989-12-31")) %>% 
  mutate(time4 = str_c(day2, " ", time2)) %>% 
  mutate(time4 = as_datetime(time4, tz="US/Central"))

#028------------------------------------------
#********************************
#そしてグラフ化をしてみてください！






ggplot(dat1) + 
  geom_line(aes(x=time4, y=temp))

#いかがでしょうか？
#ggplot側のコードは今度は最小限になっています。

#ただ、dat2も同様な処理をして重ね合わせてみてください
#どんなことが起こるでしょうか？
dat2 <- dat2 %>% 
  mutate(day2 = as_date(day, origin="1989-12-31")) %>% 
  mutate(time4 = str_c(day2, " ", time2)) %>% 
  mutate(time4 = as_datetime(time4, tz="US/Central"))

ggplot(dat2) + 
  geom_line(aes(x = time4, y = temp))

ggplot() +
  geom_line(data=dat1, 
            aes(x=time4, y=temp), color="blue") +
  geom_line(data=dat2,
            aes(x=time4, y=temp), color="red")

#029-----------------------------------------
#なにが起こったかわかりますか？

dat1$time4 %>% summary()
dat2$time4 %>% summary()

#今回、time4はdatetimeデータとなっているため、日付
#の値があります。そのことを考慮せずに描画
#したため、今回のように時間軸が大きくかい離した
#形で表示されたというわけです。



#ここで、同じ日程を表示するとするとどうすれば
#よいでしょうか?
dat1$day %>% summary()
dat2$day %>% summary()

#同じ日にしてしまえば、同じX軸で描画できるはずです
#なので、

dat1 <- dat1 %>%
  mutate(day2 = day - max(day)) %>% 
  mutate(day3 = as_date(day - max(day))) %>% 
  mutate(time4 = as_datetime(str_c(day3," ",time2)))

dat2 <- dat2 %>%
  mutate(day2 = day - max(day)) %>% 
  mutate(day3 = as_date(day - max(day))) %>%   
  mutate(time4 = as_datetime(str_c(day3," ",time2)))

# としてしまいましょう！
# day2という変数は、 as_date(day - max(day))というベクトルがいれられています。
# ここで何をしているかわかりますか？

# max()関数は、数値ベクトルの最大値を返す関数です。

max(c(1,4,3,2,1,2000))

# ということで、vec - max(vec)と書くことで、

c(  1,  2,  3,  4,  5,  6,  7) - max(c(1,2,3,4,5,6,7))
c(100,101,102,103,104,105,106) - max(c(100,101,102,103,104,105,106))

# 同じながさの連続してならんでいる数字であれば、同じ結果になります。
# 今回の日付データは、ある二日間しかないので、
#別に直接数字を指定してもよいですし、
#マイナスになるのが気持ち悪ければ、

c(1:7) -min(c(1:7))
c(100:106) -min(c(100:106))

#としてもグラフ描画のために日付を同じ値にそろえるという目標は変わりません。
# で、

ggplot() + 
  geom_line(data=dat1,aes(x=time4,y=temp),color="red")+
  geom_line(data=dat2,aes(x=time4,y=temp),color="blue")

#030----------------------------------------
#どうでしょう！あとは、日付の表記が「出たらめ」なので

ggplot() + 
  geom_line(data=dat1,aes(x=time4,y=temp),color="red")+
  geom_line(data=dat2,aes(x=time4,y=temp),color="blue")+
  scale_x_datetime(date_breaks = "60 mins",
                   labels = scales::time_format()) +
  theme(axis.text.x = element_text(angle=45, hjust=1))


#こんな感じでscale_x_datetimeの
#   date_breaks = "60mins"
#   labels = scales::time_format()
#としてあげることで、60分単位での分割と、
#ラベルを適した形に変更できます。

ggplot() + 
  geom_line(data=dat1,aes(x=time4,y=temp),color="red")+
  geom_line(data=dat2,aes(x=time4,y=temp),color="blue")+
  scale_x_datetime(date_breaks = "1 days")+
  theme(axis.text.x = element_text(angle=45, hjust=1))

ggplot() + 
  geom_line(data=dat1,aes(x=time4,y=temp),color="red")+
  geom_line(data=dat2,aes(x=time4,y=temp),color="blue")+
  scale_x_datetime(date_breaks = "120 mins", labels = scales::time_format())+
  theme(axis.text.x = element_text(angle=45, hjust=1))

#という感じで、任意のbreakの設定ができて、
#今回は時刻の表記だけでよいので、scales::time_format()関数を利用すること
#で、目的のグラフになりました！

#いかがでしたでしょうか？
#今回は、beaverデータを利用して、
#日付/時刻に関するデータの
#扱い方を学んできました。
#日付時刻型の取扱は、他にもdifftime型という差を扱うものや
#durationという経過時間を扱うものがありますが、

#基本は、(originをいじらなければ)
# 時刻：00:00:00からの秒数経過
# 日付：1970-01-01からの日数経過
# 日付時刻： 1970-01-01 00:00:00からの秒数経過

#という「ただの数字」を便利に時刻や日付で現すことができるようにした
#ものであるという認識をしていただけると見通しよく
#理解がすすむと思います。

#尚、毎回言っている気がしますが、RstudioのCheatsheetは
#英語ではありますが、日付/時刻に関するCheatsheetもあるので、
#是非、時間のあるときに眺めてみてください。







