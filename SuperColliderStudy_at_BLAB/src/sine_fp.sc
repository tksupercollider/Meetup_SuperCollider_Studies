(
Instr("sine_fp",{arg note=68,gate1=0,gate2=0,gate3=0,gate4,amp1=0,amp2=0,amp3=0,delay=0.07,decay=10; 
	var a,b,c,e,f,v,x,y,w,z;
	
	a=SinOsc.ar(note.midicps,SinOsc.ar(note.midicps*0.25),amp1);
	b=SinOsc.ar((note+5).midicps*0.25,SinOsc.ar(note.midicps),amp1);
	c=SinOsc.ar([0.01,0.03]+note.midicps,0,amp2);
	e=SinOsc.ar([0.02,0.03]+note.midicps*0.5,0,amp2);
	f=SinOsc.ar(([0.02,0.05]+note+5).midicps*0.25,SinOsc.ar(2),amp3*SinOsc.ar(note.midicps));
	
	
	x=(a+b)*EnvGen.kr(Env.linen(1.0, 0.41, 0.1, 0.5, 12), gate1, doneAction: 0);
	w=c*EnvGen.kr(Env.linen(1.8, 0.04, 0.1, 0.5, 12), gate2, doneAction: 0);
	y=e*EnvGen.kr(Env.linen(1.8, 0.01, 0.1, 0.5, 12), gate3, doneAction: 0);
	v=f*EnvGen.kr(Env.linen(1.8, 0.2, 0.1, 0.5, 12), gate4, doneAction: 0);
	
	z=CombL.ar(w+x+y+v, [0.2,0.25],0.8,0.5);
	
	4.do({ z = AllpassL.ar(z, 0.8, {[rrand(0.01, 0.03)+delay,rrand(0.01, 0.04)+delay]}, decay) });
	Out.ar(0,z);
},#[
	€nil,€nil,€nil,€nil,€nil,€amp,€amp,€amp,[0.01,0.15,€exp,0],[0,20,€linear,0],
]);  
p=Patch.new('sine_fp',
	[ 
	     StreamKrDur( 
			 Pshuf([68], inf),
			 Prand([37,40], inf),
			 0.1),
         StreamKrDur( 
			 Prand([0,1], inf),
			 Prand([6,4.5], inf),
			 0.1),
	     StreamKrDur( 
			 Pseq([0,1], inf),
			 Prand([0.5,1], inf),
			 0.1),
     	StreamKrDur( 
			 Pseq([0,1], inf),
			 Prand([0.5,1], inf),
			 0.1),
			 StreamKrDur( 
			 Pseq([0,1], inf),
			 Prand([0.5,1], inf),
			 0.1)
]);
  p.gui;
)