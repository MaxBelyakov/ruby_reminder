class ContactController < ApplicationController

  # Computing each contact parameters
  def define_parameters(var_date, red_value)
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

    # Define color
    if red_value == 0
      color = "green"
    elsif in_days > red_value
      color = "red"
    elsif in_days > red_value / 2
      color = "yellow"
    else
      color = "green"
    end

    result = {
      'date_diff' => str, 
      'years' => years, 
      'months' => months, 
      'days' => days,
      'in_days' => in_days,
      'color' => color
    }

  end


  # Collecting array of contacts to draw on page
  def collect
    to_draw_array = []
    contacts_array = []

    if params['search_term'] == ''
      contacts_array = Contact.find(:all, :order => params["order"])
    else
      contacts_array = Contact.find(:all, :conditions => ["name like ?", "%" + params['search_term'] + "%"])
    end

    contacts_array.each do |c|
      param_array = define_parameters(c.last_date, c.red_val)
      to_draw_array.push({'id' => c.id, 'name' => c.name, 'color' => param_array["color"], 'date' => param_array["date_diff"]})
    end

    render :json => { answer: to_draw_array }
  end



  def update_date
    Contact.find_by_id(params['id']).update_attributes(:last_date => Date.today.to_s)
    render :json => { }
  end


  # Update name and position of each contact
  def update_list
    Contact.find_by_id(params['id']).update_attributes(:name => params['name'], :position => params['position'])
    render :json => { }
  end


  # Update selected contact's red value and define new color
  def update_color
    red = params['red'].to_i
    Contact.find_by_id(params['id']).update_attributes(:red_val => red)
    last_date = Contact.find_by_id(params['id']).last_date.to_s
    new_array = define_parameters(last_date, red)
    render :json => { answer: new_array['color'] }
  end


  # Add new contact
  def add_new
    find_name = Contact.where(name: params['name'])
    if find_name.length > 0
      render :json => { answer: 'duplicate!' }
    else
      Contact.create(:name => params['name'], :last_date => Date.today.to_s, :position => params['position'], :red_val => 30)
      render :json => { answer: 'added' }
    end
  end


  # Delete contact
  def delete
    Contact.find_by_id(params['id']).try(:delete)
    render :json => { }
  end



  def settings
    input_length = params['name'].length
    red_value = Contact.find_by_id(params['id']).red_val
    render :json => {red_value: red_value, name: params['name'], length: input_length}
  end

end