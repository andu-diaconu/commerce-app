class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to root_path unless current_user
    if current_user.role == "Staff"
      @rooms = Room.find_by(name: current_user.brand.name)
    else
      @rooms = Room.all.order(name: :asc)
    end
    @users = User.all_except(current_user)
  end

  def create
    @room = Room.create(name: params["room"]["name"])
  end

  def show
    @single_room = Room.find(params[:id])
    if current_user.nil? || (current_user.staff? && current_user.brand.name != @single_room.name)
      redirect_to root_path, :flash => {alert: "Forbbiden!"}
    else
      if current_user.role == "Staff"
        @rooms = Room.find_by(name: current_user.brand.name)
      else
        @rooms = Room.all
      end
      @users = User.all_except(current_user)
      @room = Room.new
      @message = Message.new
      @messages = @single_room.messages

      render "index"
    end
  end
end