//TokoySuperCollider #8


//サウンドファイル

//サウンドファイルを扱うにはBufferを使います。
//サウンドファイルはsounds/以下におくのが良いでしょう。


b = Buffer.new(s);//サーバにバッファを作ります
b.allocRead("sounds/a11wlk01.wav");//サウンドファイルを割り当てます。

x = { PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum), loop: 1) * 0.5 }.play;
x.free; b.free;





//TGrains
//グラニューラシンセシスのためのUGen


s.sendMsg(\b_allocRead, 10, "sounds/a11wlk01.wav");


(
{
	var b = 10, trate, dur, rate;
	trate = MouseY.kr(2,200,1);
	dur = 4 / trate;
	rate = 1;
	TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 1, 2);
}.play;
)







______________________


//フィルター／エフェクト
//スーパーコライダーでは既に様々なフィルターがUGenとして用意されています。
//エフェクトと言っても様々です。エフェクトを作る場合大切なのはそれぞれのUGenがどういった波形処理しているのか
//波形のレベルの変化やその処理の順番などをよく知っておく事です。
//同じエフェクトでもここに記した以外に様々な方法があるので各自研究してください。

//ローパス／ハイパス／バンドパスフィルター
{ LPF.ar( WhiteNoise.ar(0.3), 1200 ) }.play;
{ HPF.ar( WhiteNoise.ar(0.3), 7200 ) }.play;
{ BPF.ar( WhiteNoise.ar(0.3), 3000 ) }.play;

{ Resonz.ar( WhiteNoise.ar(0.3), 9000, 0.2 ) }.play;
{ RLPF.ar( WhiteNoise.ar(0.3), 1200, 0.2 ) }.play;
{ RHPF.ar( WhiteNoise.ar(0.3), 7200, 0.2 ) }.play;



//ディストーション／歪み
//ディストーションなどの歪みは振幅を多くしてそれを適切なレベルでクリップさせると得られます。波形の山をカットするイメージです。

{ SinOsc.ar(440,0,0.4).distort }.play;
{ SinOsc.ar(440,0,0.4).softclip }.play;
{ SinOsc.ar(440,0,0.8).clip(-0.3,0.3) }.play;
{ ( SinOsc.ar(440,0.5,0.4) * 220 ).softclip * 0.1 }.play;


//ディレイ・リバーブ／空間系
//ディレイはその名の通り波形を時間軸に遅らせる事です。遅らせた波形を原音に重ることでリバーブやコーラスが得られます。

(
{
	z = Decay.ar(Impulse.ar(1,0.3), 0.3, WhiteNoise.ar(0.5));
	z + DelayC.ar(z, 0.2, 0.2);
}.play
)



//リバーブはディケイタイムをずらしたディレイ波形を重ねてゆくと得られる
(
{
	z = SinOsc.ar(LFNoise0.kr(4,1200,400).abs,0,0.6) * Decay2.ar(Dust.ar(1), 0.01,0.2);//元の波
	w = 4.do({ z = AllpassC.ar(z, 0.1, Rand(0.01,0.04), 3) });//Decay Time 0.01~0.04の間のランダム値を与えての直列に四回Allpass Delayを通して重ねる
	w  +  z;
}.play
)


//コーラスはディケイタイムをずらすのにlfoを使っている
(
{
	z = Pulse.ar(750,0.5,0.3) * SinOsc.ar(200,0,0.3);//元の波
	w = 2.do({ z = CombL.ar(z, 0.1, LFNoise2.kr(0.1,0.04,0.1).abs, 1) });//Decay Time にLow Frequency Noise(lfo) ＊ゼロクロスしないようにadd:0.05と.abs
	z + w;
}.play
)


//see also [ Tour_of_UGens ]...







______________________


//エンベロープ
//音は時間軸上での変化です。
//一つの音の時間軸上での変化には、音色とそしてエンベロープがあります。

//サイン波にエンべロープをかけみます。

//EnvGenというUGenを使います。
s.boot;
x={ SinOsc.ar(440,0,0.3) * EnvGen.ar(Env.linen) }.play;


//Envといのはエンペローブを整形してくれるクラスです。
//.linenは台形のエンペローブです。

//ローカルサーバウィンドウのSynthsを見てください。1のままです。音は出ていませんがシンセが生成されたまままだ処理が続いています。

//音を止めましょう。
x.free;

//エンベロープが終わったタイミングでシンセを消去したいので、
//doneActionというアーギュメントを”2”で埋めます。
x={ SinOsc.ar(440,0,0.2) * EnvGen.ar( Env.linen, doneAction:2 ) }.play

//エンベロープが終わるとシンセが消去されます。






//.testでサイン波で確かめる事ができます。さらに.plotでグラフを表示できます。

Env.linen(1, 2, 3, 0.6).test.plot;

//その他の
//Envメソッド
Env.new([0, 1, 0.3, 0.8, 0], [2, 3, 1, 4], -2).test.plot;
Env.triangle(1, 1).test.plot;
Env.sine(1,1).test.plot;
Env.perc(0.05, 1, 1, -4).test.plot;
Env.asr(0.02, 0.5, 1, 1, -4).test.plot;
Env.adsr(0.02, 0.2, 0.25, 1, 1, -4).test.plot;
Env.dadsr(0.5,0.02, 0.2, 0.25, 1, 1, -4).test.plot;
Env.cutoff(1, 1, 4).test.plot;
______________________


//Decay UGen

//トリガーを使ったエンべロープ

(
{var trig;
	trig=Impulse.kr(2);
	SinOsc.ar(400,0,0.3)
	*Decay.kr(trig,0.2)//Decay UGen
}.play;
)

(
{var trig;
	trig=Impulse.kr(1);
	SinOsc.ar(400,0,0.3)
	*Decay2.kr(trig,0.001,1)//Decay UGen
}.play;
)


______________________




//マルチチャンネル


//SuperColliderではオーディオシグナルのチャンネルをBus(バス)と呼ばれるは0~128までの整数で管理しています。
//Bus(バス)にはコントロールバス、オーディオバス、インプット／アウトプットバスなどあります。がここではオーディオバスについて触れます。


//基本的に1チャンネルごとに1プロセスをあたえなくてはいけません。
{SinOsc.ar(440,0,0.3)}.play;

//Lチャンネルしか鳴りません。


{SinOsc.ar(440,0,0.3).dup}.play;
//LR同じシグナルが鳴ります。.dupはオブジェクトをコピーしてくれます。



//List

//UGenの中ではListはそれぞれ違ったチャンネルに割り当てられます。このときUGenのインスタンスは複数作られます。
{Pulse.ar([400, 500, 600],[0.5, 0.1], 0.2)}.play

//上のプログラムは以下と同じ。

{[ Pulse.ar(400,0.5,0.2), Pulse.ar(500,0.1,0.2), Pulse.ar(600,0.5,0.2) ]}.play


//Mix

{ Mix.new(  Pulse.ar([400, 501, 600], [0.5, 0.1], 0.1) ) }.play
//Mixは複数のシグナルをミックスして一つのチャンネルに束ねます。束はListで表現します。


{ Mix.fill( 12 ,{ SinOsc.ar( { 3000.rand }, 0 , 0.05 ) } ) }.play
//Mix.fillはnに指定した数だけfunctionを繰り返し一つのチャンネルにまとめます。

//Mix.fill(n,function)

