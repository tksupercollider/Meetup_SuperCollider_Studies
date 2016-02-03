//SCLang言語入門

------------------
//Hello World!
"Hello World!".postln;


------------------
//Variable 変数
a = 1;
a.value;

~a = 3;
~a.value;

------------------
//型
//Integer
1
-12

2r10 //二進数
16r0f //十六進数

0xff //hex Integer



//Float
0.1
2pi
12e-2


//Char
'0'

//String
"foo"
"foo"+"bar"
"foo"++"bar"


------------------
//Collection 配列(List,Array,Set,Dictionary...)
[];
[0,1,2,3];

(8..20);
(2,3..10);
1.dup(3);
1 ! 3;

a = [0,1,2,3];
a.at(3);
a.add(20);
a.put(2,100)

a.scramble;

------------------
//Operators 演算子
//Unary Operators 一項演算子
neg .. inversion  //正負反転
reciprocal .. reciprocal //逆数
abs .. absolute value //絶対値
sqrt .. square root //平方根
midicps .. MIDI note number to cycles per second //MIDIノートナンバ -> 周波数
...

1.neg;
64.midicps;

//Binary Operators 二項演算子
+ .. addition
- .. subtraction
* .. multiplication
/ .. division
% .. float modulo
<  .. less than
<= .. less than or equal
>  .. greater than
>= .. greater than or equal
== .. equal
..

1 + -2;
0 < 2;
//see also [ Operators ]...

------------------
//Function 関数
{};
a = {};
a = { 2 + 3 };
a.value;


a = { 2.0.rand };
a.value;
a.value;
a.value;
a.value;


------------------
//Control Strutres 分岐
//If
if (expr, trueFunc, falseFunc);


(
var a = 1, z;
z = if (a < 2, { 100 },{ 200 });
z.postln;
)


//While
while ( testFunc, bodyFunc );


(
i = 0;
while ( { i < 5 }, { i = i + 1; "boing".postln });
)


//For
for ( startValue, endValue, function )


for (3, 7, { arg i; i.postln }); // prints values 3 through 7


//Do
do ( collection, function )
..or..
collection.do(function)


5.do({ arg item; item.postln });

"you".do({ arg item; item.postln });

(5,6..12).do({ arg item; item.postln });

//Switch
(
var z;
z = [0, 1, 1.1, 1.3, 1.5, 2];
switch (z.choose.postln,
	1,   { \no },
	1.1, { \wrong },
	1.3, { \wrong },
	1.5, { \wrong },
	2,   { \wrong },
	0,   { \true }
).postln;
)


------------------
//Iterator イテレーター、ジェネレーター
//Streamをつかったイテレーター
(
a = Routine({
		3.do({ arg i; i.yield; })
	});

4.do({ a.next.postln; });
)

//Patternオブジェクトをつかったイテレーター
(
a = Pseq( [0,1,2,3], 2 );
b = a.asStream;
10.do({ b.next.postln; });
)




a = Pseq( [0,1,2,3], 2 );
b = a.asStream;
b.next;
b.next;
b.next;




//EventPlyer
(
a = Pseq( [0,1,2,3], inf );
b = a.asStream;
c = Routine({
		loop({
			b.next.postln;
			0.1.wait;
			 });

	});
c.play;
)
c.stop;





(
a = Routine({ loop {
		"***".postln; 0.5.wait;
		"_*_".postln; 0.1.wait;
} }).play(quant:[1, 0.4]);
)
a.stop;


//see Also [ Streams ]..
