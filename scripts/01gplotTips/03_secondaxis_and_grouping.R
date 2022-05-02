#gen dat ==================

library(tidyverse)

set.seed(1000)
dat <- tibble(
  date = c(1:30),
  temp = rnorm(n = 30, mean = 37.2),
  crp  = 0.01 * temp + rnorm(30,0,1)
) %>% 
  mutate(crp = if_else(crp < 0, 0, crp))

dat

#ここでは架空データの生成について、上記を
#解説していきます。ただ、あまり興味がない
#という方は、上のスクリプトを写経していただいて
#そこででてきた結果を利用してもらうでも
#よいと考えます。

#上のスクリプトを日本語でかくと、

set.seed(1000)
#ランダムの要素をとりあえず固定するよ。

dat <- tibble(
  date = c(1:30),
  temp = rnorm(n = 30, mean = 37.2),
  crp  = 0.01 * temp + rnorm(30,0,1)
) %>% 
  mutate(crp = if_else(crp < 0, 0, crp))

#tibble関数で、データフレームをつくるよ
# 1列目：dateという名前で、数字は1:30を
# 2列目



#final plot example ========================
mult <- 1
addit <- 34
cols <- c("temp" = "orange", "crp" = "blue")

ggplot(dat) + 
  geom_line(aes(x = date, y = temp, color = "temp")) +
  geom_point(aes(x = date, y = temp, color = "temp")) +
  geom_line(aes(x = date, y = (crp * mult) + addit, color = "crp")) + 
  geom_point(aes(x = date, y = (crp * mult) + addit, color = "crp")) +
  scale_y_continuous(
    sec.axis = sec_axis(name = "crp", trans = ~{(. - addit) /mult})
  ) +
  scale_color_manual(name="key", values = cols)
  
#-----------------Lecture ------------------------------------
#031 ON POWERPOINT-----------------------------
#032 ------------------------------------------
# データ作成---------------------------------
library(tidyverse)
#では、2軸の設定を行っていきます。
#今回、データは体温とCRPという「てい」で話をすすめます。
#が、組み込みのデータで良いものが見当たらないので・・・

#作りましょう！
tibble()
tibble(a = c(1,2,3,4,5), b = c("a","i","u","e","o"))

#という風にtibble関数に変数名=ベクトルと指定してあげることで
#tibbleを作ることができます。

#また、

rnorm(n = 10, mean = 20, sd = 1)

#rnorm関数で、10個の平均20、
#標準偏差1に従うデータをランダムに生成する
#こともできるので、今回はこの機能を利用してデータを生成してみます。

#出来上がるデータのイメージは、
#日数：1-20日
#体温：平均37.5で標準偏差1の正規分布に従ってランダムに
#     決まる
#CRP：体温の0.01倍を基準に、平均0で標準偏差1の正規分布分だけ
#    「ずれる」
#　 （もしマイナスの値になったら0とする）

#というものになります。
#このデータ自分で作って見ましょう！








#033 ------------------------------------------
#日数：1-20日
#体温：平均37.5で標準偏差1の正規分布に従ってランダムに
#     決まる
#CRP：体温の0.01倍を基準に、平均0で標準偏差1の正規分布分だけ
#    「ずれる」
#　 （もしマイナスの値になったら0とする）

set.seed(1234)
dat <- tibble(
  date = c(1:20),
  temp = rnorm(n = 20, mean = 37.5, sd = 1),
  crp  = (temp*0.01) + rnorm(20,0,1)
) %>% 
  mutate(crp = if_else(crp < 0, 0, crp))








#尚、rnorm関数はランダムに数字を生成するため
#毎回結果が変わります。
#これをそろえたい場合は、set.seedという関数を一緒に実行
#してあげることで同じ値が毎回生成されるようになります。

#034-------------------------------------------------
#グラフを書いてみる-------------------------------------
#では、作成したdatデータを使って、
#geom_pointを使ったグラフを書いてみましょう











ggplot(dat) + 
  geom_point(aes(x = date, y = temp)) + 
  geom_point(aes(x = date, y = crp))

#どうでしょうか?
#とりあえず、上下に分かれて、変化の関係をみたいという
#場合には、ちょっとつらいかなという感じですね？

#また、色分けもされていないので、どっちがどっちかわからない感じ
#なので、次のように変えてみて下さい。

ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp, color = "CRP値")) +
  scale_color_discrete(name="凡例")

