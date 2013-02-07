B-Lab SuperCollider勉強会_7.3


Just In Time Programming


Just In Time Programming(live coding)のためのライブラリのこと

スパコの大きな特徴がこのライブラリをつかった動的なコードの書き換え
によるプログラミングです。

これによってリアルタイムにコードを書き換えるon-the-flyな手法も可能です。


 サーバをブートします。
s = Server.local;
s.boot;

ProxySpaceをつかってあらかじめサーバにコードが走る場所をもうけます。
p = ProxySpace.push(s);


~の付いた変数でノードを作っていきます。

~x.play;

~x = { SinOsc.ar([400, 407], 0, 0.2) };


では音がなっている状態でコードを変えてみましょう。
~x = { pulse.ar([400, 407], 0.1, 0.2) };


.fadeTimeは指定した時間でXフェードをかけながら次のコードに代わっていきます
p.fadeTime = 5;


~x = { pulse.ar([1200, 1207], 0.1, 0.2) };

p.end;
p.clear
止めます



去年のSuperDeluxで行ったbend++でのライブ：http://jp.youtube.com/watch?v=Wvwg9hwwrzI

ライブコーディング集団"TOPLAP": http://toplap.org/index.php/Main_Page


ML

メーリングリストでは毎日質問や最新の話題が飛び交います。参加しましょう。

本家SCユーザーメーリングリスト：http://www.create.ucsb.edu/mailman/listinfo/sc-users
SCデベロッパリングリスト（開発者用）：http://www.create.ucsb.edu/mailman/listinfo/sc-dev