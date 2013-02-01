(
SynthDef("base",{arg amp=0,freq=550;
Out.ar(20,LFPulse.ar(XLine.kr(freq,freq*0.5,2),SinOsc.ar(freq/2,0.5,0.8),0.5,0.4).dup*Decay2.ar(Impulse.ar(0), 0.01, 0.14, 1)*EnvGen.ar(Env.new([0,1.2,0], [0.15,0],'step'),doneAction: 2))
}).store;

SynthDef("line1",{arg amp=0,freq=550;
Out.ar(0,Pulse.ar(XLine.kr(freq,freq*0.8,2),0.5,0.8)*Decay2.ar(Impulse.ar(60), 0.03, 0.14, 1).dup*EnvGen.ar(Env.new([0,1,0], [0.15,0],'step'),doneAction: 2))
}).store;

SynthDef("line2",{arg amp=0,freq=550;
Out.ar(0,Pulse.ar(XLine.kr(freq,freq*0.8,0.01),0.5,0.4)*Decay2.ar(Impulse.ar(60), 0.01, 0.14, 1).dup*EnvGen.ar(Env.perc(0.02, 0.4, 1, 4),doneAction: 2))
}).store;


SynthDef("kick",{arg amp=0;
Out.ar(0,SinOsc.ar(XLine.kr(120,44,0.15),pi/4,amp)+LFClipNoise.ar(600,0.1).distort.dup*EnvGen.ar(Env.perc(0.0, 0.2, 1, 4),doneAction: 2))
}).store;

SynthDef("snr",{arg amp=0;
Out.ar(0,ClipNoise.ar(0.4).dup*EnvGen.ar(Env.new([0,0.4,0], [0.1,0],'step'),doneAction: 2))
}).store;

SynthDef("click",{arg amp=0;
Out.ar(0,ClipNoise.ar(0.4).dup*EnvGen.ar(Env.new([0,0.5,0], [0.02,0],'step'),doneAction: 2))
}).store;
)


(
Pdef(€bit2,
Paddp(€ctranspose, Pseq([0,5,0,-1,0,5,0,1], inf), 
	Ppar([

Pbind(€instrument,"line1",€midinote,Prand([Pseq([Pseq([4,11,7,11,4,7]+66,2),Pseq([7,11,7,11,7,11,7,11,4]+66,2),Pseq([11,12,4,16,4,7]+66,2)]),Pseq([Pseq([4,11,12,4,11,7]+66,2),Pseq([11,4,12,11,7,12,11,4,16]+66,2),Pseq([11,14,7,14,4,7]+66,2)])]),
	€dur,Pseq([Pseq([1,2,1,2,1,2,1,2,1,2,3,1]/8),Pseq([1,1,1,2,1,2,1,2,1,2,1,3,1]/8)],4),€amp,0.2),
	
	
Pbind(€instrument,"line1",€midinote,Prand([Pseq([Pseq([4,11,7,11,4,7]+66,2),Pseq([7,11,7,11,7,11,7,11,4]+61+12,2),Pseq([11,12,4,16,4,7]+61,2)]),Pseq([Pseq([4,11,12,4,11,7]+61,2),Pseq([11,4,12,11,7,12,11,4,16]+61+12,2),Pseq([11,14,7,14,4,7]+66+12,2)])]),
	€dur,Pseq([Pshuf([1,2,1,2,1,2,1,2,1,2,3,1]/8),Pshuf([1,1,1,2,1,2,1,2,1,2,1,3,1]/8)],4),€amp,0.2),
	
	
	
	
Pbind(€instrument,"line1",€midinote,Prand([Pseq([Pseq([4,11,7,11,4,7]+66-12,2),Pseq([7,11,7,11,7,11,7,11,4]+66-12,2),Pshuf([11,12,4,16,4,7]+61-24,2)]),Pseq([Pseq([4,11,12,4,11,7]+61-12,2),Pshuf([11,4,12,11,7,12,11,4,16]+61-12,2),Pshuf([11,14,7,14,4,7]+66-12,2)])]),
	€dur,Pseq([Pshuf([1,2,1,2,1,2,1,2,1,2,3,1]/8),Pshuf([1,1,1,2,1,2,1,2,1,2,1,3,1]/8)],4),€amp,0.2),
	
Pbind(€instrument,"base",€midinote,Pshuf([Pseq([4,7,4,0,4,7,4,0]+32,4),Pseq([4,7,11,4,11,4,4,7]+32,3)]),
	€dur,Pseq([Pseq([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2]/8)],4),€amp,0.2),
	

Pbind(€instrument,"kick",
	€dur,Pseq([4]/8,16),€amp,0.8),
	
Pbind(€instrument,"click",
	€dur,Pseq([1]/8,64),€amp,Pseq([2,1,1,1,4,1,1,1]/4,inf)),

Pbind(€instrument,"snr",
	€dur,Pseq([8]/8,8),€amp,1),
	])
);)
)
__________________________________________
(
Pdef(€bit2,
Paddp(€ctranspose, Pseq([0,5,0,-1,0,5,0,1], inf), 
	Ppar([

Pbind(€instrument,"line1",€midinote,Prand([4,16,4,4,4,0,11]+66,42),
	€dur,Pseq([Pseq([1,2,1,2,1,2,1,2,1,2,2,1]/8),Pseq([2,1,1,2,1,2,1,2,1,2,1,1,2]/8)],4),€amp,0.5),
	
Pbind(€instrument,"base",€midinote,Pshuf([Pseq([4,7,4,3,4,7,4,3]+32,4),Pseq([4,7,11,4,11,4,4,7]+32,3)]),
	€dur,Pseq([Pseq([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2]/8)],4),€amp,0.2,€ctranspose,Prand([7,0,0,0,0],inf)),



Pbind(€instrument,"kick",
	€dur,Pseq([4]/8,16),€amp,0.8),
	
Pbind(€instrument,"click",
	€dur,Pseq([1]/8,64),€amp,Pseq([2,1,1,1,4,1,1,1]/4,inf)),

Pbind(€instrument,"snr",
	€dur,Pseq([8]/8,8),€amp,1),
	])
);)
)
___________________________

Pdef(€bit2).play;

Pdef(€bit2).fadeTime = 0;

Pdef(€bit2).stop;


____________________________
(
Instr("mix",{arg amp1=0,amp2=0,amp3=0,amp4=0,lpf1=9000,lpf2=9000,lpf3=9000,lpf4=9000;
var a,b,c,d;
a=RLPF.ar(In.ar(10,2)*amp1,lpf1,0.1);
b=RLPF.ar(In.ar(20,2)*amp2,lpf2,0.2);
c=RLPF.ar(In.ar(30,2)*amp3,lpf3,0.3);
d=RLPF.ar(In.ar(40,2)*amp4,lpf4,0.3);

Out.ar(0,Mix.new([a,b,c,d]));
},[€amp,€amp,€amp,€amp,€freq,€freq,€freq,€freq]).test;
)
