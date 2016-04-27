// SuperCollider workshop
// Making cute music and sound for begginers.
// 2016/04/24 Sun at tksc
// 03 UGenで、音をつくる。オシレータ、フィルタ

SCには、ユニット・ジェネレータ（UGen）と呼ばれるクラス群が、豊富に用意されています。サードパーティで制作されたクラスを追加するほか、プログラミングに慣れている人なら、自分でUGenを作ることもできます。
UGenには、オシレータ、エンベロープ、フィルターといったアナログシンセイサイザーに搭載されているようなものから、オーディオの入出力や、解析、FFTやマルチチャンネルに関するものなど、様々な種類が用意されています。これらを組み合わせ、コーディングすることで、自分だけの音を作ることができます。ここでは、SCに付属している数百種類のUGenを使って、音を作ってみましょう。

■03-01 さまざまなUgen
ヘルプファイルが用意されているので、それを実行して、音を聴いてみると良いでしょう。

SC > Help > Ugens >
					Noise
					Oscillators
					Filters
					Pan

////////////////////////////////////////////////////////////
// 基本的なオシレータ
	// サイン波
	SynthDef(\sine,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// パルス波
	SynthDef(\pulse,
		{ arg freq = 440, amp = 0.5, pan = 0, width = 0.5;
			var source;
			source =  Pulse.ar(freq, width);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// ノコギリ波
	SynthDef(\saw,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  Saw.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;



////////////////////////////////////////////////////////////
// 低周波のオシレータ
	// 低周波のノコギリ波
	SynthDef(\lfwas,
		{ arg freq = 44, amp = 0.5, pan = 0, width = 0.5;
			var source;
			source =  LFSaw.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 低周波のパルス波
	SynthDef(\lfpulse,
		{ arg freq = 44, amp = 0.5, pan = 0, width = 0.5;
			var source;
			source =  LFPulse.ar(freq, width);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

////////////////////////////////////////////////////////////
// ノイズ系のオシレータ
	// ホワイトノイズ
	SynthDef(\whitenoise,
		{ arg amp = 0.3, pan = 0;
			var source;
			source =  WhiteNoise.ar(1);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// ブラウンノイズ
	SynthDef(\brownnoise,
		{ arg amp = 0.3, pan = 0;
			var source;
			source =  BrownNoise.ar(1);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);る
	}).play;


	// ダスト、ランダムなインパルスを出力
	SynthDef(\dust,
		{ arg amp = 0.3, pan = 0, density = 10;
			var source;
			source = Dust.ar(density);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);る
	}).play;

	// クラクル
	SynthDef(\brownnoise,
		{ arg amp = 0.3, pan = 0;
			var source;
			source =  Crackle.ar(1.9);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);る
	}).play;


	// ステップ・ノイズ
	SynthDef(\lfnoise0,
		{ arg amp = 0.3, pan = 0, freq = 500;
			var source;
			source =  LFNoise0.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);る
	}).play;

////////////////////////////////////////////////////////////
// ちょっと変わったオシレータ

	// クセナキスのシュミレート ... see helpfile
	SynthDef(\gendy,
		{ arg amp = 0.3, pan = 0, freq = 500;
			var source;
			source =  Gendy1.ar;
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);る
	}).play;

	// サインオシレータのバング
	SynthDef(\klang,
		{ arg amp = 0.1, pan = 0;
			var source;
			source =  Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 音作りにちょっと便利なUgen ... （時間的な）変化を加える。

// LineとXLine
	// サイン波
	SynthDef(\sine_Xline,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(XLine.kr(100, 1000,1));//100から1000まで1秒間で変化する
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	SynthDef(\sine_Line,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(Line.kr(100, 1000,1));//100から1000まで1秒間で変化する
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

// MouseXとMouseY
	SynthDef(\sine_mouse,
		{ arg amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(MouseX.kr(50,1000),0,MouseY.kr(1.0,0.0));
						// MouseのX座標を50から1000に割り当てる
						// MouseのY座標を1.0から0,0に割り当てる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;


/////////////////////////////////////////////////////////////
// 基本的なフィルター
// フィルターは入力された音に対して、なんらかの処理をするもの。

	// ローパスフィルタ
	SynthDef(\lpf,
		{ arg freq = 440, amp = 0.5, pan = 0, filter_freq = 800;
			var source;
			source =  LPF.ar(Saw.ar(freq), filter_freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// ハイパスフィルタ
	SynthDef(\hpf,
		{ arg freq = 440, amp = 0.5, pan = 0, filter_freq = 800;
			var source;
			source =  HPF.ar(Saw.ar(freq), filter_freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// ハイパスフィルタとXLine
	SynthDef(\hpf_Xline,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  HPF.ar(Saw.ar(freq), XLine.kr(1000,10000,1));
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;


	// バンドバスフィルタ ... 特定の周波数の音を通す。rqが必要になる。
	SynthDef(\resonz,
		{ arg freq = 440, amp = 0.5, pan = 0, filter_freq = 2000, rq = 0.05;
			var source;
			source =  Resonz.ar(WhiteNoise.ar, filter_freq, rq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// レゾナント・ローパスフィルタ
	SynthDef(\rlpf,
		{ arg freq = 440, amp = 0.5, pan = 0, filter_freq = 800, rq =0.1;
			var source;
			source =  RLPF.ar(Saw.ar(freq), filter_freq,rq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// レゾナント・ハイパスフィルタ
	SynthDef(\rhpf,
		{ arg freq = 440, amp = 0.5, pan = 0, filter_freq = 800, rq =0.1;
			var source;
			source =  RHPF.ar(Saw.ar(freq), filter_freq, rq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;



////////////////////////////////////////////////////////////
// ちょっと変わったフィルタ
	// Moog VCF
	SynthDef(\moogF,
		{ arg freq = 440, amp = 0.5, pan = 0, filter_freq = 12000, gain = 3.5;
			var source;
			source =  MoogFF.ar(Saw.ar(freq), filter_freq, gain);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// Moog VCFのサンプル
	SynthDef(\moogFF_sample,{arg amp=0.8, decay=0.5, freq=200, pan=0;
		var source;

		source=MoogFF.ar(Saw.ar(freq) , // 音源
						 XLine.kr(10000,1000,0.15),  //フィルタ周波数
						 Line.kr(3.2, 1, 0.2)   // フィルタのレゾナンスゲイン（0から4までの値をとる）
					)

		* EnvGen.ar(Env.perc(0.001, decay, 1),doneAction:2);

		Out.ar(0,Pan2.ar(source*amp*3, pan))
	}).play;

	//bass sample
	Pbind(
		\instrument,\moogFF_sample,
		\degree, Pseq([0,4,7],inf),
		\dur, Prand([0.25,0.5],inf),
		\octave, 3,
		\tempo, 2,
		\amp, 0.8
	).play;


	// Klank ... レゾネータのバンク
	Klank.ar(`[ 周波数のリスト ,  音量のリスト またはnil,  フィルタの時間のリスト], 音源)

	SynthDef(\klank,
		{ arg freq = 440, amp = 0.5, pan = 0, gain = 3.5;
			var source;
			source =   Klank.ar(`[[freq, freq*2+1, freq*4+1, freq*8+1], nil, [1, 1, 1, 1]], PinkNoise.ar(0.01))
			 * EnvGen.ar(Env.perc(1, 3, 1),doneAction:2);
			Out.ar(0, Pan2.ar(source * amp, pan) );
	}).play;


	Pbind(
		\instrument,\klank,
		\degree, Pseq([0,2,4,6],inf),
		\dur, 1,
		\octave, Prand([3,4,5,6],inf),
		\tempo, 2,
		\amp, 0.8,
		\pan, Pseq([0.5,-0.5],inf)
	).play;