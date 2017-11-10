class AsciifyController < ApplicationController
  def index
  end

  def show
    @lotto=(1..45).to_a.sample(6)
    #@lotto=[*1..45].sample(6)
  end
  
  
  def input
  
  end
  
  def output
    a=Artii::Base.new(font: params[:font])
    @keyword = a.asciify(params[:string])
    
  end
  
  def api
    require 'httparty'
    require 'json'

    uri = 'http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo='
    response = HTTParty.get(uri)
    result = JSON.parse(response.body)
   
    #이번주 로또 번호 및 보너스번호
    @arr = Array.new
    @bonus = Array.new
    result.each do |key, value|
    @arr << value if key.include? "drwtNo" # 만약에 key 값이 drwtNo를 포함하고 있으면 
          # 그 key 값의 값을 배열에 넣는다 파이썬 해쉬는 순서가 없다.
    @bonus << value if key.include? "bnusNo"
    end
    
    #사용자 로또번호
    @lotto=(1..45).to_a.sample(6)
    
    #겹치는 숫자
    @matching =@arr&@lotto
    
    #겹치는 개수
    intersection = @arr & @lotto
    @number=intersection.size
    
    #등수 매기기1
    if @matching.count == 6
       @result = "6개 맞았습니다. 1등입니다.(15억)"
    elsif @matching.count == 5 && @arr.include?(@bonus) 
       @result = "5개 맞았습니다. 2등입니다."
    elsif @matching.count == 5 
       @result = "5개 맞았습니다. 3등입니다."
    elsif @matching.count == 4 
       @result = "4개 맞았습니다. 4등입니다."
    elsif @matching.count == 3
       @result = "3개 맞았습니다. 5등입니다."
    elsif @matching.count == 2 
       @result = "2개 맞았습니다. 꽝입니다."
    elsif @matching.count == 1
      @result = "1개 맞았습니다. 꽝입니다."
    else 
      @result = "0개 맞았습니다. 꽝입니다."
    
    
    #등수 매기기2
    # case number
    # when 6
    # @result = "6개 맞았습니다. 1등입니다."
    # when 5
    # @result = "5개 맞았습니다. 2등입니다."
    # when 4
    # @result = "4개 맞았습니다. 3등입니다."
    # when 3
    # @result = "3개 맞았습니다. 4등입니다."
    # when 2
    # @result = "2개 맞았습니다. 5등입니다."
    # when 1
    # @result = "1개 맞았습니다. 6등입니다."
    # else
    # @result = "0개 맞았습니다. 꽝입니다."
    # end
    end 
  end

end
