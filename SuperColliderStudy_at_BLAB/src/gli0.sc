(
Instr("step",{arg amp1=0,amp4=0,dur=7.5,md=0.1,delay=0.062,decay=0.6;
var trg,seq,c,d,t,u,z;

trg=Impulse.ar(dur,0.25);
seq = Drand([
		Dseq([4,1,1,0,1,1,4,1],2),
		Dseq([4,0,2,0,4,1,0,4]),
		Dseq([0,0,0,0,4,0,0,0]),
		Dseq([4,1,1,0,0,1,0,0])],inf);
		
t=Demand.ar(trg,0,seq);
u=Demand.ar(trg,0,seq);



c=Pan2.ar(RHPF.ar(GrayNoise.ar(0.4),15200,0.01), LFNoise1.ar(0.1))*Decay2.ar(trg,0.21,0.01,amp1*t).clip(-0.6,0.6);

d=PMOsc.ar([44,46],[8040,8060,1200,200],2,pi/4, 0.2) clip2: SinOsc.ar(8)*Decay2.ar(PulseDivider.ar(trg,2), 0.02,0.2, amp4*u);


z=CombL.ar(c, 0.13);

4.do({ z = AllpassC.ar(z, md, {[rrand(0.01, 0.1)+delay,rrand(0.01, 0.1)+delay]}, decay) });
Out.ar(0,z+c+d);

},#[
€amp,
€amp,
[0,10,€linear,0],
[0,1,€linear,0],
[0.01,0.15,€exp,0],
[0,20,€linear,0]

]).test;
)