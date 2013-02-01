s.sendMsg(€b_allocRead, 30, "sounds/bent9.wav");

s.sendMsg(€b_allocRead, 20, "sounds/sui2.aif");

s.sendMsg(€b_allocRead, 10, "sounds/sui1.aif");



o=AudioMeter.new;
o.autoreset_(0.25);
__________

(
SynthDef("kicks",{arg amp=0,rate=0;
var out,mod;
mod = EnvGen.ar(Env.perc(0.00,0.01,1,-2)) * 9200;
out=SinOsc.ar(50+mod,pi/4,amp).dup*EnvGen.ar(Env.perc(0.0, 0.2, 0.7, 6),doneAction: 2);
Out.ar(0,out);
}).store;

SynthDef("kicks2",{arg amp=0,rate=0;
var out,mod;
mod = EnvGen.ar(Env.perc(0.001,0.01,0.6,-4)) * 1200;
out=SinOsc.ar(50+mod,pi/4,amp).dup*EnvGen.ar(Env.perc(0.0, 0.2, 0.7, 6),doneAction: 2);
out=out+SinOsc.ar(11343,0,0.2)*EnvGen.ar(Env.perc(0.0, 0.3, 0.4, 12));
Out.ar(0,out);
}).store;

SynthDef("moes",{arg rate=1,amp=0;
	var b = 10, trate, dur,out;
	trate = MouseY.kr(2,500,1);
	dur = SinOsc.ar(0.4,0,3) +4 / trate;
	out=TGrains.ar(2, Impulse.ar(trate), b,rate, MouseX.kr(0,BufDur.kr(b)), dur, LFNoise1.kr(2), 4, 2)*amp*
EnvGen.kr(Env.perc(0.01,0.07,1,4), 1, doneAction:2);
Out.ar(0,(out*13).softclip*0.05);
}).store;


SynthDef("moes2",{arg rate=1,amp=0;
	var b = 20, trate, dur,out;
	trate = MouseY.kr(2,500,1);
	dur = SinOsc.ar(0.4,0,3) +4 / trate;
	out=TGrains.ar(2, Impulse.ar(trate), b,rate, MouseX.kr(0,BufDur.kr(b)), dur, LFNoise1.kr(4), 4, 2)*amp*
EnvGen.kr(Env.perc(0.01,0.1,1,4), 1, doneAction:2);
Out.ar(0,(out*2).softclip*0.07);
}).store;


SynthDef("moe2",{arg rate=1,amp=0,trate = 80;
	var b = 30, dur,out;
	dur = SinOsc.ar(0.4,0,3) +4 / trate;
	out=TGrains.ar(2, Impulse.ar(trate), b,rate, MouseX.kr(0,BufDur.kr(b)), dur,LFNoise2.kr(3), 4, 2)*amp*
EnvGen.kr(Env.perc(0.01,0.297,1,-4), 1, doneAction:2);
Out.ar(0,(out*122).softclip*0.2);
}).store;



SynthDef("moe3",{arg amp=0,rate=1,dur;
     var out;
	out= Pan2.ar(DynKlank.ar(`[[48, 12113, 63, 5040]*rate, nil, [1, 1, 1, 1]], WhiteNoise.ar(0.1)) *amp*
EnvGen.kr(Env.perc(0.0,0.1,0.6,-12), 1, doneAction:2),LFNoise2.kr(0.3));
Out.ar(0,out.softclip);
}).store;



SynthDef("moe4",{arg amp=0,rate;
     var out;
	out= Pan2.ar(DynKlank.ar(`[[1223, 838, 3264]-XLine.kr(20,290,0.1)*rate, nil, [1, 1, 1, 1]], ClipNoise.ar(0.5)) *amp*
EnvGen.kr(Env.perc(0.00,0.1,1,6), 1, doneAction:2),0.8);
Out.ar(0,(out*2).softclip*0.1);
}).store;

SynthDef("bass",{ arg note=65,dur=0.2;
var src;
src=Pan2.ar(Mix.fill(4, {SinOsc.ar((note+[0,6,27,12,32,-12].choose).midicps,0.2.rand,0.2*LFNoise2.ar(1.7))*Decay2.ar(Dust.ar(26),0.01,0.2)})*SinOsc.ar(note.midicps*12,0,0.7),LFNoise2.ar(0.1))*EnvGen.ar(Env.perc(0.01,0.75*dur,1,3),doneAction:2);
	Out.ar(0,src)
}).store;

SynthDef("bass2",{arg amp=0.95,dur,note;
     var out;
	out= Pan2.ar(DynKlank.ar(`[[14725, 9415, 4392]-XLine.kr(10,20,0.25), nil, [0.5, 0.8, 0.6]], SinOsc.ar(note.midicps,0,LFNoise2.ar(0.1)
) )*amp*
EnvGen.kr(Env.perc(0.01,0.75*dur,2,-5), 1, doneAction:2),LFNoise1.ar(0.06));
Out.ar(0,out);
}).store;

s.sendMsg(€b_allocRead, 40, "sounds/ax3.wav");


SynthDef("moes20",{arg rate=1,pos=0,lega=0.3;
	var out;
	out=PlayBuf.ar(1,40,[rate,rate*1.01],1, BufFrames.kr(30)*pos/4,1)*
EnvGen.kr(Env.perc(0.001,lega,1,-4), 1, doneAction:2);
Out.ar(0,out);
}).store;

)



____________________

(
Pdef(€moe0,
	Ppar([


Pbind(€instrument,"moe2",
	€dur,Prand([3,5,1,0.5],inf),€amp,0.3,€trate,Prand([100,80,40],inf)),


Pbind(€instrument,"kicks2",
	€dur,Pshuf([4],inf),€amp,0.89),
	
Pbind(€instrument,Prand(["kicks","moes"],inf),€dur,Prand([0.75,2.75,2.5,0.25],inf),€amp,Prand([0.4,0.5,€,€,€],inf),€rate,Pshuf([1,1.25,1.75,1.3],inf)),


Pbind(€instrument,Prand(["moe3","moe4"],inf),
	€dur,0.25,€amp,Pshuf([2,1,4,1,€,€,4,4,€,€,€]/4,inf),€rate,Prand([1,0.75,0.2,1,0.12,17,€,€]/4,inf)),


Pbind(€instrument,Prand(["moes","moe3","moe2"],inf),
	€dur,Pseq([1,2,4],inf)*Pseq([1,1,1,1,Pshuf([1,2,1],7)*Prand([2/3,1],7)*Prand([1,1,1,2,0.5],3),2],inf),€amp,Prand([€,2,2,4,€,1,€,2,1]/4,inf),€rate,Prand([0.3,0.75,0.5,1,€,€],inf)),


Pbind(€instrument,Prand(["moes","moe4"],inf),
	€dur,0.5,€amp,Prand([1,1,€],inf),€rate,Prand([4/5,1/2,3/4,2,-2,0.05,12],inf),€tempo,Pseq([1,1,1,2,1,1,3,1,1,0.5,0.125,0.5,0.75,0.75,1,1,1,0.5,2,2]*2.5,inf)),
	
	Pbind(€instrument,"bass",€dur,Prand([7]*2,inf),
€note,Pxrand([0,7,5]+62-12,inf)+Pxrand([0,0,-3,7,0,5,0,10],inf)),

	Pbind(€instrument,"bass2",€dur,Prand([7,0.454,5,3.53,2.555,0.34,0.467]*2,inf),€note,Pxrand([0,7,4,-12,-20,19,-24]+38,inf)),

//Pbind(€instrument,€moes20,€rate,
//Pseq([
//1,0.8,0.5,1,0.4,
//0.75,1,0.4,0.75
//]/2,inf),€pos,Pseq([0,1,2,3,1,2,1,0,0,1,2],inf),€dur,Pseq([0.25,Prand([0.75],5)],inf),€lega,0.3);

	]))
)
Tempo.bpm=122;
Pdef(€moe0).play;
Pdef(€moe0).stop;


Pdef(€moe0,
	Ppar([
Pbind(€instrument,€moes20,€rate,
Pseq([1],inf),€pos,0,€dur,Pseq([4],inf),€lega,12);
]));


c=ExternalClock(TempoClock(2.5)).play;
(	
a=BBCut2(CutGroup([CutStream1.new(0),CutBPF1(6000,drqfunc:0.5),CutMixer(0,0.8,RollAmplitude.new(0.59),CutPan1.new({(0.7.rand2)}))]),SQPusher1.new);
)
a.play(c);

a.pause; 

a.resume;

a.end;

///////////////mixer
(
var w, startButton, amp0, amp1, amp2;
var amp3, amp4,amp5;
var gain0,gain1,gain2,gain3,gain4,gain5,weta,feedbacker,delayer;
var id, cmdPeriodFunc;

SynthDef("mixer1",{arg a0=0,a1=0,a2=0,a3=0,a4=0,a5=0,g0=1,g1=1,g2=1,g3=1,g4=1,g5=1,wet=0.3,buffer,delayTime=2,feedback=0.9;
var a,b,c,d,e,f,w,z,g;
a=((In.ar([10,11])*g0).softclip)*a0;
b=((In.ar([20,21])*g1).softclip)*a1;
c=((In.ar([30,31])*g2).softclip)*a2;
d=((In.ar([40,41])*g3).softclip)*a3;
e=((In.ar([50,51])*g4).softclip)*a4;
f=((In.ar(60,2)*g5).softclip)*a5;
	z = PingPong.ar(buffer,f, 1.0/(delayTime), feedback, 1);
w = z;
	4.do({ w = AllpassN.ar(w, 0.2, {[0.1.rand,0.1.rand] }.dup(2), 2) });
	z = (z*(1-wet)) + (w * wet);
	
	Out.ar(0,Mix.new([a,b,c,d,e,z]));
}).store;


id = s.nextNodeID; // generate a note id.

// make the window
w = SCWindow("another control panel", Rect(20, 380, 440, 560));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);

w.view.background = Color(0.5,0.6,0.1,0.3);

// add a button to start and stop the sound.
startButton = SCButton(w, 75 @ 24);
startButton.states = [
	["Start", Color.black, Color(0.3,0.9,0.5,0.3)],
	["Stop", Color.white, Color(1.0,0.1,0.1,0.8)]
];
startButton.action = {|view|
		if (view.value == 1) {
			// start sound
			s.sendMsg("/s_new", "mixer1", id, 0, 0, 
				"a0", amp0.value,
				"a1", amp1.value,
				"a2", amp2.value,
				"a3", amp3.value,
				"a4", amp4.value,
				"a5", amp5.value,
				"g0", gain0.value,
				"g1", gain1.value,
				"g2", gain2.value,
				"g3", gain3.value,
				"g4", gain4.value,
				"g5", gain5.value,
				"wet", weta.value,
				"feedback",feedbacker.value,
				"delayTime",delayer.value
				
				);
		};
		if (view.value == 0) {
			// set gate to zero to cause envelope to release
			s.sendMsg("/n_free", id);
		};
};

// create controls for all parameters
w.view.decorator.nextLine;
amp0 = EZSlider(w, 300 @ 24, "Amp10", €amp, 
	{|ez| s.sendMsg("/n_set", id, "a0", ez.value); }, 0);
	
w.view.decorator.nextLine;
gain0 = EZSlider(w, 270 @ 22, "gain10", [1,2048,€exponential,0], 
	{|ez| s.sendMsg("/n_set", id, "g0", ez.value); }, 1);
	
	
w.view.decorator.nextLine;
amp1 = EZSlider(w, 300 @ 24, "Amp20",€amp, 
	{|ez| s.sendMsg("/n_set", id, "a1", ez.value); }, 0);

w.view.decorator.nextLine;
gain1 = EZSlider(w, 270 @ 22, "gain20", [1,2048,€exponential,0], 
	{|ez| s.sendMsg("/n_set", id, "g1", ez.value); }, 1);
	
	
w.view.decorator.nextLine;
amp2 = EZSlider(w, 300 @ 24, "Amp30",€amp, 
	{|ez| s.sendMsg("/n_set", id, "a2", ez.value); }, 0);

w.view.decorator.nextLine;
gain2 = EZSlider(w, 270 @ 22, "gain30", [1,2048,€exponential,0], 
	{|ez| s.sendMsg("/n_set", id, "g2", ez.value); }, 1);
	
w.view.decorator.nextLine;
amp3 = EZSlider(w, 300 @ 24, "Amp40", €amp, 
	{|ez| s.sendMsg("/n_set", id, "a3", ez.value); }, 0);
	
w.view.decorator.nextLine;
gain3 = EZSlider(w, 270 @ 22, "gain40", [1,2048,€exponential,0], 
	{|ez| s.sendMsg("/n_set", id, "g3", ez.value); }, 1);
	
	
w.view.decorator.nextLine;
amp4 = EZSlider(w, 300 @ 24, "Amp50", €amp, 
	{|ez| s.sendMsg("/n_set", id, "a4", ez.value); }, 0);
	
w.view.decorator.nextLine;
gain4 = EZSlider(w, 270 @ 22, "gain50", [1,2048,€exponential,0], 
	{|ez| s.sendMsg("/n_set", id, "g4", ez.value); }, 1);
	
		
w.view.decorator.nextLine;
amp5 = EZSlider(w, 300 @ 24, "Amp60", €amp, 
	{|ez| s.sendMsg("/n_set", id, "a5", ez.value); }, 0);
	

w.view.decorator.nextLine;
gain5 = EZSlider(w, 270 @ 22, "gain60", [1,2048,€exponential,0], 
	{|ez| s.sendMsg("/n_set", id, "g5", ez.value); }, 1);
	
	

w.view.decorator.nextLine;
weta = EZSlider(w, 270 @ 22, "Wet", [0,1,€linear,0], 
	{|ez| s.sendMsg("/n_set", id, "wet", ez.value); }, 0);
	
w.view.decorator.nextLine;
feedbacker = EZSlider(w, 270 @ 22, "FeedBack", [0,1,€linear,0], 
	{|ez| s.sendMsg("/n_set", id, "feedback", ez.value); }, 0);
	
w.view.decorator.nextLine;
delayer = EZSlider(w, 270 @ 22, "DelayTime", [0.4,8,€linear,0], 
	{|ez| s.sendMsg("/n_set", id, "delayTime", ez.value); }, 1.25);
	
	
	
// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0; };
CmdPeriod.add(cmdPeriodFunc);

// stop the sound when window closes and remove cmdPeriodFunc.
w.onClose = {
	s.sendMsg("/n_free", id);
	CmdPeriod.remove(cmdPeriodFunc);
};

t = Tempo.new;
t.bpm = 65;
t.gui;
)


_________________

b = Buffer.alloc(s,44100);

(
Instr("Breakcore_fx",{ arg out=0,amp=0, bufnum;

	Out.ar(out,
		Pan2.ar( Breakcore.ar(bufnum, In.ar(0,2)*amp, Impulse.kr(4),5512/LFNoise1.kr(0.2,4),1),0)
	)
}).test;
)




_____________
(
Instr("Conv",{arg note=57,amp=0,lpf=8000;
var z;
z=Pan2.ar(
	LPF.ar(
		Convolution.ar((In.ar(50,2)+In.ar(10,2))*amp, 
			Mix.ar(Pulse.ar([note,note+5,note+12,note+9].midicps,0.15,0.25)), 1024, 0.5),
		lpf)
	,0.5);
	Out.ar(0,z)
},
#[
€nil,€amp,€freq
]);
p=Patch.new([ 'Conv' ],
	[
		StreamKrDur( 
			 Pshuf([0,5,12,-5]+47, inf),
			 // a float
			 0.1),
		

	  ]);   
	 p.gui;
)
