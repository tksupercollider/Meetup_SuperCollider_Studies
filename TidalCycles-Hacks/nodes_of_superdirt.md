# [SuperDirt] SuperDirt の Nodeについて

~Orbit, GrobalEffect, Synth Group~

SuperDirtを立ち上げると以下のようなNodeツリーが作られます。それぞれの役割がなんなのか気になって調べて見ました。

```
NODE TREE Group 0
  1 group
    3 group
    1005 dirt_delay2
    1004 dirt_reverb2
    1003 dirt_monitor2
    2 group
    1002 dirt_delay2
    1001 dirt_reverb2
    1000 dirt_monitor2
```

ツリーをダンプして見て見ます。

![image](https://cldup.com/aySqDUxpID-2000x2000.png)
図にした。

処理はツリーのノードの枝の先頭から下へと処理が流れていきます(ノードID順ではない)
これをみるとSuperDIrtの処理の流れが大体想像がつきそうです。

## Orbit

`group1` 以下に`group2`, `group3` の二つのグループが追加されています、これがそれぞれOrbitのグループになっています。
コンソールの表示では `group3`  が上に見えていますが、おそらく追加を先頭指定にしてあるのでしょう。手元の環境ではOrbit `0` が `group2` Orbit `1` が `group3`に対応しているようでした。TIdal側で`orbit`を指定して見てどちらに追加されるか確かめて見るとわかります。

## Global Effects

Oribtのグループにはそれぞれ3つのSynth Node追加されます。
`dirt_delay2` , `dirt_reverb2`, `dirt_monitor2`が追加されています。名前からそれぞれの役割が推測出来ますね。
末尾`2`というのはチャンネル数でSuperDirt初期化の時に挿入されます。
monitor というのは音量の調整とOutBusの管理を行うそうです。

## Sample プレイバック の Node

さてそれではTidak側でコードを書いてシンセが鳴ったとしてどういうツリー構造になっているのか見てみます。

```
d1 $ s "bd"
```

```
NODE TREE Group 0
  1 group
    3 group 
      1005 dirt_delay2
      1004 dirt_reverb2
      1003 dirt_monitor2
      2 group
        1089 group
          -1344 dirt_sample_2_2
          -1352 dirt_gate2
      1002 dirt_delay2
      1001 dirt_reverb2
      1000 dirt_monitor2
```

図にすると、

![image](https://cldup.com/bb5ROhSf90-3000x3000.png)
Oribt `0` だけ抜き出すとこんな状態。

新しくOribtのグループの下に`dirt_sample_2_2` と `dirt_gate2`というSynth Nodeが追加された `group`が追加されています。このグループは`synthGroup` と言ってパターン内に登場するSynthごとに逐一生成されます。`dirt_sample`というのがサンプルのプレイバックを行うSynth Nodeですね。`dirt_gate` というのはエンベロープや `cut`パターンの影響を管理するSynth Nodeです。

まず最初の`group2`の枝を辿って synthGroup の`group`、その枝の `dirt_sample` そして `dirt_gate2`、
その後で三つの Global Effect という順に通っていきます。

## モジュールを加える

エフェクトのモジュールを加えるとどうなるでしょうか。試しに`vowel`を追加して見ます。

```
d1 $ s "bd" |+| vowel "a"
```

```
NODE TREE Group 0
  1 group
    3 group
    1005 dirt_delay2
    1004 dirt_reverb2
    1003 dirt_monitor2
    2 group
      4679 group
        -58800 dirt_sample_2_2
        -58808 dirt_vowel2
        -58816 dirt_gate2
    1002 dirt_delay2
    1001 dirt_reverb2
    1000 dirt_monitor2
```

エフェクトモジュール`vowel`が追加された状態。

![image](https://cldup.com/4bNRBxEF74-3000x3000.png)
`dirt_sample_2_2`と `dirt_gate2`の間に `dirt_vowel2` というNodeが追加されました。

## 複数のストリームの場合

別のストリームで同時にシンセがなっている場合どのようになるでしょうか。

```
do
  d1 $ s "hh"
  d2 $ s "bd"
```

```
NODE TREE Group 0
  1 group
    3 group
    1005 dirt_delay2
    1004 dirt_reverb2
    1003 dirt_monitor2
    2 group
      1022 group
        -272 dirt_sample_2_2
        -280 dirt_gate2
      1023 group
        -288 dirt_sample_1_2
        -296 dirt_gate2
    1002 dirt_delay2
    1001 dirt_reverb2
    1000 dirt_monitor2
```

![image](https://cldup.com/Hz2XZ5pgHN-3000x3000.png)

同じOrbit `0` で鳴らしている分には同じ`group2`に追加されます。

## stackの場合

```
d1 $ stack [
  (s "hh"),
  (s "bd")
]
```

```
NODE TREE Group 0
  1 group
    3 group
    1005 dirt_delay2
    1004 dirt_reverb2
    1003 dirt_monitor2
    2 group
      1355 group
        -5600 dirt_sample_2_2
        -5608 dirt_gate2
      1356 group
        -5616 dirt_sample_1_2
        -5624 dirt_gate2
    1002 dirt_delay2
    1001 dirt_reverb2
    1000 dirt_monitor2
```

こちらも同じように、パターンに `orbit` が指定されていない限り同じような追加のされ方です(図的には上のものと同じなので割愛)

## まとめ

- SuperDIrt では Orbit ごとに Group が作られ, それぞれに 3つの Global Effects が追加されます。

- パターンに登場するSynthごとに synthGroup が作られ Global Effects の手前に挿入されていきます。

- エフェクトを加えると synthGroup の中の `dirt_sample` `dirt_gate` の間に挿入されていきます。

処理の順序を理解していると、適切なエフェクトのかけ方など音づくりにも役にたつかもしれません。
