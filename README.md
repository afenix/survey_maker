#Documentation for using Rake, Active Record, Shoulda, and other automations

First lets set up all of our files! I'm not going to go in to detail on this point.

In your app.rb file, put this:
```
require("bundler/setup")
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
```

In your spec_helper.rb file, put this:
```
ENV['RACK_ENV'] = 'test'

require("bundler/setup")
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }
```

In your other spec files, enter only this:
```
require('spec_helper')
```

We're going to run bundle from our Gemfile from now on, and also we're going to
parse out which gems we're using for our test environment here. In your Gemfile, put:
```
source("https://rubygems.org")

gem("sinatra")
gem("sinatra-contrib", :require => "sinatra/reloader")
gem("sinatra-activerecord")
gem("rake")
gem("pg")

group(:test) do
  gem("rspec")
  gem("shoulda-matchers")
end
```

Now let's make the Rake file:
```
require('sinatra/activerecord/rake')

namespace(:db) do
  task(:load_config) do
    require('./app')
  end
end
```

And finally, in your config folder, write your database.yml file:
```
development:
  adapter: postgresql
  database: survey_development

test:
  adapter: postgresql
  database: survey_test
```

Now we can move on to setting up our classes! Because classes can inherit in Active Record,
this is pretty easy. Just set up your class like this:
```
class Survey < ActiveRecord::Base
end
```

OK now you're ready to make some actual databases and tables. Yay.

Now you should start the postgres server by running postgres in the terminal.
Also run bundle in your terminal to bundle those gems. Once everything is bundled:
```
$ rake db:create
$ rake db:create_migration NAME=create_nameofyourfirsttable
```

If everything went smoothly, you should have a new directory called db in your home
directory. Inside of db in a directory called migrate, a new migration will appear. The
file will begin with a sequence of numbers. Open this file and add your table structure.
It should look something like this:
```
class CreateSurvey < ActiveRecord::Migration
  def change
    create_table(:surveys) do |t|
      t.column(:name, :string)
      t.timestamps
    end
  end
end
```

###This is very important: make sure you create your table with a plural name. More
on vital naming conventions here:
https://www.learnhowtoprogram.com/lessons/active-record-naming-conventions

OK now lets migrate!

In the terminal:
```
$ rake db:migrate
$ rake db:test:prepare
```

Now in psql go check out your database by connecting to it using \c to make sure
your test and dev databases are there. Also make sure your table structure is
properly configured by running this SQL command:

```
SELECT * FROM surveys;
```
