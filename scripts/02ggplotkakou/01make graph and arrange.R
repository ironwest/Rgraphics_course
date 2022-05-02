#ggplot2加工偏==============================================
#データの準備------------------------------

#本セクションではesophデータセットを利用します

library(tidyverse)

dat <- datasets::esoph %>% as_tibble()

?esoph
dat
#esophデータセットは、フランスで行われた
#食道癌に関するケースコントロール研究の結果です

#   agegrp: 年齢でのグループ分け
#   alcgp : アルコール摂取量
#   tobgp : 喫煙量
#   ncases: 食道癌罹患群数
#   ncontrols: 非罹患群の数

#ncasesとncontrolsが整数型ではないので、変換しておきます。

dat <- dat %>% 
  mutate(
    ncases = as.integer(ncases),
    ncontrols = as.integer(ncontrols)
  )

#少し補足：
dat <- dat %>% 
  mutate_at(vars(ncases, ncontrols), ~{as.integer(.)})

dat
 #mutate_atは、mutate_at(vars(<selectで使う、列選択>),~{列に適応したい処理})
 #で、すべての列に処理を適応することができます。
 #今回のように、as.integerだけであれば、

dat <- dat %>% 
  mutate_at(vars(ncases, ncontrols), as.integer)

 #として、~{}がなくても大丈夫です。
 #as.integer()とするとエラーが起きるので注意 


#まずは、もととなるグラフの作成をしていきましょう

#(注：本コースはグラフの描画と加工が目的のコースで、
# ケースコントロール研究の分析方法は範囲外です。
# これから作成するグラフは、加工するための素材ですので、
#　その点が気になる方は、別のグラフを用意して加工をしてみてください)

#グラフの作成1----------------------------------------
#その前に、少しだけ加工しておきます。

dat2 <- dat %>% 
  gather(-agegp, -alcgp, -tobgp, key = key, value = value)

dat2
#（gather関数横持データを縦持ちデータに変換する関数です。
#　詳しくは、R入門コースのデータ加工編を参考にしてください）

#では、
g1 <- ggplot(dat2) + geom_col(aes(x = agegp, y = value, fill = key))

g1

#どうでしょうか？
#背景がグレーであること等、見た目を変更したいというケースが多いと思います。
#そこで、

library(cowplot)　#install.packages("cowplot")
g1

#cowplotをlibraryするだけで、先ほど作成したグラフが
# 背景が白に
# 文字も大き目に
#という変更が加わりました。

??cowplot

#cowplotが見た目のテーマに与える影響については、Introduction
#に色々と記載があるので興味がある方は見てみてください。

#042------------------------------------------------------------------
#保存方法の説明

save_plot("export.pdf", g1) #や
save_plot("export.jpg", g1)

#で保存すると、良い感じに保存できます。

#確認。。。
#文字がかぶっているので、幅を広げておきましょう。
save_plot("export.jpg", g1, base_aspect_ratio = 2:1)
#どうでしょうか？

ggplot2::ggsave("old.jpg",g1 + theme_grey())

#old.jpgとexpor.jpgを並べてみてみると、こんな感じでちがいます。
#（ここらへんは、主観が入るところだと思うので好きな方を以後利用してください）

#043----------------------------------------------------------
#グラフの作成2----------------------------------------

g1 <- ggplot(dat2) + 
  geom_col(aes(x = agegp, y = value, fill = key), position="dodge")
g2 <- ggplot(dat2) +
  geom_col(aes(x = alcgp, y = value, fill = key), position="dodge")
g3 <- ggplot(dat2) +
  geom_col(aes(x = tobgp, y = value, fill = key), position="dodge")



#ところで、繰り返しに気づいたら関数化の原則ですが、
#これできそうですか？一度、試みてみてください。








make_graph <- function(gdata, targetcol){
  gdata <- gdata %>%
    rename(target = targetcol)
  
  gg <- ggplot(gdata) + 
    geom_col(aes(x = target, y = value, fill = key), position="dodge") +
    labs(x = targetcol)
  return(gg)
}

make_graph(dat2,"alcgp")


#関数を利用すれば、
g1 <- make_graph(dat2, "agegp")
g2 <- make_graph(dat2, "alcgp")
g3 <- make_graph(dat2, "tobgp")

g1
g2
g3
#と簡潔に書くことが可能になります。

#同じ種類のグラフばかりだとつまらないので
g4 <- ggplot(dat) + 
  geom_jitter(aes(x = ncases, y = ncontrols, color = tobgp, shape = alcgp))


