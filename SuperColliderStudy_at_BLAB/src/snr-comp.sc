Pdef(€comp).play;

Pdef(€comp).fadeTime = 3;

Pdef(€comp).reset;

(
Pdef(€comp,
Paddp(€ctranspose, Pseq([0,3,0,-5,0,-3,0,5], inf), 
	Ppar([

Pbind(€instrument,"duct",€midinote,Prand([4,€rest,0,€rest,9]+33, inf),
	€dur,Prand([2,1,0.5],inf),€amp,0.2),


Pbind(€instrument,"kicks",
	€dur,Pseq([4,2,1],inf),€amp,0.7),
	
Pbind(€instrument,Pshuf(["clicks","clicks2","clicks3"],inf),
	€dur,Prand([0.25,0.75],inf),€amp,Pseq([2,1,1,1,4,1,1,1]/4,inf)),

Pbind(€instrument,Prand(["snr1","snr2"],inf),
	€dur,Pseq([2],inf),€amp,1),
	])
);)
)

Tempo.bpm=145
o=AudioMeter.new
o.autoreset_(0.25)
__________________________

(
SynthDef("duct",{arg amp=0,freq=550;
var out;
out=Pulse.ar(freq*200,0.5,0.3)*Decay2.ar(Impulse.ar(60), 0.01, 0.14, 1)*EnvGen.ar(Env.new([0,1,0], [0.15,0]),doneAction: 2);
Out.ar(0,Pan2.ar(out,LFNoise2.kr(4)));
}).store;



SynthDef("kicks",{arg amp=0;
var out;
out=SinOsc.ar(XLine.kr(1200,50,0.03),pi/4,amp).dup*EnvGen.ar(Env.perc(0.03, 0.25, 0.9, -6),doneAction: 2);
Out.ar(0,out);
}).store;

SynthDef("snr1",{
var dom;
dom=28;
Out.ar(0,Pan2.ar(Pulse.ar(XLine.kr(dom,6200,0.05),0.5,0.3)*Decay2.ar(Impulse.ar(10), 0.01, 0.14, 5)*
EnvGen.kr(Env.perc(0.01,0.097,1,-4), 1, doneAction:2),LFNoise1.kr(4,1)))
}).store;


SynthDef("snr2",{arg gate=1,gain=800,lpf=1024;
var out;
y=Pan2.ar(ClipNoise.ar(0.4)*Decay2.ar(Impulse.ar(12), 0.01, 0.02, 4)*
EnvGen.kr(Env.perc(0.01,0.18,1,1), 1, doneAction: 2),LFNoise1.kr(4,1));
    out = (y*gain)*gate/8;
	w = y;
	w = AllpassN.ar(w, 0.1,{[0.1.rand, 0.1.rand]}.dup(2), 1.0);
	y = (y * -0.5) + (w * 0.5);

Out.ar(0,y);
}).store;



SynthDef("clicks",{arg amp=0;  
var v,y,a,b,env;
env=LFNoise2.kr(0.5,0.1,0.1);
a=Pulse.ar(60,0.1,0.3);
b=LFSaw.ar(XLine.kr(4860,2345,0.03),0,0.4);
v=(a clip2:b)*
EnvGen.ar(Env.perc(0.004,env,1,4), doneAction:2)*amp;
Out.ar(0,Pan2.ar(v,LFNoise1.kr(2)));
}).store;

SynthDef("clicks2",{arg amp=0;  
var v,y,a,b,env;
env=LFNoise2.kr(0.5,0.1,0.08);
a=Pulse.ar(9120,0.5,0.3);
b=Dust.ar([17000,17400,66,68],0.4);
v=(a clip2:b)*
EnvGen.ar(Env.perc(0.004,env,1,4), doneAction:2)*amp;
Out.ar(0,Pan2.ar(v,LFNoise1.kr(6)));
}).store;

SynthDef("clicks3",{arg amp=0;  
var v,y,a,b,env;
env=LFNoise2.kr(0.5,0.1,0.02);
a=Pulse.ar(60,0.5,0.3);
b=Pulse.ar([6700,6720],0.5,0.5);
v=(a clip2:b)*
EnvGen.ar(Env.perc(0.004,env,1,4), doneAction:2)*amp;
Out.ar(0,Pan2.ar(v,LFNoise1.kr(6)));
}).store;
)
________________________________________
(
SynthDef("clicks",{arg amp=0;  
var a,b,env;
env=LFNoise2.kr(0.5,0.1,0.02);
a=LFPulse.ar([57,66].midicps,0.5,0.1,0.3);

EnvGen.ar(Env.perc(0.004,env,0.5,2), doneAction:2)*amp;
Out.ar(0,Pan2.ar(a,LFNoise1.kr(2)));
}).store;

SynthDef("clicks2",{arg amp=0;  
var v,y,a,b,env;
env=LFNoise2.kr(0.5,0.1,0.02);
a=LFPulse.ar([61,69],0.5,0.5);

EnvGen.ar(Env.perc(0.004,env,0.5,4), doneAction:2)*amp;
Out.ar(0,Pan2.ar(a,LFNoise1.kr(6)));
}).store;

SynthDef("clicks3",{arg amp=0;  
var v,y,a,b,env;
env=LFNoise2.kr(0.5,0.1,0.02);
a=Pulse.ar(60,0.5,0.8);
b=Pulse.ar([700,720]);
v=(a clip2:b)*
EnvGen.ar(Env.perc(0.004,env,1,4), doneAction:2)*amp;
Out.ar(0,Pan2.ar(v,LFNoise1.kr(6)));
}).store;


)
