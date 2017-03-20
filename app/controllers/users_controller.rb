class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
                                    
  before_action :correct_user,   only: [:show, :edit, :update], unless: -> {current_user.admin?}
  #before_action :admin_user,     only: [:edit, :update, :destroy]
 before_action :admin_user,     only: [:destroy]
 
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    #@microposts = @user.microposts.paginate(page: params[:page])
    @microposts = Micropost.all
    @game = nil
    @alternatesDate = nil

    if @user.team == "3"
      @gameAlternateYellow = Game.where("date >= ?", Date.today).where(:forteam => "1").order("date ASC").limit(1).take
      @gameAlternateGreen = Game.where("date >= ?", Date.today).where(:forteam => "2").order("date ASC").limit(1).take
      @alternatesWindow = false
      if !@gameAlternateYellow.nil?
         @alternatesDate = @gameAlternateYellow.date - 3.days

        if Date.today >= @gameAlternateYellow.date - 3.days
          @alternatesWindow = true
        end
      end

      if @gameAlternateYellow.nil?
        @alternateAttendenceYellow = nil
      else
        @alternateAttendenceYellow = UserAttendence.where(:user_id => @user.id,:game_id => @gameAlternateYellow.id).take
      end

      if @gameAlternateGreen.nil?
        @alternateAttendenceGreen= nil
      else
        @alternateAttendenceGreen = UserAttendence.where(:user_id => @user.id,:game_id => @gameAlternateGreen.id).take
      end

    else

      @game = Game.where("date >= ?", Date.today).where(:forteam => @user.team).order("date ASC").limit(1).take
      if @game.nil?
        @attendence = nil

      else
        @attendence = UserAttendence.where(:user_id => @user.id,:game_id => @game.id).take
      end
    end

  end
  def beer
    @user = User.find(params[:user])

    @beerRecord = Beer.where(:user_id => @user.id).take
    if @beerRecord.nil?
      beerRec = Beer.new(user_id: @user.id, count: 1)
      beerRec.save
    else
      @beerRecord.count = @beerRecord.count + 1
      @beerRecord.save
    end

    redirect_to :back
  end

  def attend
    @user = User.find(params[:user])
    @game = Game.find(params[:game_id])

    @attendence = UserAttendence.where(:user_id => @user.id,:game_id => @game.id).take
    if @attendence.nil?
      attrec = UserAttendence.new(user_id: @user.id, game_id: @game.id,attendance_type: params[:attendance_type])
      attrec.save
    else
      @attendence.attendance_type = params[:attendance_type]
      @attendence.save
    end
    
    redirect_to :back
  end

  def new
    @user = User.new
    @shortsizes = ["Small","Medium","Large"]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @shortsizes = ["Small","Medium","Large"]
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :positions, :desired_teammates, :shirt_size,
                                   :gender, :phone_number, :haspaid, :team, :shortsize)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) #|| current_user.admin?
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
