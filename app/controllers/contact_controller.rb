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
      str += years.to_s + ' years '
    end
    if months != 0
      str += months.to_s + ' months '
    end
    if days == 1
      str += days.to_s + ' day ago'
    elsif days != 0
      str += days.to_s + ' days ago'
    else
      str += 'less than 1 day ago'
    end

    result = {
      'date_diff' => str, 
      'years' => years, 
      'months' => months, 
      'days' => days,
      'in_days' => in_days
    }
  end

  def collect
    to_draw_array = []
    contacts_array = []

    if params['search_term'] == ''
      contacts_array = Contact.all
    else
      contacts_array = Contact.find(:all, :conditions => ["name like ?", "%" + params['search_term'] + "%"])
    end

    contacts_array.each do |c|
      red = c.red_val
      date_array = date_count(c.last_date)
      if red == 0
        color = "green"
      elsif date_array["in_days"] > red
        color = "red"
      elsif date_array["in_days"] > red / 2
        color = "yellow"
      else
        color = "green"
      end
      to_draw_array.push({'id' => c.id, 'name' => c.name, 'color' => color, 'date' => date_array["date_diff"]})
    end

    render :json => { answer: to_draw_array }
  end

end