class GamesController < ApplicationController
  def new
  	@game = Game.new
  	#@gametypes = ['Home','Away']
  	@gametypes = Homeaway.all
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      
      flash[:info] = "New Game Added"
      render 'new'
    else
      flash[:info] = "Error Game Not Added"
      render 'new'
    end
  end

  def show
  	@game= Game.find(params[:id])
  end

  def index
  	@games = Game.all
    @currentgame = Game.where("date >= ?", Date.today).where(:forteam => current_user.team).order("date ASC").limit(1).take

  	#@users = Game.all.paginate(page: params[:page])
  end

  def destroy
  	Game.find(params[:id]).destroy
    flash[:success] = "Game deleted"
    redirect_to games_url
  end


   private

    def game_params
      params.require(:game).permit(:date, :time, :homeaway, :comments, :forteam)
    end

end
