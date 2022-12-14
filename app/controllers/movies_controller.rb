class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] == nil and params[:sortings] == nil
      params[:ratings] = session[:ratings]
      params[:sortings] = session[:sortings]
    end
    session.clear
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @ratings_to_show = params[:ratings]
    else
      @new = {}
      for rating in @all_ratings
        @new[rating] = 1
      end
      @ratings_to_show = @new
    end
    @movies = Movie.with_ratings(@ratings_to_show.keys)
    if params[:sortings]
      @movies = @movies.order(params[:sortings]) # is this how it's done?
    end
    session[:ratings] = params[:ratings]
    session[:sortings] = params[:sortings]
    @hilite = {}
    if params[:sortings] == "title"
      @hilite['title'] = "hilite bg-warning"
    elsif params[:sortings] == "release_date"
      @hilite['release_date'] = "hilite bg-warning"
    end
    

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
