// SuperCollider workshop
// Making cute music and sound for begginers.
// 2016/04/24 Sun at tksc
// 06 Code remix


2006年のSuperColliderコードリミックスコンテスト

1. お題のコードを元にして、
　プログラムをSuperColliderで書き換えてください。
2. なにしてもいいけれど、SC以外のソフトを使うのは禁止です。
3. コードができたら、このフォーラムに投稿してください。


"http://supercollider.jp/modules/xhnewbb/viewforum.php?forum=16"
"http://supercollider.jp/modules/xhnewbb/viewtopic.php?topic_id=47"

(
var melody, bass, chord;

bass = Pbind(
\dur, Pseq([3.0],inf),
\midinote, Pseq([67,62] - 12, inf)
);

chord = Pbind(
\amp, 0.05,
\dur, Pseq([1.0,2.0],inf),
\midinote, Pseq([\,[59,62,66],\, [57,61,66]] , inf)
);

melody = Pbind(
\dur, Pseq([  1, 1, 1, 1, 1, 1, 1,1 ,1, 3, 12],inf),
\midinote, Pseq([\,66,69,67,66,61,59,61,62,57,54] + 12, inf)
);

Ptpar([0,bass, 0,chord, 0,melody]).play
)


------------------------------------------------------------------------
1. Pbindのパラメータを変える。
次の例は、デュレーション（音符の鳴るタイミング）を変えただけですが、全然違うものに？
数字の部分をいろいろといじってみましょう。

// Just Change the durations
(
var melody, bass, chord;

bass = Pbind(
\dur, Prand([1.0, 1.0],inf),
\midinote, Pseq([67,62] - 12, inf)
);

chord = Pbind(
\amp, 0.05,
\dur, Pseq([0.75,0.25],inf),
\midinote, Pseq([\,[59,62,66],\, [57,61,66]] , inf)
);

melody = Pbind(
\dur, Pseq([  1, 1, 1, 1, 1, 1, 1,1 ,1, 3, 12] / 2.0,inf),
\midinote, Pseq([\,66,69,67,66,61,59,61,62,57,54] + 12, inf)
);

Ptpar([0,bass, 0,chord, 0,melody]).play
)



2. SyhthDefを使って音源を変えてみる。
(
SynthDef("sample_simpleSine", {
    arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
    source =
    Pan2.ar(SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.asr(1,1,1), gate, doneAction:2), pan );
    Out.ar(0, source);
}).load(s);
);

(
var melody, bass, chord;

bass = Pbind(
\dur, Pseq([3.0],inf),
\midinote, Pseq([67,62] - 12, inf),
\instrument, \sample_simpleSine
);

chord = Pbind(
\amp, 0.05,
\dur, Pseq([1.0,2.0],inf),
\midinote, Pseq([\,[59,62,66],\, [57,61,66]] , inf),
\instrument, \sample_simpleSine
);

melody = Pbind(
\dur, Pseq([  1, 1, 1, 1, 1, 1, 1,1 ,1, 3, 12],inf),
\midinote, Pseq([\,66,69,67,66,61,59,61,62,57,54] + 12, inf),
\pan, Pseq ([-1,1], inf),

\instrument, \sample_simpleSine
);

Ptpar([0,bass, 0,chord, 0,melody]).play
)

3. SyhthDefを使ったり、パラメータを変えてみる

(

SynthDef("sample_simpleSine", {
    arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
    source =
    Pan2.ar(SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.05, 2.0, 1, -4), gate, doneAction:2), pan );
    Out.ar(0, source);
}).load(s);

SynthDef("sample_bassSine", {
    arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
    source =
    Pan2.ar(SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.05, 3.9, 1, -4), gate, doneAction:2), SinOsc.kr(1) );
    Out.ar(0, source);
}).load(s);
);


(
var melody, bass, chord;

bass = Pbind(
\dur, Pseq([4.0],inf),
\midinote, Pseq([67, 62] - 24, inf),
\instrument, \sample_bassSine
);

chord = Pbind(
\amp, 0.04,
\dur, Pseq([1.0, 1.0],inf),
\midinote, Pseq([\,Prand([59,62,66],1),\, 57,61,66] , inf),
\instrument, \sample_simpleSine
);

melody = Pbind(
\dur, Pseq([ 1, 1, 1, 1, 1, 2, 1, 1, 2, Pseq([0.66,0.66,0.67],1), Pseq([0.25],8)], inf),
\midinote, Pshuf([\,66,69,67,66,61,59,\,61,62,57,54] + 24, inf),
\instrument, \sample_simpleSine,
\pan, Pseq ([-0.5, 0.5], inf)

);

Ptpar([0, bass, 0, chord, 6, melody]).play
)

////////////////////////////////////
