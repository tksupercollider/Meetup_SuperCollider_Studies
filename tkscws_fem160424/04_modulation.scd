// Craftwife's SuperCollider workshop
// 2010/06/13 Sun at Sendai, TRUNK
// 04 UGenで、音をつくる。モジュレーション


モジュレーション
オシレータの周波数（音の高さ）や振幅（音の大きさ）に、他のオシレータを使って時間的な変化を与える事で、より複雑な音色をつくることができます。これはモジュレーションと呼ばれる手法です。まずは、周波数を揺らすFM（frequency modulation）合成をしてみましょう。

//////////////////////////////////////////////////////////////////////////////////////////////////////
■04-01 音の高さの周波数をモジュレートする

	// 普通のサイン波
	SynthDef(\fm_test0,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音の高さをノコギリ波でゆらす。
	SynthDef(\fm_test1,
		{ arg freq = 440, freq2 = 400, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(LFSaw.kr(1, 0, freq, freq2));  // SinOscのfreq部分にSawを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音の高さをパルス波で早くゆらす。
	SynthDef(\fm_test2,
		{ arg freq = 800, freq2 = 800, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(LFPulse.kr(10, 0, 0.5, freq, freq2));   // SinOscのfreq部分にPulseを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音の高さをパルス波で速くゆらす。パルス波の値をXLineで変化させる
	SynthDef(\fm_test3,
		{ arg freq = 800, freq2 = 800, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(LFPulse.kr(10, 0, 0.5, freq, XLine.kr(100,2000,1)));   // SinOscのfreq部分にSawを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音の高さをパルス波で高速にゆらす。パルス波の値をXLineで変化させる
	SynthDef(\fm_test4,
		{ arg freq = 800, freq2 = 800, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(LFPulse.kr(10, 0, 0.5, freq, XLine.kr(100,2000,1)));   // SinOscのfreq部分にSawを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音の高さをパルス波で高速にゆらす。パルス波の値をSaw波で変化させる
	SynthDef(\fm_test5,
		{ arg freq = 800, freq2 = 800, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(LFPulse.kr(10, 0, 0.5, freq, LFSaw.kr(0.5,0,1000,500)));   // SinOscのfreq部分にSawを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

//////////////////////////////////////////////////////////////////////////////////////////////////////
■04-01 音の大きさをモジュレートする
次は、振幅を変化させる、AM（amplitude modulation）です。

	// 普通のサイン波
	SynthDef(\am_test0,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(freq);
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音量をノコギリ波でゆらす。
	SynthDef(\am_test1,
		{ arg freq = 440, freq2 = 400, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(freq, 0, LFSaw.kr(1, 0, 0.5, 0.5));  // SinOscのamp部分にSawを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

	// 普通のサイン波の音量をパルス波でゆらす。
	SynthDef(\am_test2,
		{ arg freq = 800, freq2 = 800, amp = 0.5, pan = 0;
			var source;
			source =  SinOsc.ar(freq, 0, LFPulse.kr(8, 0, 0.5));   // SinOscのfreq部分にPulseを入れる
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;

//////////////////////////////////////////////////////////////////////////////////////////////////////
■04-03 加算する
複数の音を一緒に鳴らす

	// 普通のサイン波
	SynthDef(\add_test0,
		{ arg freq = 440, amp = 0.5, pan = 0;
			var source;
			source =  Saw.ar(freq) + SinOsc.ar(freq/2);  // Sawと低いSinOscを一緒に鳴らす
			source = Pan2.ar(source, pan);
			Out.ar(0, source * amp);
	}).play;



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
■04-04 SynthDefをつくってみよう。
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
■ポイント

・音源になるオシレータを選ぶ
・フィルターやエンヴェロープをかける
・後で使いたいパラメータをargにしておく


SynthDef("perc", {

	arg freq=200, amp=0.5, rq = 0.2;
	var source;
	source = RHPF.ar(Pulse.ar(freq, 0.2), Line.kr(1000,10000,0.1) , rq)
	* EnvGen.kr(Env.perc(0.001,0.22,1,-6), doneAction:2) * 0.5;
	Out.ar(0, Pan2.ar(source*amp, 0));
}).play;


SynthDef(\rbt_bass,{
	arg amp=0.5,  freq=400, filtfreq1 = 10000, filtfreq2=8000, filtertime=0.1, releaseTime= 0.4, pan =0;
		var source;
			source= RLPF.ar(
						LFPulse.ar(freq+1, 0, 0.4) + SinOsc.ar(freq*0.5,2pi,0.6), // RLPFの音源
						Line.kr(filtfreq1, filtfreq2, filtertime), 0.7)　// RLPFのフィルタ周波数とrq
			 * EnvGen.ar(Env([0,1,1,0],[0.001,releaseTime,0.03]),doneAction:2);
		Out.ar(0,Pan2.ar(source*amp,  pan ))
}).play;

SynthDef(\dtk_pulse_chord, {
	arg gate= 1, freq= 800,  amp= 0.5, pan=0;
	var source;
	source = Pulse.ar(freq, XLine.kr(0.1,0.5,0.1)) // パルス波の幅をXlineで変化させる
	 * EnvGen.kr(Env.new([0,1,1,0],[0.0001,0.25,0.05]), gate, doneAction:2);
	Out.ar([0,1], Pan2.ar(source * amp, pan));

}).play;


SynthDef(\dtk_hats,
	{arg freq = 600,  amp = 0.1, releaseTime=0.1, rq =0.8, pan =0;
	var source;
	source = RHPF.ar(WhiteNoise.ar(1), freq, rq)
	* EnvGen.ar(Env.perc(0.0001, releaseTime, 1, -4), 1.0, doneAction: 2);
	Out.ar(0, Pan2.ar(source * amp, pan))
}).play;


	