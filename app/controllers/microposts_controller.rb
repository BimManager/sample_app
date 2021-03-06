class MicropostsController < ApplicationController
  before_action :authenticate, :only => [:create, :destroy]
  before_action :authorized_user, :only => :destroy

  def create
    params.permit!
    @micropost = current_user.microposts.build(params[:micropost])
    @user = current_user
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private

  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end
end
