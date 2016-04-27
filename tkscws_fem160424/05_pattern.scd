// SuperCollider workshop
// Making cute music and sound for begginers.
// 2016/04/24 Sun at tksc
// 05 Patternをつかってシーケンスを書く

Patternというクラス群をつかい、シーケンスを書いてみましょう。Pbindには、あらかじめ沢山のパラメータが用意されています。パラメータは常に、パラメータの名前とその値が１セットになっています。
SynthDefでアーギュメントとして指定している場合は、そのパラメータも使う事ができます。

///////////////////////////////////////////////////////////////////////////////////////
■05-01 Pbindを使う

Pbind(
\instrument, \sine_wave2
// instrumentは使用するSynthDefを指定。そのほかの要素はデフォルトの値が適応される。

).play;


// そのほかのパラメータも使ってみましょう。
Pbind(
	\instrument, \sine_wave2,
	\midinote, 67, // 音の高さ ソ
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;

///////////////////////////////////////////////////////////////////////////////////////
■05-02 Pseq, Prand, Pshuf
Pseq( [ 繰り返す中身 ] ,  繰り返す回数)  // infは、無限に繰りかえす、という意味。

	Pbind(
		\instrument, \sine_wave2,
		\midinote, Pseq( [ 67,62,71,67 ], inf), // 音の高さ
		\dur, 0.5,　// 音を出す間隔
		\amp, 0.5　//音の大きさ
	).play;


Pshuf( [ 繰り返す中身 ] ,  繰り返す回数)  //中身を一度シャッフルして再生する

	Pbind(
		\instrument, \sine_wave2,
		\midinote, Pshuf( [ 67,62,71,67 ], inf), // 音の高さ
		\dur, 0.5,　// 音を出す間隔
		\amp, 0.5　//音の大きさ
	).play;

Prand( [ 繰り返す中身 ] ,  繰り返す回数)  //中身をランダムに選ぶ

	Pbind(
		\instrument, \sine_wave2,
		\midinote, Prand( [ 67,62,71,67 ], inf), // 音の高さ
		\dur, 0.5,　// 音を出す間隔
		\amp, 0.5　//音の大きさ
	).play;

///////////////////////////////////////////////////////////////////////////////////////
■05-03 音の高さを記述する方法

// 音の高さの記述方法は、いろいろな種類があります ///////////////////////////
// MIDIノートナンバーとして記述
Pbind(
	\instrument, \sine_wave2,
	\midinote, 67, // 音の高さ ソ
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;

// 周波数として記述
Pbind(
	\instrument, \sine_wave2,
	\freq, Pseq([440, 880],inf), // 音の高さ
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;


// スケールや度数を基本とした記述
// degreeで度数を指定
Pbind(
	\instrument, \sine_wave2,
	\degree, Pseq([0,1,2,3,4,5,6, 7],1), // 音の高さ ... Cのメジャースケール
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;

// rootで基音を指定
Pbind(
	\instrument, \sine_wave2,
	\degree, Pseq([0,1,2,3,4,5,6, 7],1), // 音の高さ ... Gのメジャースケール
	\root, 7,
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;

// scaleでスケールを指定
Pbind(
	\instrument, \sine_wave2,
	\degree, Pseq([0,1,2,3,4,5,6, 7],1), // 音の高さ ... Cのマイナースケール
	\scale, Scale.minor,
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;


// scaleでスケールを指定
Pbind(
	\instrument, \sine_wave2,
	\degree, Pseq([0,1,2,3,4,5,6, 7],1), // 音の高さ ... Cのペンタトニック
	\scale, Scale.majorPentatonic,
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;

// octaveでオクターブを指定
Pbind(
	\instrument, \sine_wave2,
	\degree, 0, // 音の高さ ... Cのペンタトニック
	\octave,  Pseq([5, 6],inf),
	\dur, 0.5,　// 音を出す間隔
	\amp, 0.5　//音の大きさ
).play;


///////////////////////////////////////////////////////////////////////////////////////
■05-04 SynthDefのアーギュメントの利用
// 作ったSynthDefのパラメータを扱う事もできます。

	// Moog VCFのサンプル
	SynthDef(\moogFF_sample2,{arg amp=0.8, decay=0.5, freq=200, pan=0, gain = 2;
		var source;

		source=MoogFF.ar(Saw.ar(freq) , // 音源
						 XLine.kr(10000,1000,0.15),  //フィルタ周波数
						 gain  // フィルタのレゾナンスゲイン（0から4までの値をとる）
					)

		* EnvGen.ar(Env.perc(0.001, decay, 1),doneAction:2);

		Out.ar(0,Pan2.ar(source*amp*3, pan))
	}).store;


	Pbind(
		\instrument, \moogFF_sample,
		\degree, Pseq( [0,4,7], inf), // 音の高さ
		\octave, 3, // オクターブ
		\dur, 1,　// 音を出す間隔
		\amp, 0.5　//音の大きさ
	).play;

	Pbind(
		\instrument, \moogFF_sample2,
		\degree, Pseq( [0,4,7], inf), // 音の高さ
		\octave, 3, // オクターブ
		\dur, 1,　// 音を出す間隔
		\amp, 0.5,　//音の大きさ
		\gain, Pseq([1,2,3],inf), // Moogフィルタのゲイン
		\pan, Pseq([-1,1],inf) // パンニング
	).play;

/////////////////////////////////////////////////////////////////////////////////
■05-05 Pfunc
// 演奏用のパラメータをつくる
// Pfuncと変数を使う

~bassAmp = 1; // 音量をコントロールする為の変数

	Pbind(
		\instrument, \moogFF_sample2,
		\degree, Pseq( [0,4,7], inf), // 音の高さ
		\octave, 3, // オクターブ
		\dur, 1,　// 音を出す間隔
		\amp, 0.5 * Pfunc({~bassAmp}), 　//音の大きさにPfuncをかける
		\gain, Pseq([1,2,3],inf), // Moogフィルタのゲイン
		\pan, Pseq([-1,1],inf) // パンニング
	).play;


~bassAmp = 0; // 0をかける
~bassAmp = 1; // 1をかける

///////////////////////////////////
// 今度はフィルタのGainを変えてみる

~bassGain = 1;

	Pbind(
		\instrument, \moogFF_sample2,
		\degree, Pseq( [0,4,7], inf), // 音の高さ
		\octave, 3, // オクターブ
		\dur, 1,　// 音を出す間隔
		\amp, 0.5 * Pfunc({~bassAmp}), 　//音の大きさ
		\gain, 1 * Pfunc({~bassGain}), // Moogフィルタのゲイン
		\pan, Pseq([-1,1],inf) // パンニング
	).play;

~bassGain = 2;
~bassGain = 2.5;
~bassGain = 3;
~bassGain = 3.5;
