class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.role == "Staff" && Room.find(params[:room_id]).name != current_user.brand.name
      redirect_to root_path, :flash => {alert: "Forbbiden!"}
    else
      @message = current_user.messages.create(content: msg_params[:content], room_id: params[:room_id])
    end
  end

  private

  def msg_params
    params.require(:message).permit(:content)
  end
end
