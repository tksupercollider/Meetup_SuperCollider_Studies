
"http://supercollider.jp/modules/xhnewbb/viewtopic.php?topic_id=47"


//by Novo Tempo  http://www.myspace.com/novotempo

(
//SynthDef

SynthDef(\FreeVerb2x2, {|outbus, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|
    var signal;
    signal = In.ar(outbus, 2);
    ReplaceOut.ar(outbus,FreeVerb2.ar(signal[0],signal[1],mix, room, damp, amp));
}).store;

SynthDef(\melo,{arg midinote=104,out=0,amp=0;
    var a,b,c,lfo,fl;
    lfo=SinOsc.kr(300,0,3600,4000) ;
    a=FSinOsc.ar((midinote.midicps*1.0), 0, 0.1)*EnvGen.kr(Env.perc(0.5, 0.01, 1, 4), 1, 2, doneAction:2);
    b=FSinOsc.ar((midinote.midicps*254/256), 0, 0.05)*EnvGen.kr(Env.perc(0.5, 0.01, 1, 4), 1, 1, doneAction:2);
    c=FSinOsc.ar((midinote.midicps*258/256), 0,0.05)*EnvGen.kr(Env.perc(0.5, 0.01, 1, 4), 1, 2, doneAction:2);
    fl=LPF.ar(a+b+c,lfo);
    Out.ar(out,Pan2.ar(fl*amp,FSinOsc.kr(2)));
}).store;

SynthDef(\pad,{arg freq=440,amp=0.8,gate=1;
    var src, z, y,env;
    env = EnvGen.kr(Env.adsr(0.8, 0.5, 0.25, 1, 1,-4),gate,doneAction: 2);
    s = env*SinOsc.ar(freq,0,amp) ;
    z = DelayN.ar(s, 0.048);
    y = Mix.ar(Array.fill(2,{ CombL.ar(s, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
    2.do({ y = AllpassN.ar(y, 0.050, [0.050.rand,0.050.rand], 1) });
    Out.ar(0,Pan2.ar(s,0,amp));
}).store;

SynthDef("sc303", //Lance Putnam's "sc303" thanx!
    { arg out=0, freq=440, wave=0, ctf=100, res=0.2,
        sus=0, dec=1.0, env=1000, gate=1, amp=0.3;
    var filEnv, volEnv, waves;
    volEnv = EnvGen.ar(Env.new([10e-10, 1, 1, 10e-10], [0.01, sus, dec], 'exp'), gate, doneAction:2);
    filEnv = EnvGen.ar(Env.new([10e-10, 1, 10e-10], [0.01, dec], 'exp'), gate);
    waves = [Saw.ar(freq, volEnv), Pulse.ar(freq, 0.5, volEnv)];
    Out.ar(out, RLPF.ar( Select.ar(wave, waves), ctf + (filEnv * env), res).dup * amp);
}).store;

SynthDef("kickDrum", { arg amp=1, pan=0, clip=1;
        var gate = 1;
        var noiseEnv = Env.perc(0.001, 1, 80, -20);
        var ampEnv = Env.perc(0.001,1,amp/clip,-8);
        var pitchEnv = Env.perc(0.001,1,80,-8);
        var noise = LPF.ar(WhiteNoise.ar(1), EnvGen.kr(noiseEnv, gate)+20);
        var osc = LPF.ar(SinOsc.ar(EnvGen.kr(pitchEnv, gate)+20),200);
        Out.ar(0, Pan2.ar(
                (noise +osc).clip2(clip),
                pos: pan,
                level: EnvGen.kr(ampEnv, gate, doneAction: 2)
        ));
}).store;

SynthDef(\rim,{arg freq=10,amp=0.5;var src;
    src=PMOsc.ar( Pulse.ar(6000,0.1, 0.01) *EnvGen.kr(Env.perc(0.005, 0.01, 1, -2),1,doneAction: 2),[freq*1.34, freq*2.405],[310/1.3, 26/0.5],mul: 1,add: 0);
    Out.ar(0,src*amp);
}).store;


//reverb

Synth(\FreeVerb2x2, [\outbus, 0,\damp,0.9,\mix,0.25,\room,0.7], addAction:\addToTail);


//sequence

~pad = Pbind(
    \dur, Pseq([1.0,2.0]*2,inf),
    \midinote, Pseq([\,[59,62,66,67]+12,\, [57,61,62,66]] , inf),
    \amp,0.18,
    \instrument,\pad
);

~melody = Pbind(
    \dur, Pseq([  1, 1, 1, 1, 1, 1, 1,1 ,1, 3, 12]*2,inf),
    \amp,0.3,
    \midinote, Pseq([\,66,69,67,66,61,59,61,62,57,54]+36, inf),
    \instrument,\melo
);

~bass3032= Pbind(
    \dur, Pseq([0.25]*2,inf),
    \amp,0.4,
    \midinote, Pseq([\,\,67,67,\,\,\,\,\,\,67,67,\,\,62,62,\,\,\,\,\,\,62,62] -36, inf),
    \gate,1,
    \ctf,120,
    \instrument,\sc303
);


~kick909= Pbind(
    \dur,Pseq([4],inf),
    \instrument,\kickDrum,
    \midinote,Pseq([67],inf),
    \amp,0.4
);

~hook=Pbind(
    \dur,Pseq([0.5]/3,inf),
    \amp,0.05,
    \midinote,Pseq([\,\,\,\,\,\,[59,62,66],\,\,\,[59,62,66],\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,[59,62,66],\,\,\,[59,62,66],\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,[59,62,66],\,\,\,[59,62,66],\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,[59,62,66],\,\,\,[59,62,66],\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\],inf),
    \ctf,4000,
    \instrument,\sc303
);

~rim= Pbind(
    \dur,Pseq([0.5],inf),
    \instrument,\rim,
    \midinote,Pseq([0,0,-5,0,0,0,-3,1,0,0,-8,0,],inf),
    \amp,0.02
);

~hat= Pbind(
    \dur,Pseq([0.5],inf),
    \instrument,\rim,
    \midinote,Pseq([\,\,\,\,72,\,\,\,\,\,\,\],inf),
    \amp,0.02
);

Ppar([~pad,~hook,~melody,~bass3032,~kick909,~rim,~hat]).play(TempoClock(2.2));

)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//by moxuse

////gymnopedie////

(
//SynthDefs
SynthDef("osc1",{arg freq,amp;
Out.ar(0,SinOsc.ar([freq,freq*1.01],0,SinOsc.ar(Pulse.ar(freq*2,0.1,freq),0,0.3))*EnvGen.ar(Env.perc(0.0,0.9,1,-4),doneAction:2)*amp)}).store;
SynthDef("osc2",{arg freq,amp;
Out.ar(0,Pan2.ar(RLPF.ar(SinOsc.ar(freq,SinOsc.ar(freq),Pulse.ar(freq/15,0.1,0.3)),LFNoise2.ar(2,30,90).midicps)*EnvGen.ar(Env.perc(0.01,0.5,1,-2),doneAction:2),LFNoise2.ar(3))*amp)}).store;
SynthDef("osc3",{arg freq,amp;
Out.ar(0,Pan2.ar(SinOsc.ar([freq,freq*1.01],0,Pulse.ar(freq*2,0.1,0.3))*EnvGen.ar(Env.perc(0.01,0.2,1,5),doneAction:2)*amp))}).store;
SynthDef("perc1",{arg amp;
Out.ar(0,(HenonL.ar([8900,3200],TRand.ar(0.09,0.8,Impulse.ar(20)),LFNoise2.kr(0.25, 0.15, 0.15),mul:0.2) wrap2: SinOsc.ar(5,[0,0.12],0.2))*EnvGen.ar(Env.perc(0.0,0.4,1,6),doneAction:2)*amp)}).store;
SynthDef("perc2",{arg amp;
Out.ar(0,(Blip.ar(Lag.ar(TExpRand.ar(80,12023,Impulse.ar([20,18])),0.02),14,mul:0.25) clip2: SinOsc.ar(XLine.kr(24,LFNoise2.ar(4,16,6),0.4),0,0.6))*EnvGen.ar(Env.perc(0.0,0.1,1,6),doneAction:2)*amp)}).store;
//sequence
Pdef(\gymnopedie,
Ppar([Pbind(
\instrument,\osc1,\dur, 3.0,
\midinote, Pseq([67,62] - 12, inf),
\amp,0.9),
Pbind(
\instrument,\osc1,\dur, Pseq([1.0,2.0],inf),
\midinote, Pseq([\,[59,62,66],\, [57,61,66]] , inf),\amp,0.9),
Pbind(
\instrument,\osc1,
\dur, Pseq([ 1, 1, 1, 1, 1, 1, 1,1 ,1, 3, 12],inf),
\midinote, Pseq([\,66,69,67,66,61,59,61,62,57,54] + 12, inf),
\amp,0.8),
Pbind(
\dur,Prand([0.333333,1.33333],inf),\instrument,\osc3,
\midinote, Prand([55,59,62,67,69,76,\,\] + 31, inf),
\pan,Pwhite(0,1),\amp,0.3),
Pbind(
\instrument,\osc3,
\dur,Prand([0.333333,1.33333],inf),
\midinote, Pxrand([57,59,61,62,66,67,\,\] + 48, inf),
\pan,Pwhite(-1,0),\amp,0.3),
Pbind(
\instrument,\osc2,\dur,0.333333,
\midinote, Prand([45,50,57,69,76,\,\]-12, inf),
\amp,0.6),
Pbind(\instrument,\perc1,\dur,2.66666,\amp,Pwhite(0,0.8)),
Pbind(\instrument,\perc2,\dur,0.66666,\amp,Pwhite(0,0.8))]));
Pdef(\gymnopedie).play;
)
Pdef(\gymnopedie).stop;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//by ChineseRoom


// SuperCollider.jp - Code Remix Contest //
// Gymnopedie*Underachiever Remix //
// Composed By: Erik Satie //
// Remixed By: ChineseRoom //

(
	var gym_synth, gym_seq;

	gym_synth = {
		SynthDef("synth_melody", {
			arg freq=440, gate=1, amp=1.0, env, source1, source2, pan = 0.0 ;
			env = EnvGen.kr(Env.adsr(0.001, 2, 0.0, 0.1, 1, -20), gate, doneAction:2);
			source1 = Pan2.ar( Pulse.ar(freq, 0.51, amp) * env );
			2.do({source1 = AllpassN.ar(source1, 0.08, [ExpRand(0.01,0.08),ExpRand(0.01,0.08)], 2)});
			source2 = source1 + Pan2.ar( Pulse.ar(freq*2, 0.51, amp) * env );
			Out.ar(0, source2);
		}).store;


		SynthDef("synth_bass", {
			arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
			source =
			Pan2.ar(
			Pulse.ar(freq, [0.6, 0.4], amp * 0.8) + SinOsc.ar(freq, 0, amp) *
			EnvGen.kr(Env.adsr(0.01, 0.2, 0.9, 0.01, 1, -6), gate, doneAction:2), pan );
			Out.ar(0, source);
		}).store;

		SynthDef("synth_chord", {
			arg freq=440, gate=1, amp=1.0, source, env1, env2, pan = 0.0 ;

			env1 = EnvGen.kr(Env.adsr(0.01, 2, 0.0, 0.6, 1, -6), gate, doneAction:2);
			env2 = EnvGen.kr(Env.adsr(0.05, 0.3, 0.0, 0.6, 1, 'exponential'), gate, MouseY.kr(12000, 10, 0, 0.2), 200);

			source = Pan2.ar(LPF.ar(Pulse.ar(freq, SinOsc.ar([2.2, 2.4], [1.0, 0.3], 0.3, 0.5), amp), env2) * env1, pan);
			Out.ar(0, source);
		}).store;


		SynthDef("synth_chord2", {
			arg freq=440, gate=1, amp=1.0, source, env1, env2, pan = 0.0 ;

			env1 = EnvGen.kr(Env.adsr(0.001, 1, 0.0, 0.6, 1, -6), gate, doneAction:2);
			env2 = EnvGen.kr(Env.adsr(0.01, 0.2, 0.0, 0.2, 1, Rand(-50,-10)), gate, ExpRand(40,13000), 400);
			source = Pan2.ar(LPF.ar(LFSaw.ar(freq, [Rand(0,1),Rand(0,1)], amp), env2) * env1, pan);
			2.do({source = AllpassN.ar(source, 0.07, ExpRand(0.01,0.07), 3)});
			Out.ar(0, source);
		}).store;

		SynthDef("synth_klock", {
			arg freq=440, gate=1, amp=1.0, source, env1, pan = 0.0,  fmratio = 0.5 ;
			env1 = EnvGen.kr(Env.perc(0.0001, 0.018, 1, 10), gate, 1, 0, doneAction:2);
			source = Pan2.ar( HPF.ar(SinOsc.ar(SinOsc.ar(freq*fmratio, 0, env1*2000 + 5000, freq), 0.51, amp), 3000), pan ) * env1;
			Out.ar(0, source);
		}).store;

		SynthDef("synth_kroll", {
			arg freq=440, gate=1, amp=1.0, source, osc, env1, pan = 0.0,  fmratio = 0.5 ;
			env1 = EnvGen.kr(Env.perc(0.0001, 0.1, 1, -6), gate, 1, 0);
			osc = Pan2.ar( SinOsc.ar(SinOsc.ar(freq*2, 0, env1*9000+2000, freq), 0.51, amp), pan ) * env1;
			source = osc + AllpassN.ar(AllpassN.ar(osc, 1, ExpRand(0.02,0.3), 2), 1, ExpRand(0.02,0.3), 2) * Line.kr(1,0,1.5, doneAction:2);
			Out.ar(0, source);
		}).store;

		SynthDef("drum_kick", {
			arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
			source =
			Pan2.ar(
			SinOsc.ar(EnvGen.kr(Env.perc(0.0001, 2.5, 1, -200), gate, 1000, 45, doneAction:2), 1, 1) +
			((BPF.ar([GrayNoise.ar(8),GrayNoise.ar(8)],EnvGen.kr(Env.perc(0.001, 0.3, 1, -200), gate, 6000, 70), 1.5)).distort * Line.kr(0.3,0,0.1))
			*
			EnvGen.kr(Env.perc(0.001, 0.22, amp, 8)),0);
			Out.ar(0, source);
		}).store;

		SynthDef("drum_shaker", {
			arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
			source =
			Pan2.ar(BPF.ar(WhiteNoise.ar(16),10000,0.2).distort * EnvGen.kr(Env.perc( (1-amp*0.02)+0.01 , ((amp*amp)*1.0 + 0.1), amp*amp*0.8+0.2, -6), gate, doneAction:2),Rand(-0.3,0.3));
			Out.ar(0, source);
		}).store;

		SynthDef("drum_hihat", {
			arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
			source =
			Pan2.ar(BPF.ar(LFPulse.ar(BPF.ar(WhiteNoise.ar(5),1200,0.1).distort * 8000 + 6600, 0.7),7000,1) * EnvGen.kr(Env.perc(0.01, 0.4, 1, -6), doneAction:2),0);
			Out.ar(0, source);
		}).store;

		SynthDef("drum_clap", {
			arg freq=440, gate=1, amp=1.0, source, pan = 0.0 ;
			source =
			Pan2.ar((BPF.ar(BPF.ar(WhiteNoise.ar(16),2300,0.3),8300,0.3)*5).distort * EnvGen.kr(Env.perc(0.01, 0.1, 1, 0), doneAction:2),0);

			Out.ar(0, source);
		}).store;
	};

	gym_seq = {
		var clock, melody, bass, chord, chord2, fkick, shaker, hihat, clap, klock, kroll, sfl;
		sfl = 1.0/8.0;

		clock = TempoClock(120/60);

		melody = Pbind(
		\instrument, \synth_melody,
		\amp, 0.3,
		\dur, Pseq([  2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 8, 4, 8, 4, ]/3.0,inf),
		\midinote, Pseq([ \, 66, 69, 67, 66, 61, 59, 61, 62, 57, 59, \, 71, \] 	+ 12, inf)
		);

		bass = Pbind(
		\instrument, \synth_bass,
		\amp, 0.3,
		\dur, Pseq([ 2, 1+sfl, 1-sfl, 2, 1+sfl, 0.4, 0.6-sfl]/4.0,inf),
		\midinote, Pseq([ 64, \, 64, \, 71, 76, \, 59, \, 59, \, 62, 66, \ ] - 24, inf)
		);

		chord = Pbind(
		\instrument, \synth_chord,
		\amp, 0.2,
		\dur, Pseq([3.0+sfl,5.0-sfl;]/4,inf),
		\midinote, Pseq([\,[59,62,66],\, [57,61,66]] , inf)
		);

		chord2 = Pbind(
		\instrument, \synth_chord2,
		\amp, 0.2,
		\dur, Pseq([2]/4,inf),
		\midinote, Pseq([[55,62,66],[59,62,69],[55,62,66]+12,[59,62,69],[54,61,66],[57,61,69],[54,61,66],[57,61,69]] , inf)
		);

		fkick = Pbind(
		\instrument, \drum_kick,
		\amp, 0.7,
		\dur, Pseq([1, 1],inf),
		\midinote, 3
		);

		shaker = Pbind(
		\instrument, \drum_shaker,
		\amp, Pseq([ 0.3, 0.1, 1.0, 0.4, 0.6, 0.3, 1.0, 0.4 ]/4,inf),
		\dur, Pseq([1+sfl, 1-sfl]/4,inf),
		\midinote, 3
		);

		hihat = Pbind(
		\instrument, \drum_hihat,
		\amp, 0.2,
		\dur, Pseq([1, 1]/2,inf),
		\midinote, Pseq([\, 1],inf)
		);

		clap = Pbind(
		\instrument, \drum_clap,
		\amp, 0.15,
		\dur, Pseq([1, 1],inf),
		\midinote, Pseq([\, 1],inf)
		);

		klock = Pbind(
		\instrument, \synth_klock,
		\amp, 0.4,
		\dur, Pseq([  4, 1+sfl, 1-sfl, 1+sfl, 1-sfl, ]/4.0,inf),
		\midinote, Pseq([ \, \, 59, \, 59,] + 12, inf),
		\fmratio, Pseq([ 0, Pxrand([ 0.166, 0.5, 3, 4, 5 ], inf), 0, Pxrand([ 0.166, 0.5, 3, 4, 5 ], inf)], inf),
		\pan, Pseq([ -1, 1 ], inf)
		);

		kroll = Pbind(
		\instrument, \synth_kroll,
		\amp, 0.6,
		\dur, Pseq([ 12, 4 ]/4.0,inf),
		\midinote, Pseq([ \, 59, \, 71 ] + 24, inf),
		\pan, Prand([ 1, -1,  0.5, -0.5 ], inf)
		);

		Ptpar([0,bass, 0,chord, 0,chord2, 0,melody, 0,fkick, 0,shaker, 0,hihat, 0,clap, 0,klock, 0,kroll]).play(clock);
		};


	gym_synth.value;
	gym_seq.value;

	)
