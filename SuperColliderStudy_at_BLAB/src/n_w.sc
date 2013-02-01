(
Instr("wav",{arg amp1=0,amp2=0;
var t1,trig1,trig2,seq,a,b;
t=Impulse.ar(1);


trig1=TDuty.ar(0.5,t,Dseq([4,1,0,4,0,3,0,2]*0.25, inf));
a=Pan2.ar( Klank.ar(`[[66, 2471, 2723], nil, [ 1, 1, 1]], ClipNoise.ar(0.2)) 
*Decay2.ar(trig1,0.01,0.1)*amp1,LFNoise1.ar(2));


seq = Drand([
		Dseq([0,0,5,0,7,3,9,5]+68,2),
		Dseq([3,5,7,5,3,7,7,5]+68)
		],inf);

		
trig2=Demand.ar(t,0,seq);
b=Pan2.ar(SinOsc.ar(trig2)*Decay2.ar(PulseDivider.ar(trig1,0.5),0.01,0.1)*amp2,LFNoise1.ar(4));

Out.ar(15,a+b);
},[
€amp,€amp]).test;




Instr("rev1",{arg amp=0,delay=0.12,decay=6;
var src,env,z;
	z=In.ar(15,2);
	z=AllpassL.ar(z,0.1,0.02,2);
	4.do({ z = AllpassL.ar(z, 0.1, {[rrand(0.01, 0.03)+0.4,rrand(0.01, 0.04)+delay]}.dup(2), decay) });
	Out.ar(0, z*amp);	
	},[
	€amp,[0,0.15,€linear,0],[0,20,€linear,0]
	
	]).test;
)