#どうでしょうか?
#これまで、colorには、変数名を入れていましたが、
#今回のように軸を重ねるケースでは、aes内のcolorに
#文字列をいれて、色を分けることが可能です。
#そしてscale_color_discreteのnameに凡例の
#タイトルをいれている形になります

#035------------------------------------------------
#ON POWER POINT

#036----------------------------------------------
#2軸目を作ってみる-----------------------------------------------
#ここからは2軸目をつくっていきます。

ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(sec.axis = sec_axis(trans = ~{.}))

#scale_y_continuousはy軸でかつ連続変数の場合に関する軸を
#いじくる場合に利用する関数です
#sec.axis = sec_axis(trans = ~{.})
#で  2軸目の軸の値をこの指定で変換する

#という形になります。
#では、2軸目の値をとりあえず、1/10にしてみましょう！









ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(sec.axis = sec_axis(trans = ~{./10}))


#ついで、データが変換されていないので、CRPの値を10倍にしてみましょう










ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp*10, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(sec.axis = sec_axis(trans = ~{./10}))

#どうでしょうか？
#こでまでCRPで見えていなかった変化を捉えることができるように
#なりましたか？

#二軸目のぷちチャレンジ-----------------------------------------
#ぷちチャレンジ：CRPは見やすくなりましたが、
#今度は軸1の体温の変化が捉えにくくありませんか?
#これを、例えば、1軸を30-40の範囲、2軸を今の0-4の範囲に
#治めることはできそうですか？












#037---------------------------------------------------
#答え：
#まずは、1軸の表示を30-40の範囲に収めるために、
#crpの点を体温に近づけて（平行移動）から、
#変換するというイメージです

ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp, color = "CRP値")) +
  scale_color_discrete(name="凡例")

#まず、全体を30に近づけます（平行移動）

ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp + 30, color = "CRP値")) +
  scale_color_discrete(name="凡例")

#コピーした軸を作成
ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp + 30, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(sec.axis = sec_axis(trans = ~{.}))

#2軸目の下を0に設定
ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = crp + 30, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(sec.axis = sec_axis(trans = ~{. - 30}))

#2軸目の上を4に設定: 
#軸は現在、0から10になっているので、2.5で割りましょう。、
#注意点はcrpの値の変換の順番です。
#　2.5*(crp + 30)は大間違いです。
#　(2.5 * crp) + 30 にしないとまったく見当違いの値になります。
#イメージとしては、点の移動は、1軸目の値に変換するようにしてあげる
#ということになります

ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = (2.5*crp) + 30, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(sec.axis = sec_axis(trans = ~{(. - 30)/2.5}))

#できました！
#あと、軸にラベルをつけておきましょう

ggplot(dat, aes(x = date)) + 
  geom_point(aes(y = temp, color = "体温")) + 
  geom_point(aes(y = (2*crp) + 30, color = "CRP値")) +
  scale_color_discrete(name="凡例") +
  scale_y_continuous(name = "体温[C°]",
                     sec.axis = sec_axis(name = "CRP",
                                         trans = ~{(. - 30)/2}))

#038-----------------------------------------------------
#関数化してみる------------------------------------------------
#本筋とはずれますが
#微調整をしたい場合のテクニックを紹介しておきます

#今回、点の移動と軸の変換を試行錯誤しながら試みましたが
#「2回以上同じコードを書く場合は関数化」する
#ことをおすすめします。

#Rで自作関数を作る方法を簡単に紹介しますと。
# 関数名 <- function(argument){ 内容 }
# という形になります。
#たとえば、

teinei <- function(word){
  string <- str_c("御", word, "様")
  return(string)
}

teinei("犬")
teinei("猫")
teinei("猿")

#のような感じです。

#今回のグラフも、

sikousakugo <- function(heikou, bai, nyuryoku_data){
  gg <- ggplot(nyuryoku_data, aes(x = date)) + 
    geom_point(aes(y = temp, color = "体温")) + 
    geom_point(aes(y = (bai*crp) + heikou, color = "CRP値")) +
    scale_color_discrete(name="凡例") +
    scale_y_continuous(name = "体温[C°]",
                       sec.axis = sec_axis(name = "CRP",
                                           trans = ~{(. - heikou)/bai}))
  return(gg)
  
}

sikousakugo(30,2,dat)
sikousakugo(30,1.5,dat)
sikousakugo(35,3,dat)