#044--------------------------------------------------
#補足：tidyevalをちょこっと紹介-------------------------------------------
#この関数を動かすためには、ggplot2のヴァージョンが2.3以上必要となります。
packageVersion("ggplot2")
#でヴァージョンが2.3未満の人は、
#install.packages("ggplot2")を実行して新しいVersionへしてみてください。


make_graph <- function(gdata, targetcol){
  tgt <- enquo(targetcol)
  
  gg <- ggplot(gdata) + 
    geom_col(aes(x = !!tgt, y = value, fill = key), position="dodge")
  
  return(gg)
}

make_graph(dat2, alcgp)



#この中で利用されているenquo()というものは、
#tidyevalという仕組みで、ggplot2のVer2.3から導入されています。

#045--------------------------------------
#グラフを並べて表示する---------------------------
#おまたせしました。ここでは、グラフを並べるやり方を示します。

スライドへ

#046--------------------------------
g1
g2
g3
g4

#基本；
plot_grid(g1, g2, g3, g4)

#実際にスライドで示した通りになるか、確認してみましょう
plot_grid(g1,g2,g3,g4, nrow=1)
plot_grid(g1,g2,g3,g4, ncol=1)

plot_grid(g1,g2,g3,g4, labels = c("A","B","C","D"))

plot_grid(NULL, g2, NULL,  g4, ncol=2, labels=LETTERS[1:4])

plot_grid(g2, g4, labels="AUTO", nrow=2)

plot_grid(g2, g4, labels="auto", nrow=2)

#基本的には、
#plot_grid(<並べたいグラフを用意>, nrow=/ncol=で形を指定, 
#labels= でラベルを指定)という形でOKです。

#047--------------------------------------------
#グラフのラベルを調整する-----------------------
#ここからは、
plot_grid(g1,g2,g3,g4, labels = "AUTO")

#を、微調整していく方法を学んでいきましょう。
plot_grid(g1,g2,g3,g4, 
          labels=c("年齢","飲酒","喫煙","飲酒VS喫煙"))

#スペースが足りないので、足しましょう
g1s <- g1 + theme(plot.margin = unit(c(1,0,0,1),"cm"))
g2s <- g2 + theme(plot.margin = unit(c(1,0,0,1),"cm"))
g3s <- g3 + theme(plot.margin = unit(c(1,0,0,1),"cm"))
g4s <- g4 + theme(plot.margin = unit(c(1,0,0,1),"cm"))

#基本コースで説明しきれていませんでしたが、
#themeで色々なことが設定できます。
#今回は、plot.margin = unit(c(上,右,下,左),"単位")
#で余白設定をしています。

plot_grid(g1s,g2s,g3s,g4s, 
          labels=c("年齢","飲酒","喫煙","飲酒VS喫煙"))

#これらのラベル位置はplot_grid内で調整することができます
plot_grid(g1s,g2s,g3s,g4s, 
          labels=c("年齢","飲酒","喫煙","飲酒VS喫煙"),
          hjust = -3)

#hjustは一斉に調整できますが、
#飲酒VS喫煙がおかしな位置になっているので、
plot_grid(g1s,g2s,g3s,g4s, 
          labels=c("年齢","飲酒","喫煙","飲酒VS喫煙"),
          label_x =c(0.09,0.09,0.1,0.05))

#何となく、同じ位置に納まりました。
#(ここは、数字をいれつつ微調整が必要です)

#47----------------------------------------------------
#凡例を共通化してみる-------------------------------------

#ここまでやって、次に目立つのが凡例です、
#左上、右上、左下のグラフの凡例は共通しているので、
#これを共通化してみましょう。

#やり方は、
#ggplotを主体にするやり方と
#cowplotを主体にするやり方
#の二通りあるので、１つずつみていきます。

#まずは、ggplotを主体とするやり方です

#こちらは、凡例を表示するグラフだけ、凡例を残して、それ以外を
#削除するというやり方になります。

g1snl <- g1s + theme(legend.position = "none")
g3snl <- g3s + theme(legend.position = "none")

#legend.position = "none"と設定することで、凡例が消えました。
#そこで、

plot_grid(g1snl, g2s, g3snl, g4s)

#としてあげることで、凡例を１つにしてすっきりとした形になりました。
#ただ、これだとスペースが気になる。。。

plot_grid(g1snl, g2s, g3snl, g4s, rel_widths = 1:10)

#そんな場合は、このように、rel_widths = 列の幅:列の幅
#というような設定をして微調整をしてあげることで、
#見た目がより良いグラフになります。
#1:10は、効果をわかりやすくするためのものなので、実際には、

plot_grid(g1snl, g2s, g3snl, g4s, rel_widths = 5:7)

#あたりが良さそうでしょか？

