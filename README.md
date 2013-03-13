# Setup

* When pulling code from github make sure to drop and rebuild your database when the schema changes

    rake db:drop
    rake db:migrate

# Coding Guidelines

* Insert two spaces instead of a tab (configure your editor to do this for you)

# TODO

* Add text to shapes
* Add chat
* Add faye client/server
* Broadcast chat
* Broadcast brainstorm phases
* Broadcast votes
* Broadcast graffle updates
* Animate graffle updates
* [SE|DONE] Add users
* [SE|DONE] Add brainstorm sessions
* [SE|DONE] Add region for navigating through decision process steps
* [SE|DONE] Create views for 'Department A', 'Department B' and 'Your Department' (coupled to user/sporting depA and depB locked)
* [SE|DONE] Add vote view sporting all users Departments
* [SE|DONE] Add view for consolidating brainstorm
* [SE|DONE] Implement destoying shapes/connections
* [SE|DONE] Make sure shapes only persist when dragged below menu
* [SE|DONE] Disallow dragging shapes onto menu
* [SE|DONE] Fix cursor when creating connections
* [SE|DONE] Disallow creating connection ontop menu
* [SE|DONE] Fix mass assignment configuration
* [SE|DONE] Implement showview for graffles
