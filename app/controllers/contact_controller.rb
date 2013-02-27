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
    html_code = ''

    Contact.all.each do |c|

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

      html_code += '<li>'
      html_code += '<div class="contact_container_' + color.to_s + '" id="' + c.id.to_s + '">'
      # ===name_container===
      html_code += '<div class="name_container">'
      html_code += '<div class="contact_name" id="contact_name_' + c.id.to_s + '">' + c.name.to_s + '</div>'
      html_code += '<div class="contact_edit" id="contact_edit_' + c.id.to_s + '">'
      html_code += '<img src="edit.png"></img>' 
      html_code += '</div>'
      html_code += '<div class="contact_delete" id="contact_delete_' + c.id.to_s + '">'
      html_code += '<img src="no.png"></img>' 
      html_code += '</div>'
      html_code += '</div>'
      # ===/name_container===
      # ===contact_date===
      html_code += '<div class="contact_date_diff">'
      html_code += '<div class="contact_update" id="contact_update_' + c.id.to_s + '">'
      html_code += '<img src="update.png"></img>' 
      html_code += '</div>'
      html_code += date_array["date_diff"]
      html_code += '</div>'
      # ===/contact_date===
      html_code += '</div>'
      html_code += '</li>'

    end
    @html_code = html_code.html_safe
  end

end