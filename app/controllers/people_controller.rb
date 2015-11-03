get '/people' do
  @people = Person.all
  erb :"/people/index"
end

get '/people/new' do
  @person = Person.new
  erb :"/people/new"
end

post '/people' do
  if params[:birthdate].include?("-")
    birthdate = params[:birthdate]
  elsif params[:birthdate].length > 0
    birthdate = Date.strptime(params[:birthdate], "%m%d%Y")
  else
    birthdate = ""
  end

  @person = Person.new(first_name: params[:first_name], last_name: params[:last_name], birthdate: birthdate)
  if @person.valid?
    @person.save
    redirect "/people/#{@person.id}"
  else
    @person.errors.full_messages.each do |message|
      @errors = "#{@errors} #{message}."
    end
    erb :"/people/new"
  end
end

get '/people/:id/edit' do
  @person = Person.find(params[:id])
  erb :'/people/edit'
end

get '/people/:id' do
  @person = Person.find(params[:id])
  birthdate_string = @person.birthdate.strftime("%m%d%Y")
  birth_path_num = Person.get_birth_path_num(birthdate_string)
  @message = Person.get_message(birth_path_num)
  erb :"/people/show"
end

put '/people/:id' do
  @person = Person.find(params[:id])
  @person.first_name = params[:first_name]
  @person.last_name = params[:last_name]
  @person.birthdate = params[:birthdate]
  if @person.valid?
    @person.save
    redirect "/people/#{@person.id}"
  else
    @person.errors.full_message.each do |message|
      @error = "#{@errors} #{message}."
  end
    erb :"/people/edit"
  end
end

delete '/people/:id' do
  person = Person.find(params[:id])
  person.delete
  redirect "/people"
end



