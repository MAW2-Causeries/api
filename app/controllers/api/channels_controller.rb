module Api
  class ChannelsController < BaseController
    def show
      set_channel
      render json: @channel.as_json, status: :ok
    end

    def create
      attrs = channel_params.to_h
      channel = Channel.new(attrs)

      channel.save!
      render json: channel.as_json, status: :ok
    end

    def update
      set_channel

      @channel.update!(update_channel_params)
      render json: @channel.as_json, status: :ok
    end

    def destroy
      Channel.find_by!(id: params[:id]).destroy

      head :no_content
    end

    private

    def update_channel_params
      params.permit(:name, :description).to_h.compact
    end

    def channel_params
      params.permit(:name, :description)
    end

    def set_channel
      @channel = Channel.find_by!(id: params[:id])
    end
  end
end
