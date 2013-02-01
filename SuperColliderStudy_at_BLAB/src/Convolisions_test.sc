(
Instr("hasher",{arg amp=0,lpf=8000;
Pan2.ar(
	LPF.ar(Hasher.ar(LFNoise1.ar(0.1),amp),lpf),0.5);
},
[
€amp,€freq,[1,127,€linear,1]
]).test;
)



(
Instr("2hasher",{arg freq=0,amp=0,lpf=8000,note=57;
Pan2.ar(
	LPF.ar(
		Convolution.ar(Hasher.ar(LFNoise1.ar(0.1),0.5*amp), 
			Mix.ar(LFSaw.ar((freq+note).midicps,0,0.6)), 1024, 0.5),
		lpf)
	,0.5);
},
[
€nil,€amp,€freq,[1,127,€linear,1]
]);
p=Patch.new('2hasher',
	[
		StreamKrDur( 
			  Prand([9,0,4,12],inf),
			  Prand([0.25,0.5,1,1]/6,inf),0.01)

	  ]);   
	 p.gui;
)




(
//must have power of two framesize- FFT size will be sorted by Convolution to be double this
//maximum is currently a=8192 for FFT of size 16384
a=2048;
s = Server.local; 
//kernel buffer
g = Buffer.alloc(s,a,1);
)



(
//random impulse response
g.set(0,0.2);
80.do({arg i; g.set(a.rand, 1.0.rand)});


	{ var input, kernel;
		
	input=AudioIn.ar(1);	
	kernel= PlayBuf.ar(1,g.bufnum,BufRateScale.kr(g.bufnum),1,0,1);
	
	Out.ar(0,Median.ar(1,Convolution.ar(input,kernel, 2*a, 0.5).dup));
	 }.play;
 )
AudioMeter.new


(

	Instr("convo",{arg amp=0,note=60;
	 var input, kernel;
		
	input=AudioIn.ar(1)*amp;	
	kernel= Mix.ar(LFSaw.ar([note,note+5,note+3,note+15].midicps,0,1.0));

	//must have power of two framesize
	Out.ar(0,Convolution.ar(input,kernel, 1024, 0.5).dup);
	 },[€amp,[1,127,€linear,1]]).test;

)

_________________________________


(
Instr("2hasher",{arg amp=0,lpf=8000,note=57;
var z;
z=Pan2.ar(
	LPF.ar(
		Convolution.ar(In.ar(0,2)*amp, 
			Mix.ar(LFSaw.ar([note,note+4,note+12,note+9].midicps,0,0.6)), 1024, 0.5),
		lpf)
	,0.5);
	ReplaceOut.ar(0,z)
},
[
€amp,€freq,[1,127,€linear,1]
]).test;
)


________________________________


(
Instr("2hasher",{arg note=57,amp=0,lpf=8000;
var z;
z=Pan2.ar(
	LPF.ar(
		Convolution.ar((In.ar(40,2)+In.ar(10,2))*amp, 
			Mix.ar(LFSaw.ar([note,note+4,note+12,note+9].midicps,0,0.6)), 1024, 0.5),
		lpf)
	,0.5);
	Out.ar(0,z)
},
#[
€nil,€amp,€freq
]);
p=Patch.new([ '2hasher' ],
	[
		StreamKrDur( 
			 Pshuf([0,5,12,-5]+57, inf),
			 // a float
			 0.1),
		

	  ]);   
	 p.gui;

)