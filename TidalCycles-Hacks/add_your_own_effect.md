# "[TidalCycles] Add your own effect 自分のエフェクトを加える"

TidalCyclesのSuperColliderのエンジンSuperDirtには、サンプルだけではなく独自のシンセを楽器として加えたり、エフェクトを追加したりはたまたカスタムイベントをブリッジしたりSuperColliderの柔軟性を活かした'Hack'が存在します。ライブラリパッケージの `hacks/` フォルダには様々なハックの方法を紹介するドキュメントを見つけることができます。

その中のTidalのパラメータを追加して自前のエフェクトを作る方法を紹介します。
[`hacks/adding-effects.scd`](https://github.com/musikinformatik/SuperDirt/blob/master/hacks/adding-effects.scd)というドキュメントに例として`spectral-delay`というエフェクトを追加するサンプルコードが紹介されています。

コメントで追加の手順が示されていますが、やることは三つです。

> 1. add the desired parameters to Tidal, so it can be used
> 2. add a module definition to Superdirt, so it can be found when the parameter is not nil
> 3. add the synth def to SuperDirt, so it can be played

1. Tidalでパラメータとして使用できるようにHaskellのコードを追加する。
2. SuperDirt側にモジュール追加しパラメータが使用できるようにする。
3. SuperDirtにエフェクトのSynthを定義する。

## 1 Tidalのパラメータを加える

Tidal側でHaskellコードでパラメータを追加します。
サンプルではライブラリ内 [`Sound/Tidal/Params.hs`](https://github.com/tidalcycles/Tidal/blob/master/Sound/Tidal/Params.hs) に加えると指示がありますが、
編集後に再度ライブラリをコンパイルする必要が出てきてしまうのでその次のコメントアウトの `// ... or you can run this in the interpreter:` の方法を今はお勧めします。

Tidalのブート後に以下のコードを実行します。
エディタでブート後`let`で始まっている二つのブロックをそれぞれ実行します。

```
let tsdelay = make' VF tsdelay_p
    tsdelay_p = F "tsdelay" Nothing

let xsdelay = make' VI xsdelay_p
    xsdelay_p = I "xsdelay" Nothing
```

ライブラリを直接騙取する場合、TidalCyclesライブラリ内 `Sound/Tidal/Params.hs` に以下のコードを加えます。末尾に追加するのがいいでしょう。その後cabalコマンドでパッケージを際コンパイルします。

```
tsdelay :: Pattern Double -> ParamPattern
tsdelay = make' VF tsdelay_p
tsdelay_p = F "tsdelay" Nothing

xsdelay :: Pattern Int -> ParamPattern
xsdelay = make' VI xsdelay_p
xsdelay_p = I "xsdelay" Nothing
```

Haskellコードの文法については今はまだ詳しく理解しなくて良いでしょう。
大事なのはTidalのパラメータとして`tsdelay` `xsdelay`の二つをパラメータをここで追加していることです。

それぞれのパラメータに与える引数の値の型もここで指定されています。
`Pattern Double`・`make' VF`・`I` / `Pattern Int`・`make' VI`・`F` という組み合わせに注目してください、前者は Double の浮動小数点数値のパターン、 後者は Int 整数値のパターンを引数に受けるパラメータを追加しています。

つまり`tsdelay` は Pattern Double を `xsdelay` は Pattern Int を引数に取るようになります。

これでTidalのコードからエフェクトのパラメータとして使えるようになります。
Tidalで使う時にはおそらく以下のようなコードになるでしょう

```d1 $ sound "bd*4" |+| tsdelay "0.4"```

```d1 $ sound "bd*4" |+| xsdelay "1"```

自分はライブラリを直接編集したくは無い＆再コンパイルしたくないのでこの部分を.hsファイルとして分けておいて、Tidalのブート時にHaskellのモジュールをロードする方法で使っています。この方法についてはまた別の機会に解説したいです。

## 2 SuperDirtにモジュールを追加する

次にSuperDirt側でmoduleと呼ばれる設定を定義します。これによってTidalで生成されたパラメータがSuperDirでエフェクトのシンセに適切にマップされます。

このコードと次の`3`の手順のコードはSCドキュメントで保存してブート時に実行するようにします。
とりあえず今は`external_effect.scd`などとして保存しておきます。ブート時に実行する方法は後ほど解説します。

```
(
~dirt.addModule('spectral-delay', { |dirtEvent|
  dirtEvent.sendSynth('spectral-delay' ++ ~dirt.numChannels,
    // OPTIONAL
    // passing this array of parameters could be left out,
    // but it makes it clear what happens
    [
      xsdelay: ~xsdelay,
      tsdelay: ~tsdelay,
      sustain: ~sustain,
      out: ~out
    ]
  )
}, { ~sdelay.notNil or: { ~xsdelay.notNil } }); // play synth only if at least one of the two was given
)
```

`~dirt`はSuperDirtをブートした時にSuperDirtのグローバルオブジェクトが割り当てられています。
ですのでこの手順と次の`3`の手順のコードはSuperDirtをブートした後に実行しなければいけません。

重要なのは`~dirt.addModule`の最初の引数、`'spectral-delay'`、これは作成するモジュールの名前で後で使用します。任意の文字列でユーザーが定義できます。わかりやすい名前にしましょう。また`.sendSynth()`関数での第一引数 `'spectral-delay' ++ ~dirt.numChannels` にも同じ名前でシンセの名前を指定します。

もう一つは第二引数の中のリストです。ここに列挙したパラメータがSynthの引数に渡ってくるようになります。

```
[
    xsdelay: ~xsdelay,
    tsdelay: ~tsdelay,
    sustain: ~sustain,
    out: ~out
]
```

今回自分で定義するパラメータ以外にも、Synthの中で使用するものは加えておきます。例えば`out`パラメータはデフォルトのパラメータで大体のエフェクトで使用することになります。`sustain `もデフォルトのパラメータです。

<del datetime='2017-07-01T23:38-07:00'>内部的な処理の話になりますが、ここに列挙されているパラメータがOSC渡ってきます</del> *1

`.addModule`の第二引数にFunctionのブラケットでシンセが適用される条件を定義します。
この条件が揃った時に、でエフェクトのノードが楽器のシンセとグローバルミキサーとの間に差し込まれてエフェクトがかかります。

`{ ~sdelay.notNil or: { ~xsdelay.notNil } }`

サンプルでは上のようになっています。この場合 `tsdelay` `xsdelay` のどちらか一方でもパラメーターが渡ってきた場合にエフェクトが追加されます。

最後にモジュールの順番を指定します。この設定はオプショナルです。

```
// here you can see the effect order:
~dirt.modules;

// OPTIONAL: you can reorder the effects, if you want e.g. the lpf to come after the delay:
~dirt.orderModules(['spectral-delay', 'hpf', 'klm']);
```

楽器のエフェクターを思い出してください。エフェクターでは信号を通す順番が重要です。SuperDirtのオーディオ信号処理でも通ってくるエフェクターの順番で最終的な出音は全く違うものになります。ここでは`.orderModules()` でリストを渡して順番を指定できます。

*1このリストは任意とコメントにあるので省略可能？リストにないと引数で渡って来なくなるのか要検証。

## 3 エフェクトシンセを追加する

最後にSuperDirt側でエフェクトのシンセを追加します。

```
// (3) make a synthdef (for more examples see core-synths)
(

var numChannels =  ~dirt.numChannels;

SynthDef("spectral-delay" ++ numChannels, { |out, tsdelay, xsdelay = 1, sustain|

  var signal, delayTime, delays, freqs, filtered;
  var size = 16;
  var maxDelayTime = 0.2;

  signal = In.ar(out, numChannels);
  delayTime = tsdelay * maxDelayTime;
  filtered = (1..size).sum { |i|
    var filterFreq = i.linexp(1, size, 40, 17000);
    var sig = BPF.ar(signal, filterFreq, 0.005);
    // the delay pattern is determined from xsdelay by bitwise-and:
    DelayN.ar(sig, maxDelayTime, i & xsdelay * (1/size) * delayTime )
  };
  signal = signal * 0.2 + (filtered * 4); // this controls wet/dry
  ReplaceOut.ar(out, signal)

}).add;
)
```


- `"spectral-delay" ++ numChannels` というシンセの名前が先ほどのモジュールの宣言と同じになっています。

- 先ほどリストで列挙したパラメータを引数に持っています。

- `ReplaceOut.ar` でアウトチャンネルを `out` パラメータで指定しています。

守ることは以上で、他は自由にデザインできるようです(本質的には全て自由ですが)

変数 `numChannels` は SuperDirt をブートした時のチャンネル数を参照しています。シンセの名前以外にも `In.ar` のチャンネル数などに使われて重要そうなのでブート時に一度 SuperDirt のグローバルオブジェクトから取得するのが良さそうです。


## bootする

それぞれ手順を踏んだら Tidal と SuperDirt の起動です。

Tidal はライブラリに手を加えた場合はそれぞれのエディタ環境でブートします。 パラメータを追加するコードを実行した場合はすでにブートできていると思います。

エラーなく boot できたら次は SuperCollider 側で SuperDirt を起動します。

その前に、ブート後に先ほどのscdに書いたコードを実行したいので、`waitForBoot{}` でサーバのブート完了をフックして処理させるようにしておきましょう。

ファイルのパスの文字列に `.load` コマンドでscdファイルを指定して実行できます。

その後 `SuperDirt.start` でブートさせるようにします。

```
(
s.waitForBoot{
  "/your/path/to/external_effect.scd".load;
};

SuperDirt.start(2, s);
)
```

（`"/your/path/to/external_effect.scd"`の部分をそれぞれ先ほど保存した scd のパスに）


もちろんファイルに保存しなくても、先ほどのコードをエディタで選択して実行して行っても同じです。

以上でエフェクトを使えるようになったと思います。あとは独自のエフェクトを追加して豊かなサウンドにしていってください。


以降は私が追加したエフェクトをいくつか紹介します。

## Wah

`wah` : ワウペダル風、引数の値はローパスフィルタのfreqにかけるノイズの頻度。`cuttoff`と違い一回のシンセの中で変化がある。

parameter :

```
wah :: Pattern Double -> ParamPattern
wah = make' VF wah_p
wah_p = F "wah" (Just 0.25)
```

module :

```
~dirt.addModule('wah', { |dirtEvent|
  dirtEvent.sendSynth('wah' ++ numChannels,
    [
      out: ~out,
      wah: ~wah
    ]
  )
}, { ~wah.notNil });
```

synth :

```
var numChannels =  ~dirt.numChannels;

SynthDef("wah" ++ numChannels, { arg out, pan = 0, wah = 0;
  var index, in, mix, signal;
  index = Amplitude.kr((wah.ceil).clip(0,1));
  in = In.ar(out, 2);
  mix = RLPF.ar(in, LFNoise2.kr(wah.linexp(0, 1.0, 0.8, 40), 40, 84).midicps, 0.2);
  signal = Select.ar(index, [in, mix]);
  ReplaceOut.ar(out, Pan2.ar(signal, pan));
}).store;
```



## BinScramble

`binscr` : FFTの `PV_BinScramble` を使ったエフェクト、ちょっと音が荒れる。引数の値はミックスレート。

parameter :

```
binscr :: Pattern Double -> ParamPattern
binscr = make' VF binscr_p
binscr_p = F "binscr" (Just 0)
```

module :

```
~dirt.addModule('binscramble', { |dirtEvent|
  dirtEvent.sendSynth('binscramble' ++ numChannels,
  [
    out: ~out,
    bscr: ~binscr
  ]
  )
}, { ~binscr.notNil });
```

synth :

```
var numChannels =  ~dirt.numChannels;

SynthDef("binscramble" ++ numChannels, { arg out, pan = 0, binscr = 0;
  var signal, chain, chain_r, lfo, lfo2, trig;
  signal = In.ar(out, numChannels) * 1.2;
  chain = FFT(LocalBuf(2048), signal[0]);
  chain_r = FFT(LocalBuf(2048), signal[1]);
  lfo = LFNoise2.kr(4).abs;
  lfo2 = LFNoise2.kr(2).abs;
  trig = Impulse.kr(32);
  chain = PV_BinScramble(chain, lfo, lfo2, trig);
  chain_r = PV_BinScramble(chain_r, lfo, lfo2, trig);
  ReplaceOut.ar(out, Pan2.ar((signal * (1.0 - binscr)) + (binscr * [IFFT(chain), IFFT(chain_r)]), pan));
}).add;
```

## BinShift

`binshf` : FFTの `PV_BinShift` によるピッチベンド。引数の値はミックスレート。stretch の値はとりあえず `MouseX` にしている、パラメータ与えてもよいかも。

parameter :

```
binshf :: Pattern Double -> ParamPattern
binshf = make' VF binshf_p
binshf_p = F "binshf" (Just 0)
```

module :

```
~dirt.addModule('binshift', { |dirtEvent|
  dirtEvent.sendSynth('binshift' ++ numChannels,
    [
      out: ~out,
      binshf: ~binshf
    ]
  )
}, { ~binshf.notNil });
```

synth :

```
var numChannels =  ~dirt.numChannels;

SynthDef("binshift" ++ numChannels, { arg out, pan = 0, binshf = 0;
  var signal, chain, chain_r, stretch;
  signal = In.ar(out, numChannels) * 1.2;
  chain = FFT(LocalBuf(2048), signal[1]);
  chain_r = FFT(LocalBuf(2048), signal[0]);
  stretch = MouseX.kr(0.25, 4, \exponential);
  chain =  PV_BinShift(chain, stretch);
  chain_r =  PV_BinShift(chain_r, stretch);
  ReplaceOut.ar(out, Pan2.ar((signal * (1.0 - binshf)) + (binshf * [IFFT(chain), IFFT(chain_r)]), pan));
}).add;

```


## BinFreeze

`binfrz` : FFT の `PV_MagFreeze` を使ったフリージング。引数の値はミックスレート。`MouseY` でコントロール。とりあえず画面の上半分に行ったらフリーズするようになってる。

parameter :

```
binfrz :: Pattern Double -> ParamPattern
binfrz = make' VF binfrz_p
binfrz_p = F "binfrz" (Just 0)
```

module :

```
~dirt.addModule('binfreeze', { |dirtEvent|
  dirtEvent.sendSynth('binfreeze' ++ numChannels,
    [
      out: ~out,
      binfrz: ~binfrz
    ]
  )
}, { ~binfrz.notNil });
```

synth :

```
var numChannels =  ~dirt.numChannels;

SynthDef("binfreeze" ++ numChannels, { arg out, pan = 0, binfrz = 0;
  var signal, chain, chain_r, freeze;
  signal = In.ar(out, numChannels) * 1.2;
  chain = FFT(LocalBuf(2048), signal[0]);
  chain_r = FFT(LocalBuf(2048), signal[1]);
  freeze = MouseY.kr;
  chain = PV_MagFreeze(chain, freeze > 0.5);
  chain_r = PV_MagFreeze(chain_r, freeze > 0.5);
  ReplaceOut.ar(out, Pan2.ar((signal * (1.0 - binfrz)) + (binfrz * [IFFT(chain), IFFT(chain_r)]), pan));
}).add;
```


## Convolution

`conv` : Convolution を使ったフィルター。kernel に `LFPulse` を使っているがここをもっと工夫して違う音色にしたいところ。

parameter :

```
conv :: Pattern Double -> ParamPattern
conv = make' VF conv_p
conv_p = F "conv" (Just 0) 
```

module :

```
~dirt.addModule('convolution', { |dirtEvent|
  dirtEvent.sendSynth('convolution' ++ numChannels,
    [
      out: ~out,
      conv: ~conv
    ]
  )
}, { ~conv.notNil });
```

synth :

```
var numChannels =  ~dirt.numChannels;

SynthDef("convolution" ++ numChannels, { arg out, note, pan = 0, conv = 0;
  var in, karnel, mix;
  karnel = LFPulse.ar((note + 60).midicps, 0.0, 0.15, 0.2) + Impulse.ar((note + 60).midicps, 0.0, 0.4);
  in = In.ar(out, numChannels);
  mix = [Convolution.ar(in[0], karnel, 1024, 0.5), Convolution.ar(in[1], karnel, 1024, 0.5)];
  ReplaceOut.ar(out, Pan2.ar((in * (1.0 - conv)) + (conv * mix), pan));
}).add;
```
