require("sinatra")
require("sqlite3")
require("sinatra/activerecord")

set(:database, {adapter: "sqlite3", database: "movies.db"})

class User < ActiveRecord::Base
end

class Film < ActiveRecord::Base
end

class RedditApp < Sinatra::Base
  register(Sinatra::ActiveRecordExtension)

# Load app
  get("/") do
    redirect("/index")
  end

  get("/index") do
    return erb(:index)
  end

# Create movies
  get '/movies/new' do
    erb :new_movie
  end

  post('/movies') do
    puts "These are the movies"
        puts params ## checks the route, like console log
    @film = {filmtitle: params[:filmtitle], filmreleaseyear: params[:filmreleaseyear]}
    puts @film
    Film.create(@film)
    redirect "/mov/all"
  end

# Read movies
  get("/mov/all") do
    @films = Film.all
    return erb(:movie_all)
  end

  get ("/m/:id") do
    @film = Film.find_by({id: params[:id]})
    if @film
      return erb(:show_film)
    else
      return "No film found by that name."
    end
  end

# Update movies
  get("/m/update/:id") do
    @film = Film.find_by({id: params[:id]})
    erb(:update_film)
  end

  put("/m/update/:id") do
    "Lets update #{params[:id]}"
    @film = Film.find_by({id: params[:id]})
    @film.update(filmtitle: params[:film_title])
    redirect "/mov/all"

  end

# Destroy movies
post"/m/:id/delete" do
  @film = Film.find(params[:id])
  @film.destroy
  redirect("/mov/all")
end

# Create users
    get("/u/new") do
      erb(:new_user)
    end

    post("/u/new") do
      @user = {name: params[:name], age: params[:age]}
      User.create(@user)
      redirect "/u/all"
    end

# Read users
  get("/u/all") do
    # "The user is #{User.last.name} and his age is #{User.last.age}"
    @users = User.all
    return erb(:user_all)
  end

  get("/u/:id") do
    @user = User.find_by({id: params[:id]})
    # @user = User.where({name: params[:name]}).take
    if @user
      return erb(:show_user)
    else
      return "No user found by that name"
    end
  end

# Update users
   get("/u/update/:id") do
     @user = User.find_by({id: params[:id]})
     erb(:update_user)
   end

  put("/u/update/:id") do
    @user = User.find(params[:id])
    puts "This is the updated user"
    @user.update(name: params[:name])
    puts params
    redirect("/u/all")
  end

# Destroy user
  post("/u/:id/delete") do
    @user = User.find(params[:id])
    @user.destroy
    redirect("/u/all")
  end

end
