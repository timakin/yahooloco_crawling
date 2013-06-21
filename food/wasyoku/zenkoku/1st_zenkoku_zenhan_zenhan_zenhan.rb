# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'timeout'
require 'csv'
require 'nkf'

begin
(1..9).each do |hogya|
  p "産　業　が　か　わ　っ　た　よ　ん"
(1..9).each do |fuga|
  p "都　道　府　県　が　か　わ　っ　た　よ　ん"
(1..9).each do |hoge|
  p "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#{hoge}"
(0..99).each do |i|
  p "=======================#{i}"
  url = "http://search.loco.yahoo.co.jp/search?areacd=0#{fuga}20#{hoge}&genrecd=010100#{hogya}&property=&ei=UTF-8&xargs=#{i+1}&b=#{i}1"
  doc=Nokogiri::HTML(open(url).read)
  CSV.open("zenkoku_wa.csv", "a") do |csv| # CSVファイルを生成
      if doc.xpath('//*[@id="S1ak"]/p/em').inner_text.include?('Not found')
        p 'not found' # 施設情報が無いページの場合
      else
        doc.css('div.tl > h3 > a').each do |item|
        p "======================================"
          url2=item[:href]
          p "行き先：" + url2
          doc2=Nokogiri::HTML(open(url2).read)
              #title
              doc2.css('div.ttl > h1 > a').each do |elem|
                $s = elem.text # 施設名を取得
                p "Title:#{$s}"
                #csv << [s]
              end

              #url
              doc2.css('p.c > a').each do |elem|
                if /^http:/ =~ elem[:href] # URLの書式に合致する場合
                  $u = elem[:href]
                  #csv << [u]
                  p "url:#{$u}"
                end
              end

              #email
              doc2.css('p.c').each do |elem| # email or url を取得
                test = elem.children.inner_text.rstrip.gsub(/(\s|　)+/, '')
                if /^[0-9A-Za-z\._-]+@[0-9A-Za-z\._-]+[a-z]/ =~ test # emailの書式に合致する場合
                  $e = test.gsub(/[^\x01-\x7E]|[ァ-ー]|[ぁ-ヶ]|[亜-黑]/, '')
                  #csv << [e]
                  p "email:#{$e}"
                  csv << [$s, $e, $u]
                end
              end
              $e, $u = nil, nil
        end
      end
  end
end
end
end
end

rescue => e
  STDERR.puts e
rescue Timeout::Error => e
  STDERR.puts e
end

