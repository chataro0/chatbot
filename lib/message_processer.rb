require File.expand_path(File.dirname(__FILE__)) + "/response.rb"
require File.expand_path(File.dirname(__FILE__)) + "/emoji.rb"

require File.expand_path(File.dirname(__FILE__)) + "/google_custom_search.rb"
require File.expand_path(File.dirname(__FILE__)) + "/tenki_jp.rb"
require File.expand_path(File.dirname(__FILE__)) + "/navitime.rb"

class MessageProcesser

  attr_reader :platform, :team, :response_type

  def initialize(platform, team, response_type)
    @platform = platform
    @team = team
    @response_type = response_type
    @gcs = GoogleCustomSearch.new({ response_type: @response_type })
    @tj = TenkiJp.new({ response_type: @response_type })
    @nt = Navitime.new({ response_type: @response_type })
  end

  def get_response(text)

    # Reminder
    text.gsub!(/^Reminder: (.+)\.\n?/, '\1')

    # Google Search
    if /^g(oogle)?(?<r>r)?[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, random: !r.nil?)

    # Google Search (image)
    elsif /^i(mage)?(?<r>r)?[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, search_type: "image", random: !r.nil?)

    # Google Search (Wikipedia)
    elsif /^wiki(pedia)?[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "ja.wikipedia.org")

    # Google Search (uncyclopedia)
    elsif /^uncy(clopedia)?[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "ansaikuropedia.org")

    # Google Search (youtube)
    elsif /^(you)?tube[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "youtube.com")

    # Google Search (niconico)
    elsif /^nico(nico)?[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "www.nicovideo.jp")

    # Google Search (nicodic)
    elsif /^n(ico)?dic[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "dic.nicovideo.jp")

    # Google Search (pixivdic)
    elsif /^p(ixiv)?dic[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "dic.pixiv.net")

    # Google Search (mhw)
    elsif /^mhw[\s　]+?(?<keyword>.+)$/ =~ text
      return @gcs.search(keyword, site: "mhwg.org")

    # tenki.jp
    elsif /^(tenki|weather|天気)[\s　]+?(?<area>.+)$/ =~ text
      return @tj.search(area: area)

    # navitime
    elsif /^(route|乗換)(?<candidate>\d)?[\s　]+?(?<dep>[^\s　]+?)([\s　]+|から)(?<arr>[^\s　]+?)([\s　]+?(?<ymd>\d{8}))?([\s　]+?(?<hm>\d{4})?(?<basis>発|着|始発|終電)?)?$/ =~ text
      return @nt.search(dep: dep, arr: arr, ymd: ymd, hm: hm, basis: basis, candidate: candidate)
    end

    return Response.new

  end

end

