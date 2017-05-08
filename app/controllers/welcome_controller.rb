require 'open-uri'
require 'mechanize'

class WelcomeController < ApplicationController
  def index
  end

  def repopulate

    mechanize = Mechanize.new
    netflix = mechanize.get('https://www.netflix.com/login')

    #netflix = open('https://netflix.com/browse/genre/43040', http_basic_authentication:["USERNAME", "PASSWORD"])
    response_status = netflix.code.to_i
    response_body = netflix.content

    form = netflix.forms.first
    #puts form
    File.open('response.txt', 'w+') do |f|
      f.write(response_body.encode!('UTF-16', 'UTF-8'))
    end
    form['email'] = 'EMAIL_HERE'#Type in Email for Netflix account
    form['password'] = 'PASSWORD_HERE'#Type in Password for Netflix account
    form['rememberMe'] = 'on'
    netflix = form.submit
    response_status = netflix.code.to_i
    response_body = netflix.content
    File.open('login_response.txt', 'w+') do |f|
      f.write(response_body.encode!('UTF-16', 'UTF-8'))
    end
    cookie = Mechanize::Cookie.new('profilesNewSession', '0')
    cookie.domain = ".netflix.com"
    cookie.path = "/"
    mechanize.cookie_jar.add(cookie)
    #specify genre code here:
    #Example below is action comedy, can specify genre code
    genre = '43040'
    #URL sorts titles from A-Z
    netflix = mechanize.get("https://www.netflix.com/browse/genre/#{genre}?so=az")
    response_status = netflix.code.to_i
    response_body = netflix.content
    File.open('browse_response.txt', 'w+') do |f|
      f.write(response_body.encode!('UTF-16', 'UTF-8'))
    end
    data = File.read('browse_response.txt')
    m = data.scan(/aria-label=\"(.+?)\"/m)
    count = 0
    deleteAll
    m.each do |movie|
      #used aria-label to extract movie titles, but this was also attached to the netflix logo, search, and account
      #Removed the first three results as the rest were just movies, which we need
        if count > 3
          getRating(movie)
        end
        count = count + 1
    end
  end

  def getRating(movie)
    mechanize = Mechanize.new
    rottenTomatoes = mechanize.get("https://www.rottentomatoes.com/search/?search=#{movie}")
    response_status = rottenTomatoes.code.to_i
    response_body = rottenTomatoes.content
    File.open('rotten_response.txt', 'w+') do |f|
      f.write(response_body.encode!('UTF-16', 'UTF-8'))
    end
    data = File.read('rotten_response.txt')
    m = data.scan(/meterScore\":(.+?),/m).first
    if !m.nil?
      m = m.first
    end
    puts m
    mr = MovieRating.new
    mr.name = movie.first
    mr.rating = m.to_i
    mr.save!
  end

  def deleteAll
    MovieRating.destroy_all
  end
end
