//24, 30;

(
s = Server.local;
s.sendMsg(€b_allocRead, 10, "sounds/soz4.wav");
)

(
Instr(€bufplay, { arg bufnum = 10, tr=0.0, loc=0.25, rate=1.0, lpf=20000, rq=0.5, feedback=0.5,delayTime=3,wet=0.3, gain=1.0, amp= 0.0,buffer;
	var trig, w, out;
	trig = Impulse.kr(tr);
	//trig = Dust2.ar(tr);
	out 	= PlayBuf.ar(2,10,BufRateScale.kr(bufnum)*rate,trig,(loc+0.01)*BufFrames.kr(bufnum),1);
	out = RLPF.ar(out, lpf, rq);
	out = PingPong.ar(buffer.bufnumIr, out, 1.0/(delayTime), feedback, 1);
	out = (out*gain).softclip * amp;
	w = out;
	4.do({ w = AllpassL.ar(w, 0.1, LFNoise2.kr([rrand(0.1, 0.2),rrand(0.1, 0.2)],0.05,0.15), 3.0) });
	//4.do({ w = AllpassN.ar(w, 0.1,{[0.1.rand, 0.1.rand]}.dup(4), 1.0) });
	out = (out * (1.0 - wet)) + (w * wet);
},[
nil,
[0,20,€linear,0],
nil,
[-2,2,€linear,0.05],
€freq,
nil,
€amp,
[1,8,€linear,1],
nil,
[1,4096,€exponential,0],
€amp
]
).test;
)