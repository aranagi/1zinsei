# coding: utf-8

#フルパスをロードパスに追加
fullpath=File.dirname(File.expand_path(__FILE__))
$:.unshift fullpath

#よみこむ
require 'user_stream'
require 'twitter'

#tokenの設定
require './token.rb'

UserStream.configure do |config|
	config.consumer_key = Consumer_key
	config.consumer_secret = Consumer_secret
	config.oauth_token = Oauth_token
	config.oauth_token_secret = Oauth_token_secret
end

client = Twitter::REST::Client.new do |config|
	config.consumer_key = Consumer_key
	config.consumer_secret = Consumer_secret
	config.access_token = Oauth_token
	config.access_token_secret = Oauth_token_secret
end

lastid = 0 #最後に確認したtweetのID
wish = "" #やりたいこと内容
hashtag = "#テス" #検索する内容

#lastid.dat読み込み
open(fullpath+"/lastid.dat",'r:utf-8') {|file|
	lastid=file.readlines[0].to_i
}

#自分のtweetをたどる
client.user_timeline.reverse_each { |tweet| #古いものから処理するためにreverse_each
	id=tweet.id.to_i

	if id <= lastid #既に確認済みのtweetのときスキップ 
    	next
	else #確認済みでないtweetのとき
  		#タグで始まってたらピックアップ
		if /#{hashtag}.*/ =~ tweet.text then
    		#タグじゃない部分を切り出す
  	  		wish = tweet.text.sub(/#{hashtag}\s*/,'')
  	  		#保存したい
  	  		#とりあえず出力
  	  		puts wish
    	else
    	end
  	end

  	#lastid.dat更新
    open(fullpath+"/lastid.dat",'w:utf-8') {|file|
      file.write(id)
    } 
}
