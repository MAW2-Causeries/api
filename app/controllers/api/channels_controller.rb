module Api
  class ChannelsController < ApplicationController
    protect_from_forgery with: :null_session

    def show
      begin
        channel = Channel.find_by!(uuid: params[:id])
        render json: channel.as_json, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: ChannelNotFound.new, status: :not_found
      end
    end

    def create
      attrs = channel_params.to_h
      channel = Channel.new(attrs)
      logger.debug "Creating channel with attributes: #{channel.inspect}"
      begin
        channel.save!
        head :ok
      rescue ActiveRecord::InvalidForeignKey
        render json: GuildNotFound.new, status: :unprocessable_entity
      rescue ActiveRecord::RecordInvalid
        render json: DuplicateChannel.new, status: :unprocessable_entity
      end
    end

    def update
      channel = Channel.find_by(uuid: params[:id])
      begin
        channel.update_columns({ name: params[:name], category: params[:category], description: params[:description] })
        head :ok
      rescue NoMethodError
        render json: InvalidChannelData.new, status: :unprocessable_entity
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        render json: DuplicateChannel.new, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        Channel.find_by!(uuid: params[:id]).destroy
        head :ok
      rescue ActiveRecord::RecordNotFound
        render json: ChannelNotFound.new, status: :not_found
      end
    end

    def channel_params
      params.require(:channel).permit(:name, :category, :description, :guild_id)
    end
  end
end
