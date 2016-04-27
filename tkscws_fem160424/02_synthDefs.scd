// SuperCollider workshop
// Making cute music and sound for begginers.
// 2016/04/24 Sun at tksc
// 02 SynthDefの記述

■02-01 簡単に、音を出してみる

	{SinOsc.ar(800, 0, 0.5)}.play;

//////////////////////////////////////////////////////////////////////////////////
■02-02 SynthDef

SynthDefは、SynthDefinition（シンセ定義）の略で、ひとつの楽器をつくるようなものです。できあがった１つのSynthDefに外部から、メッセージを送る事で、音を出したり、音の高さ、強さなどの要素を指定することができます。基本的なSynthDefは、「SynthDefの名前、アーギュメント、音源部分、音を出力するOut」から成ります。

書き方：
	SynthDef( \名前, { 　中身　}　).play;

	SynthDef(\sine_wave, { Out.ar(0, SinOsc.ar(800,0,0.5));}).play;


//上と同じコードに改行をいれ、見やすくする
	SynthDef(\sine_wave, // SynthDefの名前
		{
		Out.ar(0, SinOsc.ar(800, 0, 0.5)); // 出力と、その中身の音
		}).play;


よく使う書き方：

// サイン波
	SynthDef(\sinOsc,
		{ arg freq = 440;

		var source;
		source = SinOsc.ar(freq);
		Out.ar(0, source);

	}).play;


// サイン波
	SynthDef(\sine,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;



// 以下はお時間のあるときに...
//////////////////////////////////////////////////////////////////////////////////

■02-03 変数を利用する

( // その中だけで使われるローカル変数

var hotel, transport, expense;

	hotel = 10000; // hotelというハコに10000を入れる
 	transport = 20000; // transportというハコに20000を入れる
 	expense = hotel + transport;
)


// グローバル変数は、いつでも、どこでも使える
~を使って記述するか、小文字の１文字はグローバル変数になる

	a;

	a = 100;
	b = 200;
	a + b;

	~hotel = 5000;
	~transport = 1000;
	~hotel + ~transport ;


// 変数を使い、音の内容が長くなっても、見やすいコードを書く

	SynthDef(\sine_wave, // SynthDefの名前
		{
			var source;
			source = SinOsc.ar(800, 0, 0.5);
			 Out.ar(0, source); // 出力と、その中身の音
		}).store;



	a = Synth(\sine_wave); // sine waveを鳴らす
	a.free; // sine waveを消す

//////////////////////////////////////////////////////////////////////////////////
■02-04 アーギュメントをつかう

	SynthDef(\sine_wave, //SynthDefの名前

		{ arg freq = 440, amp = 0.5;
			// アーギュメント（外からコントロールしたいパラメータ）。名前と初期値。

			var source;

			source = SinOsc.ar(freq);　// 音源

			Out.ar(0, source * amp); // 出力先に音源を割り当て送る

	}).store; // SynthDefを保存



	a = Synth(\sine_wave); // sine waveを鳴らす
	a.free; // sine waveを消す

	アーギュメントである周波数freqや音量ampを指定する
	a = Synth(\sine_wave, [\freq,  220, \amp, 0.3]); // sine waveを鳴らす
	b = Synth(\sine_wave, [\freq,  440, \amp, 0.3]); // sine waveを鳴らす
	c = Synth(\sine_wave, [\freq,  880, \amp, 0.2]); // sine waveを鳴らす
	d = Synth(\sine_wave, [\freq, 1760, \amp, 0.15]); // sine waveを鳴らす

	a.free; // sine waveを消す
	b.free; // sine waveを消す
	c.free; // sine waveを消す
	d.free; // sine waveを消す

//////////////////////////////////////////////////////////////////////////////////

■02-05 エンヴェロープの追加

SynthDefに、エンヴェロープを追加してみます。

	SynthDef(\sine_wave2, //SynthDefの名前

	{ arg freq = 440, amp = 0.5, pan = 0;
		 // アーギュメント（外からコントロールしたいパラメータ）

		var source;

		source = SinOsc.ar(freq) * EnvGen.ar(Env.perc, doneAction:2);　// 音源
		Out.ar(0, source * amp); // 出力先に音源を割り当て送る

	}).store;


	a = Synth(\sine_wave2, [\freq,  440, \amp, 0.5]); // sine waveを鳴らす
	b = Synth(\sine_wave2, [\freq,  880, \amp, 0.5]); // sine waveを鳴らす

	a.free; // sine waveを消す...今はエンヴェロープが終わると、自動に消えるので必要ない
	b.free; // sine waveを消す...今はエンヴェロープが終わると、自動に消えるので必要ない

・主なエンヴェロープの種類 ... Envのヘルプファイルを参照してみる

	Env.perc // パーカッシブなエンヴェロープ
	Env.perc(attackTime, releaseTime, peakLevel, curve)
	Env.adsr // いわるゆADSR型
	Env.adsr(attackTime, decayTime, sustainLevel,  releaseTime, peakLevel, curve)

.test で試聴、.plotで表示することができる。
	Env.perc.test.plot;
	Env.adsr.test.plot;
	Env.perc(0.01, 2, 1, -4).test;
	Env.perc(0.01, 2, 1, -8).test;
	Env.adsr(0.001, 0.5,0.8,1).test;



・gateの利用 ... adsr型のエンベロープを用いる場合は、gateが必要

	SynthDef(\sine_wave3, //SynthDefの名前

	{ arg freq = 440, amp = 0.5, pan = 0, gate = 1; // ゲート

		var source;

		source = SinOsc.ar(freq) * EnvGen.ar(Env.adsr(1, 0.5, 0.7, 2), gate, doneAction:2);
												          // エンベロープにgateをつける
		Out.ar(0, source * amp); // 出力先に音源を割り当て送る

	}).store;


	a = Synth(\sine_wave3, [\freq,  440, \amp, 0.5]); // sine waveを鳴らす
	b = Synth(\sine_wave3, [\freq,  880, \amp, 0.5]); // sine waveを鳴らす

	a.set(\gate, 0); // gateを0にして、リリースする
	b.set(\gate, 0); // gateを0にして、リリースする


■02-05 パンニングの追加

SynthDefに、パンニングを追加してみます。

	SynthDef(\sine_wave2, //SynthDefの名前

		{ arg freq = 440, amp = 0.5, pan = 0; // アーギュメント（外からコントロールしたいパラメータ）
			var source;

			source = SinOsc.ar(freq) * EnvGen.ar(Env.perc, doneAction:2);　// 音源
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp); // 出力先に音源を割り当て送る

	}).store;


a = Synth(\sine_wave2, [\freq,  440, \amp, 0.5, \pan, -1]); // sine waveを鳴らす
b = Synth(\sine_wave2, [\freq,  880, \amp, 0.3, \pan, 1]); // sine waveを鳴らす
