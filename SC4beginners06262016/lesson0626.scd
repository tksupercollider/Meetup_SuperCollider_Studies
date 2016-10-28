// SuperCollider
// 言語的にはオブジェクト指向
// クラス --- 大文字で始まる
// メソッド --- クラスオブジェクトに対して
//             行なう

// 例.
// サイン波を生成するクラス --- SinOsc
// サイン波を生成するには、arというメソッドを使う
// --- SinOsc.ar

// メソッドには、予め引数がいくつか用意されている
// SinOsc.ar(周波数, 位相, 増幅値, 加減値);

{SinOsc.ar(440, 0, 1, 0)}.play;

// ノコギリ波
{Saw.ar(440, 1, 0)}.play;

// 組み合わせて波形を生成することができる
(
{SinOsc.ar(
	440,
	SinOsc.ar(110, 0, pi, 0), // 変調 modulation
	1,
	0
)}.play;
)

(
{Saw.ar(
	440,
	SinOsc.ar(110, 0, 0.4, 0.5), // 変調
	0
)}.play;
)

//////////////////////

// 予めクライアントからサーバーへ
// 後で出す音の設計図を送っておき、
// 出したいタイミングで音を出す

// 音の設計図 --- SynthDef
// SynthDef.new(\音の名前, 音の関数)
// 関数は {   }内に記述する
// 関数には引数(arg)を設けることができる
// データを処理していく上で、いったんデータを格納する箱
// のようなものを、変数(var)という
// 変数に数値を入れるには = を使う
// １つの文は;で終わる
(
SynthDef.new(
	\soundA,
	{arg freq=440, amp=0.3; // 引数
		var src; // 変数
		src = SinOsc.ar(freq, 0, amp, 0);
		Out.ar(0, src);
}).send(s); // 設計図をサーバーへ送る
// sはServerを表す
)

(
// 音を鳴らす
s.sendMsg(
	\s_new, // 「音を鳴らせ！」
	\soundA, // 音の名前
	1001, // ノードの番号
	0, // ノードの位置指定
	   //（0: グループの先頭、1: グループの最後尾)
	1, // ノードのグループ指定
	\freq, // 引数名
	660, // 引数に入れる数値
	\amp,
	0.18
);
)

(
// 音のパラメーターを変更する
s.sendMsg(
	\n_set, // 「音のパラメーターを変更せよ！」
	1001, // ノード番号
	\freq,
	550
);
)

(
// 音を止める
s.sendMsg(
	\n_free, // 「音を止めろ！」
	1001 // ノード番号
);
)


///////////////////////
(
SynthDef.new(
	\osc1,
	{arg freq=10, amp=1, outBus=16;
		var src;
		src = SinOsc.ar(freq, 0, 500, 600);
		Out.ar(outBus, src);
}).send(s);

SynthDef.new(
	\osc2,
	{arg amp=0.3, inBus=16;
		var in, src;
		in = In.ar(inBus, 1);
		src = Saw.ar(in, amp, 0);
		Out.ar(0, src);
}).send(s);
)

(
// osc1を出力
s.sendMsg(
	\s_new,
	\osc1,
	1002, // ノード番号
	0, // ノードの位置指定
	1, // グループ指定 ---> グループ1の先頭にノードを置く
	\outBus,
	16
);
)

(
// osc2でosc1のデータを受ける
s.sendMsg(
	\s_new,
	\osc2,
	1003,
	1,
	1, // グループ1の最後尾にノードを置く
	\inBus,
	16
);
)

(
s.sendMsg(
	\n_set,
	1002,
	\freq,
	5
);
)

(
s.sendMsg(\n_free, 1002);
s.sendMsg(\n_free, 1003);
)

// グループの作成
s.sendMsg(
	\g_new,
	2, // グループ番号
	3, // 指定したグループの後に置く
	1  // グループ指定
);

Group
Bus

NetAddr.new("127.0.0.1", 57110);
// 57110 --- scsynth
// 57120 (or 57121) --- sclang