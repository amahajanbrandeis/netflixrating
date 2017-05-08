# README

How To Use This Application, Instructions:
In Repopulate method in WelcomeController, add email and password for Netflix account. If you want to specify a genre besides Action Comedies, that
will also have to be changed manually. On running application, press repopulate database, and wait for the process to finish. Then to view the database,
press "Show Ratings". This will take you to a new page, where the movies are sorted by highest rated to lowest rated.

About:

This application allows a user to input their netflix credentials (where email and password are specified in the forms in the repopulate method)
and also allows them to specify a specific genre code that netflix does not openly share (also in the repopulate method). These codes are easily
found on google, but the current default is Action Comedies (code 43040). A user will have to manually input it in the code to get the genre they want.
This application is not user friendly, as I did not create a GUI. But as I continue to refine this application, I would allow for
user interaction through the application for them to click buttons for each genre. Else, I could also go through each genre page, and populate the database
that way, and have a large database. But that could be a long process, and a user would not be able to search by genre unless I created tags.

Some Problems:
Certain movies that have no rottentomatoes critic score, are marked as Not Rated. However, as Rating is implemented as an integer, this
translates to the number 0. So a movie rated 0% on rottentomatoes will have the same rating as one that was not rated at all.
I was also not able to figure out how to extract all movie information on a page. What is returned from the HTML of the browse/genre page is not
all of the information, because if a user scrolls down, then more movies are loaded on the page, most likely done through JavaScript. This is probably the
weak point of this application, but I could not figure out how to simulate this scrolling through the Mechanize gem. This is something that I would have to refine
in the future.

How To:
Currently, after a user puts in their Netflix credentials, and chooses a genre code in the repopulate method, in the actual application, they can press the repopulate
button to populate the database with movies from this genre, with their respective rottentomatoes score, sorted by highest rated first. If they decide to change the genre
or if they think the catalogue has changed, they can press repopulate again. Otherwise, pressing show ratings takes them to the sorted list.

Process:
The most difficult part was making sure the HTTP requests were taking us to the correct page. More specifically, for netflix, it was making sure we were able to input our
login credentials, access the first user account and then browse the specific genres. There were multiple methods that I explored, first starting with open-uri and adding
authentication credentials with an HTTP request. That did not work. Even with something like PostMan, an application that helps a user develop APIs through a gui, I could not
make an HTTP request with the correct credentials to netflix. I could not get passed the netflix login screen. Before I was going to use the Nokogiri gem to scrape html, but
this was not efficient. In order to get passed the netflix login, I needed something that would not just request HTML, but also let me fill out the forms. Utilizing the
Mechanize gem, a user is able to input the values of forms on the page, and submit those values. With this gem, which does have a dependency on Nokogiri, I was able to finally
make it past the login page. The next obstacle was figuring out how to select a user profile page, as that needs to be selected in order to browse the specified genre. As
before I thought there was a button to click, but nothing in the HTML suggested that we could assign a buttonclick as true, and inspecting the element did not show me any
listeners. I tried to specify the profile by name, and id, and assign those in the same manner as email and password fields (or using request_headers), but that did not work
either. What I did learn about the gem though, is that you can specify cookies, and store them. This allowed me to specify that the current user is user 0, the account owner's
profile. With this cookie stored, we can now access the browse section. Here I take the HTML returned from this page, and save it to a text file, where I can then scan and
extract certain elements, such as aria-label, which is attached to a specific movie title. Here we can call a find rating function which then repeats the same process of
scraping netflix, but instead searches for the movie title found in rottentomatoes and pulls the first relevant critic score. This is then saved to the database, which is later
sorted from highest scored to lowest scored. Problems with sites like rottentomatoes and imdb is that I had to give my HTTP request in a specific way. At least, when I tried
other methods, I would not be returned the search results. I would instead be taken to some default that asks the user to register, or an about page.

Through this project, I mostly learned the capabilities of the Mechanize gem as it contained the benefits of Nokogiri with the ability to save cookies and enter passwords.
These two issues were the greatest challenges I expected to face, but understanding the gem helped me overcome them. I also learned the basics of html scraping, and its
capabilities, especially since Netflix closed their APIs. With coding skills, I can create my own, even if this is the case. There is still a lot of refining I need to do
, but this project is one that I will use often to see what the netflix catalog has to offer, plus I can add the ratings of other websites like iMDB later on.        
