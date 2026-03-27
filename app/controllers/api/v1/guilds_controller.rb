module Api
  module V1
    class GuildsController < BaseController
      def index
        guilds = current_user.guilds
        render json: guilds.as_json, status: :ok
      end

      def show
        set_guild
        return unless can_access_guild?(@guild)

        render json: @guild.as_json, status: :ok
      end

      def create
        attrs = guild_params.to_h
        guild = Guild.new(attrs)

        guild.owner = current_api_user
        guild.creator = current_api_user
        guild.members << current_api_user

        guild.save!
        render json: guild.as_json, status: :created
      end

      def update
        set_guild
        return unless only_guild_owner

        @guild.update!({ name: params[:name], description: params[:description], owner_id: params.fetch(:owner_id, @guild.owner_id) })
        render json: @guild.as_json, status: :ok
      end

      def destroy
        set_guild
        return unless only_guild_owner

        @guild.destroy
        head :no_content
      end

      def channels
        set_guild
        return unless can_access_guild?(@guild)

        render json: @guild.channels.as_json, status: :ok
      end

      def members
        set_guild
        return unless can_access_guild?(@guild)

        render json: @guild.members.as_json, status: :ok
      end

      private

      def only_guild_owner
        return true if @guild.owner == current_api_user

        render_error("Only the owner of the guild can perform this action", status: :forbidden, code: "forbidden")
        false
      end

      def guild_params
        params.permit(:name, :description)
      end

      def set_guild
        @guild = Guild.find_by!(id: params[:id])
      end

      def can_access_guild?(guild)
        return true if guild.members.include?(current_api_user) || guild.owner == current_api_user

        render_error("You don't have access to this guild", status: :forbidden, code: "forbidden")
        false
      end
    end
  end
end
