//SuperCollider勉強会_1

//音を鳴らそう！


////////////////////////////////////////////////////////////

s=Server.local;//自分のマシンのサーバ
s.boot;//ブート


//シンセを生成、送信。
(
SynthDef("help-sine",{arg freq=440,amp=0.3;
	var out;
	out=Pan2.ar(
			SinOsc.ar(freq,0,amp),
			SinOsc.kr(1)
			);
	Out.ar(0,out);
}).store;
)


//ノード生成
s.sendMsg("/s_new","help-sine",1004,1,0);//グループ1のID 1004にhelp-sineを生成

//パラメータを変える
s.sendMsg("/n_set",1004,"freq",1200,"amp",0.3);

//ノードの解放
s.sendMsg("/n_free",1004);





////////////////////////////////////////////////////////////

//Instr
//簡単にパッチングを試す事ができる、専用のGUIを生成してくれる。シンタックスはSynthDefに似ている。


(
Instr("help-sine",{arg freq=440,amp=0.3;
	var out;
	out=SinOsc.ar(freq,0,amp).dup;
}).test;
)


////////////////////////////////////////////////////////////

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





////////////////////////////////////////////////////////////

//リズムを作ってみる
//Pbind

Pbind(\dur,0.5).play

Pbind(\dur,0.5,\note,Pseq([0,1,2,3],10)).play

Pbind(\dur,0.25,\note,Pseq([0,1,2,3,4,5,6,7,8,9],10),\amp,Prand([0,0.3],inf)).play



//自分で作ったシンセでならす。

(
SynthDef("mySynth",{arg freq,amp;
	var out;
 	out = Pulse.ar( freq,0.1,amp ).dup;
 	env = EnvGen.ar( Env.perc,doneAction:2 );//エンべロープをつけて音を減衰させる。
 	Out.ar( 0, out * env );
}).store;
)

(
Pbind(\instrument,"mySynth",
		\dur,0.25,
		\note,Pseq([0,1,2,3,4,5,6,7,8,9],inf),
		\amp,Prand([0,0.3],inf)
		).play;
)


------------------------------------------------------------------

//Tips

//ヘルプ： ⌘+shift+?

//サーバのブート：サーバウィンドにフォーカス状態でspaceキー

//処理の停止: ⌘+.



//おすすめヘルプとか

//Getting Started With SC：まずはチュートリアル
//Streams　:　ストリームヘルプ
//Server-Command-Reference :　サーバコマンドがわからなくなったら



//SuperCollider in SAITAMA
//[http://mouxse.org/scs/]


//SuperCollider JAPAN
//[http://SuperCollider.jp]