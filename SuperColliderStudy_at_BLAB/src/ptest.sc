composition
s=Server.local;

m=NodeProxy.audio(s,2);
m.play;
m.source={FSinOsc.ar(45,0,0.1).dup.abs};
m.fadeTime=4.0;

m[2]={SinOsc.ar(818,LFNoise2.ar(20,1),SinOsc.ar(250,0,LFNoise2.ar(216,0.2))).dup};

//m.filltre(2,{});

m[0]={FSinOsc.ar(98,FSinOsc.ar(0.2),LFNoise2.ar(70,0.1)).dup};
m[1]={FSinOsc.ar(9903,0,LFNoise2.ar(334,0.1)).dup};
m[0]={Pulse.ar(8238,FSinOsc.ar(339),LFNoise2.ar(84,0.2)).dup};
m[2]={FSinOsc.ar(154,PinkNoise.ar(0.3,1),SinOsc.ar(56,0,LFNoise2.ar(126,0.1))).dup};
m[1]={FSinOsc.ar([67,846,10878],0,0.3)*Decay2.ar(Dust.ar(0.4),0.6,1)};

m[3]={FSinOsc.ar(58,FSinOsc.ar(0.2),LFNoise2.ar(1,0.1)).dup};
m[4]={FSinOsc.ar(2398,FSinOsc.ar(0.2),LFNoise2.ar(1,0.1)).dup};
m[0]={ Klank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(8, 0.1)*0.1).dup };


m.fadeTime=6.0;
m.end;
m.clear;

_____________________________________

p=ProxySpace.push(s.boot);

~a;
~a.play;
~a.fadeTime=5;
~a={Pan2.ar(SinOsc.ar([0,1,3,5,11,12,14]+68.midicps,SinOsc.ar(2),0.2),Saw.ar(1,1))};

~d={Pan2.ar(SinOsc.ar([0,2,3,5,7,9,11,12]+54.midicps,LFPulse.ar(2),0.3),Saw.ar(1))};
~d.fadeTime=7;
~d.play;
~c=~a wrap2:~d*0.3;
~c.play;
~c.fadeTime=8;
~a.end;
~d.end;
~c.end;