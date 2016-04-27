// SuperCollider workshop
// Making cute music and sound for begginers.
// 2016/04/24 Sun at tksc

// 01 SCの基本操作

1.コードを書くファイルウィンドウ
2.ヘルプブラウザ・ウィンドウ
3.結果を表示するPostウィンドウ

ファイルの選択した場所を実行していきます。

■01-01 サーバを起動／終了する
音を出すときに使うオーディオ・サーバを起動します
	Server.default.makeGui; // サーバーのguiパネルを開く
	Server.local.boot; // 起動する
	Server.local.quit;　// 終了する
	Server.local.waitForBoot({"BOOTED now".postln}); // 起動後に実行


■01-02 プログラムを実行する
・基本的に、実行したい部分を選択し、enterキーを押す（機種によりfn + return）

	{SinOsc.ar(440,0,0.5)}.play; // enterキーを押す（機種によりfn + return）


音がでないとき... サーバは起動している？
postウィンドウにエラーがでていないか？


・一行のみを実行したい場合は、カーソルのある行が実行される
	{SinOsc.ar(440,0,0.5)}.play; // カーソルをこの行に置き、実行

・括弧の上をダブルクリックすると、対応する括弧までが選択される

	( // この右の括弧をダブルクリックする
		var a, b, x;
		a = 10;
		b= 5;
		x = a + b;
	)

Try : サンプルのコードを実行してみよう。

SC > examples > demonstrations > SC2-examples_1.scd
SC > examples > pieces > spacelab.scd
SC > examples > pieces > acid_otophilia.scd


■01-03 エラーを読む
（下記のコードは、わざとエラーを起す様にしているので、実行しない様に！）

// 大文字小文字に気をつける
	Sinosc.ar ; // ･ ERROR: Class not defined.

// 括弧の過不足に気をつける
	(List[0,1,2)/ / ERROR: Parse error ... opening bracket was a '[', but found a ')'

// 文末の ; に気をつける
	(
		var a, b, x;
		a = 10
		b= 5;
		x = a + b;
	)
//･ ERROR: Parse error
//   in file 'selected text'
//   line 4 char 3:
//  		b･= 5;

この様なエラーがでたら、大抵、表示された行のちょっと前がおかしいことが多いです。
特定の行へは、command + , で移動する事ができます。

・日本語特有のもんだい
　バックスラッシュ、日本語のコメントの付いたファイルのload、文字列として扱えない

■01-04 見やすいコードを書く

	command +  ''  // 色を付ける。赤がコメント、青がクラス名、緑がシンボル
	command +  / //  コメントにする
	command +  ] // 右に寄せる

// コメントをつけるように、心がけましょう。

■01-05 ヘルプや情報の参照

・ヘルプの参照
	SinOsc.ar // command + shift + ?
・クラス定義の参照
	SinOsc.ar // command + J
・メソッドが定義されているクラスを表示
	"test".postln; // command + Y

■01-06 参考になるウェブサイト
tkscの日本語コミュニティサイト
Slak -- TokyoSuperCollider
https://tksupersollider.herokuapp.com

tkscのgitHub
https://github.com/tksupercollider

SuperColliderのメーリングリスト（英語）	http://www.beast.bham.ac.uk/research/sc_mailing_lists.shtml

SCCode コード集サイト

http://sccode.org
