module Api
  class InvalidChannelType < StandardError; end

  class ChannelsController < BaseController
    rescue_from InvalidChannelType, with: :render_invalid_channel_type

    def index
      current_user.channels.includes(:users).map(&:as_json).tap do |channels|
        render json: channels, status: :ok
      end
    end

    def show
      set_channel
      authorize_channel_access!

      render json: @channel.as_json, status: :ok
    end

    def create
      attrs = channel_params
      type = attrs.delete(:type)
      user_id = attrs.delete(:user_id)
      user_ids = attrs.delete(:user_ids)

      channel = case type
      when "dm", "DMChannel"
        attrs.delete(:guild_id) # DM channels should not have a guild_id
        DMChannel.new(attrs).tap do |c|
          c.users << current_user
          c.users << User.find_by!(id: user_id)
        end
      when "group", "GroupChannel"
        attrs.delete(:guild_id) # DM channels should not have a guild_id
        GroupChannel.new(attrs).tap do |c|
          c.users << current_user
          c.users.concat(User.where(id: user_ids))
        end
      when "text", "TextChannel"
        TextChannel.new(attrs)
      else
        raise InvalidChannelType, "Invalid channel type: #{type}"
      end

      channel.save!
      render json: channel.as_json, status: :created
    rescue ActiveRecord::RecordInvalid => e
      if e.record.errors[:users].any?
        channel = DMChannel.between_users(current_user, User.find_by(id: user_id))
        render json: channel.as_json, status: :ok
      else
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def update
      set_channel

      @channel.update!(update_channel_params)
      render json: @channel.as_json, status: :ok
    end

    def destroy
      set_channel
      can_destroy = @channel.instance_of?(TextChannel) && @channel.guild.owner == current_user
      raise ActiveRecord::RecordNotFound unless can_destroy

      @channel.destroy

      head :no_content
    end

    def users
      set_channel
      authorize_channel_access!

      render json: @channel.users.as_json, status: :ok
    end

    private

    def update_channel_params
      params.permit(:name, :description).to_h.compact
    end

    def channel_params
      params.permit(:name, :description, :type, :user_id, :guild_id, user_ids: []).to_h.compact
    end

    def set_channel
      @channel = Channel.find_by!(id: params[:id])
    end

    def render_invalid_channel_type(error)
      render_error(error.message, status: :bad_request, code: "invalid_channel_type")
    end

    def authorize_channel_access!
      unless @channel.users.include?(current_user) || @channel.guild&.members&.exists?(id: current_user.id)
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
