class UsersController < ApplicationController
  before_action :authenticate, :except => [:show, :new, :create]
  before_action :correct_user, :only => [:edit, :update]
  before_action :admin_user, :only => :destroy
  before_action :signed_in_user, :only => [:new, :create]
  
  def new
    @user = User.new
    @title = 'Sign up'
  end
  
  def create
    params.permit!
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      @title = 'Sign up'
      render :action => 'new'
    end
  end

  def index
    @title = 'All users'
    #@users = User.all
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name    
  end

  def edit
    #@user = User.find(params[:id])
    @title = 'Edit user'
  end

  def update
    @user = User.find(params[:id])
    params.permit!
    if @user.update(params[:user])
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      @title = 'Edit user'
      render 'edit'
    end
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def destroy
    if current_user.id.to_i != params[:id].to_i then
      User.find(params[:id]).destroy
      flash[:success] = 'User destroyed.'
      redirect_to users_path
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def signed_in_user
    redirect_to(root_path) if signed_in?
  end
end

