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

    RAILS_ENV=production rake assets:precompile

Connect via ssh:

    ssh root@46.101.228.108

Go to the project folder:

    cd /home/rails/scharwerk

Get new version:

    git pull

Update project:

    bundle
    . /etc/default/unicorn
    RAILS_ENV=production rake db:migrate

If styling changed:
    
    service unicorn restart
    service nginx reload

Visit http://46.101.228.108/

# Loadind data

* clone text into 

    mkdir app/assets/git/
    git clone git@github.com:marx-in-ua/das-kapital.git .
    git checkout test

* copy images to public/files/images/

## Generate tasks, should look like:

    RAILS_ENV=production rake scharwerk:generate_tasks['franko/*','test','franko',5]


## Todo


