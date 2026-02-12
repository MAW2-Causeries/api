module Api
  class ChannelsController < ApplicationController
      protect_from_forgery with: :null_session


    def show
      begin
        channel = Channel.find_by!(uuid: params[:id])
        render json: channel.as_json, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: ChannelNotFound.new, status: :not_found #todo
      end
    end 

    def create
        attrs = channel_params.to_h
      channel = Channel.new(attrs)
      if channel.save
        head :ok
      else
        render json: { error: "The channel couldn't be create" }, status: :forbidden
      end
    end 
    
    def update
    end 

    def destroy
    end

    def channel_params
      params.require(:channel).permit(:name, :category, :description, :guild_id)
    end
  end
end
