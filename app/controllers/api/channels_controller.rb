module Api
  class ChannelsController < ApplicationController
    protect_from_forgery with: :null_session

    rescue_from ActiveRecord::RecordNotFound, with: :channel_not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :guild_not_found
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, with: :duplicate_record
    rescue_from NoMethodError, with: :record_invalid

    def show
        channel = Channel.find_by!(uuid: params[:id])
        render json: channel.as_json, status: :ok
    end

    def create
      attrs = channel_params.to_h
      channel = Channel.new(attrs)
      channel.name = channel.name.match?(/^([a-z0-9]+-?)*$/) ? channel.name : channel.reformatted_name
      logger.debug "Creating channel with attributes: #{channel.inspect}"
      channel.save!
      head :ok
    end

    def update
      channel = Channel.find_by(uuid: params[:id])
      channel.update_columns({ name: params[:name], category: params[:category], description: params[:description] })
      head :ok
    end

    def destroy
        Channel.find_by!(uuid: params[:id]).destroy
        head :ok
    end

    def channel_params
      params.require(:channel).permit(:name, :category, :description, :guild_id)
    end

    def duplicate_record
      render json: DuplicateChannel.new, status: :unprocessable_entity
    end

    def guild_not_found
      render json: GuildNotFound.new, status: :not_found
    end

    def record_invalid
      render json: InvalidChannelData.new, status: :unprocessable_entity
    end

    def channel_not_found
      render json: ChannelNotFound.new, status: :not_found
    end
  end
end
