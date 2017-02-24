# Das Scharwerk

Das Scharwerk is distributed publishing system.

## How to start local

1. Install rails http://railsapps.github.io/installing-rails.html
2. Install deps
        
    bundler install

3. Run and go to http://localhost:3000/

    rails s

## Codestyle

Please, before push to github run in console, in your project folder:

    rubocop

## migration

    rake db:migrate RAILS_ENV=test

## Deployment
    
Before deployment. If assets changed:

    RAILS_ENV=production rake assets:clobber 
    RAILS_ENV=production rake assets:precompile

Connect via ssh:

    ssh root@46.101.228.108

Go to the project folder:

    cd /home/rails/scharwerk

Config sidekiq. Copy upstart/sidekiq.conf to /etc/init/sidekiq.conf. Set the PASSWORD_GOES_HERE 
in file. Start by: 

    start sidekiq index=0
    sudo service sidekiq restart index=0

Logs in /var/log/upstart/sidekiq-0.log

Get new version:

    git pull

Update project:

    bundle install --without development test
    . /etc/default/unicorn
    RAILS_ENV=production rake db:migrate

If styling changed:
    
    service unicorn restart
    service nginx reload

Visit http://46.101.228.108/

# Loadind data

* clone text into 

    cd db/
    mkdir git/
    cd git/
    git clone git@github.com:marx-in-ua/das-kapital.git .
    git checkout test

* copy images to public/files/images/

* Generate tasks:

    RAILS_ENV=production rake scharwerk:generate_tasks['franko/*','test','franko',5]

    RAILS_ENV=production rake scharwerk:generate_tasks['ii/*','first_proof','book_2',5]
    RAILS_ENV=production rake scharwerk:generate_tasks['franko/*','first_proof','franko',3]
    RAILS_ENV=production rake scharwerk:generate_tasks['iii.2/*','first_proof','book_3_2',3]

## Todo

  Autologin on proof
  × add multiplication char (check to replace all x)
  