#049--------------------------------------------
#凡例を共通化してみる2---------------------
#では、cowplotを利用した凡例の共通化の方法を試してみましょう。

#cowplotでは、凡例のみをぬきだすという方法が使えます。
#「抜き出した凡例を1つのグラフ」として扱ってあげることが可能になります。
#見ていきましょう。

#まず、get_legend関数で凡例だけを抜き出します
glegend1 <- get_legend(g2s)
glegend2 <- get_legend(g4s)

#のこりのグラフも凡例を非表示にしておきましょう
g2snl <- g2s + theme(legend.position = "none")
g4snl <- g4s + theme(legend.position = "none")

#ということでグラフ部分は、plot_gridをつかうとこんな感じになります。
g1to4 <- plot_grid(g1snl, g2snl, g3snl, g4snl)

#ここまでは変わらないですね。
#ここからです。
#先程取り出したlegendは、plotgridを利用すると

plot_grid(glegend1, glegend2, ncol=1)

#こんな感じで並べることができます。
#これを何かの変数に保存して、

leg1to2 <- plot_grid(glegend1, glegend2, ncol=1)

# plot_gridで並べることで、凡例を並べるということができます。
plot_grid(g1to4, leg1to2, nrow=1)

#どうでしょう？ただ、明らかに凡例のスペースが広すぎるので、

plot_grid(g1to4, leg1to2, nrow=1, rel_widths = c(5,1))

#050--------------------------------------------------
#凡例を共通化してみる3 凡例の向き---------------------

#凡例の向きを変えたいときも多々あります。
#たとえば、

g1 + theme(legend.position = "top")
g1 + theme(legend.position = "right")

# では、凡例の表示方向が違います。
#この違いを反映したい場合は、

legend1_side <- 
  get_legend(g1 + theme(legend.position = "top"))

leg1s_2 <- plot_grid(legend1_side, glegend2, nrow=2)

plot_grid(g1to4,leg1s_2, nrow=1, rel_widths= c(10,2))


#こんな風に利用可能です。

#051---------------------------------------
# 画像を表示してみる-----------------------
#少しお絵かきをペイントでしてみましょう

#例えば、細胞の写真等をグラフと並べて
#表示したいようなケースへの対応に
#ついて説明いたします。

#画像の読み込みについては、
#draw_imageという関数を利用しますが、
library(magick) #で、エラーが出た場合は

# install.packages("magick") # を実行してください。

gp <- ggdraw() + draw_image("picture.png")

#これで画像が用意できたので、

plot_grid(gp, g1)

#こんな感じでグラフと画像を表示することができました。


#052---------------------------------------------
#課題--------------------------------------------
#お疲れ様です。
#ここまでで
#　グラフの並べ方
#　ラベルの付け方
#　凡例の抜き出しかたと並べ方
#　画像の並べ方
#をお伝えしました。
#ここでの課題として、
#次のパワーポイントで示す図を
#作れるか試みてみてください
#尚 グラフはg1,g2,g3,g4,gpを利用します。




#















#054------------------------------------------------
#解説：パーツの作成-------------

gL <- g4 + theme(legend.position = "none",
                 plot.margin = unit(c(1,0,0,1),"cm"))

gRtop <- plot_grid(
  g1 + theme(legend.position = "none", 
             plot.margin = unit(c(1,0,0,1),"cm")),
  g2 + theme(legend.position = "none", 
             plot.margin = unit(c(1,0,0,1),"cm")),
  g3 + theme(legend.position = "none", 
             plot.margin = unit(c(1,0,0,1),"cm")),
  nrow=1,
  labels = c("年齢","飲酒","喫煙")
)

gRbottom <- plot_grid(
  get_legend(g4),
  gp,
  get_legend(g1),
  nrow=1,
  rel_widths = c(1,4,1)
)

#右側をまとめてから、左側とくっつけます。

gR <- plot_grid(gRtop, gRbottom, ncol=1, rel_heights = c(3,2))

ggg <- plot_grid(gL, gR, 
                 nrow=1, 
                 rel_widths = c(2,3), 
                 labels = c("飲酒と喫煙の関係",""))
#できあがり！

#どうでしょうか？ここまでで、かなり自由にグラフを作成できるようになった
#と思います。

#本当に細かい調整等は実はパワーポイントを使ってやる方が早いケース
#も多いですが、大量にグラフを作ったり、やり直したりする可能性がある
#場合は、スクリプトで自動生成できるようになると、非常に楽です。

#本動画では紹介しきれていない機能がggplot2やcowplotに
#まだまだたくさんありますが、ここで、基本的な機能の説明はおしまいです。

#続いては、フローチャートの自動生成に挑戦しましょう！