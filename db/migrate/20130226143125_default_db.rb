class DefaultDb < ActiveRecord::Migration
  def up
    c = []
    c.push(Contact.new(:name => "Freddie Mercury", :last_date => "2012-12-12", :position => "1", :red_val => "30"))
    c.push(Contact.new(:name => "Sherlock Holmes", :last_date => "2012-11-11", :position => "2", :red_val => "30"))
    c.push(Contact.new(:name => "Hercule Poirot", :last_date => "2012-11-11", :position => "3", :red_val => "30"))
    c.push(Contact.new(:name => "James Kirk", :last_date => "2012-11-11", :position => "4", :red_val => "30"))
    c.push(Contact.new(:name => "Al Pacino", :last_date => "2012-11-11", :position => "5", :red_val => "30"))
    c.push(Contact.new(:name => "Hugh Laurie", :last_date => "2012-11-11", :position => "6", :red_val => "30"))
    c.push(Contact.new(:name => "Spock", :last_date => "2012-11-11", :position => "7", :red_val => "30"))
    c.push(Contact.new(:name => "Harry Potter", :last_date => "2012-11-11", :position => "8", :red_val => "30"))
    c.push(Contact.new(:name => "Morgan Freeman", :last_date => "2012-11-11", :position => "9", :red_val => "30"))
    for i in c
      i.save
    end
  end
end
