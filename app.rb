require("bundler/setup")
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  @surveys = Survey.all()
  @questions = Question.all()
  erb(:index)
end

post('/') do
  name = params.fetch("survey_name")
  @survey = Survey.create({:name => name})
  @surveys = Survey.all()
  erb(:index)
end

get('/surveys/:id') do
  @survey = Survey.find(params.fetch("id").to_i())
  @questions = Question.all()
  @surveys = Survey.all()
  erb(:surveys)
end

post('/surveys/:id') do
  id = params.fetch("id").to_i()
  @survey = Survey.find(params.fetch("id").to_i())
  description = params.fetch("description")
  @question = Question.create({:description => description, :survey_id => id})
  @questions = Question.all()
  erb(:surveys)
end

delete('/surveys') do
  id = params.fetch("id").to_i()
  @survey = Survey.find(params.fetch("id").to_i())
  @questions = Question.all()
  Question.find(id).delete()
  erb(:surveys)
end
