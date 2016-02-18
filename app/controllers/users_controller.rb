class UsersController < ApplicationController
  def index
    redirect_to(:action => 'list')
  end

  def list
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save then
      flash[:notice] = "Usuario fue creado con exito"
      redirect_to(:action => 'list')
    else
      render('new')
    end
  end

  def update

  end

  def delete
    user = User.find(params[:id])
    user.destroy
    flash[:notice] = 'Usuario fue eliminado con exito'
    redirect_to(:action => 'list')

  end


  private

  def user_params
    params.require(:user).permit(:name, :surname)
  end
end
