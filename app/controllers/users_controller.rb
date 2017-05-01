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
    @gameYellow = Game.where("date >= ?", Date.today).where(:forteam => "1").order("date ASC").limit(1).take
    @gameGreen = Game.where("date >= ?", Date.today).where(:forteam => "2").order("date ASC").limit(1).take
    @yellowGameAttenders = UserAttendence.where(:game_id => @gameYellow.id, :attendance_type => "Going").pluck(:user_id)
    @greenGameAttenders = UserAttendence.where(:game_id => @gameGreen.id, :attendance_type => "Going").pluck(:user_id)
    
    @yellowGameGirlsCount = 0
    @greenGameGirlsCount = 0
    @yellowGameBoysCount = 0
    @greenGameBoysCount = 0

    if !@yellowGameAttenders.nil?
      @yellowGameGirlsCount = User.where(:id => @yellowGameAttenders).where(gender: "2").count
      @yellowGameBoysCount = User.where(:id => @yellowGameAttenders).where(gender: "1").count
    end
    if !@greenGameAttenders.nil?
      @greenGameGirlsCount = User.where(:id => @greenGameAttenders).where(gender: "2").count
      @greenGameBoysCount = User.where(:id => @greenGameAttenders).where(gender: "1").count
    end

    @gameFull = false
    @gameFullYellow = false
    @gameFullGreen = false


    if @user.gender == "1" && @user.team == "1" && @yellowGameBoysCount == 5
      @gameFull = true
    elsif @user.gender == "2" && @user.team == "1" && @yellowGameGirlsCount == 5
      @gameFull = true
    elsif @user.gender == "1" && @user.team == "2" && @greenGameBoysCount == 5
      @gameFull = true
    elsif @user.gender == "2" && @user.team == "2" && @greenGameGirlsCount == 5
      @gameFull = true
    end

    if @user.gender == "1" && @user.team == "3" && @yellowGameBoysCount == 5
      @gameFullYellow = true
    elsif @user.gender == "2" && @user.team == "3" && @yellowGameGirlsCount == 5
      @gameFullYellow = true
    end

    if @user.gender == "1" && @user.team == "3" && @greenGameBoysCount == 5
      @gameFullGreen = true
    elsif @user.gender == "2" && @user.team == "3" && @greenGameGirlsCount == 5
      @gameFullGreen = true
    end

    @microposts = Micropost.all
    @game = nil
    @alternatesDate = nil
    @alternatesWindow = false

    if @user.team == "3"

      
      if !@gameYellow.nil?
         @alternatesDate = @gameYellow.date - 3.days

        if Date.today >= @gameYellow.date - 3.days
          @alternatesWindow = true
        end
      end

      if @gameYellow.nil?
        @alternateAttendenceYellow = nil
      else
        @alternateAttendenceYellow = UserAttendence.where(:user_id => @user.id,:game_id => @gameYellow.id).take
      end

      if @gameGreen.nil?
        @alternateAttendenceGreen= nil
      else
        @alternateAttendenceGreen = UserAttendence.where(:user_id => @user.id,:game_id => @gameGreen.id).take
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
    @gameFull = false

    @attendence = UserAttendence.where(:user_id => @user.id,:game_id => @game.id).take

    if !@gameFull

      if @attendence.nil?
        attrec = UserAttendence.new(user_id: @user.id, game_id: @game.id,attendance_type: params[:attendance_type])
        attrec.save
      else
        @attendence.attendance_type = params[:attendance_type]
        @attendence.save
      end

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
                                   :gender, :phone_number, :haspaid, :team, :shortsize, :player_type,
                                   :buying_shirt,:buying_hat,:buying_shorts,:shirt_fee_paid,:hat_fee_paid,
                                   :shorts_fee_paid)
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
