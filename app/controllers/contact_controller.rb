class ContactController < ApplicationController
  def date_count(var_date)
    str = ''
    date1 = var_date
    diff = Time.now.to_i - date1.to_time.to_i
    in_days = diff / (60*60*24) # full amount of days
    years = diff / (365*60*60*24)
    months = (diff - years * 365*60*60*24) / (30*60*60*24)
    days = (diff - years * 365*60*60*24 - months*30*60*60*24)/ (60*60*24) # XXXX.XX.XX - years - months = days

    if years != 0
      str = str + years.to_s + ' years '
    end
    if months != 0
      str = str + months.to_s + ' months '
    end
    if days == 1
      str = str + days.to_s + ' day ago'
    elsif days != 0
      str = str + days.to_s + ' days ago'
    else
      str = str + 'less than 1 day ago'
    end

    result = {
      'date_diff' => str, 
      'years' => years, 
      'months' => months, 
      'days' => days,
      'in_days' => in_days
    }
  end

  def show
    #Contact.all.each do |c|

    @red = 30
    date_array = date_count("2012-01-26")


    if @red == 0
      @color = "green"
    elsif date_array["in_days"] > @red
      @color = "red"
    elsif date_array["in_days"] > @red / 2
      @color = "yellow"
    else
      @color = "green"
    end

  end
end