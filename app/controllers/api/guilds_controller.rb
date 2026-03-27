module Api
  class GuildsController < BaseController
    def show
      set_guild
      render json: @guild.as_json, status: :ok
    end

    def create
      attrs = guild_params.to_h
      guild = Guild.new(attrs)

      guild.owner = current_api_user
      guild.creator = current_api_user

      guild.save!
      render json: guild.as_json, status: :created
    end

    def update
      set_guild
      only_guild_owner
      @guild.update!({ name: params[:name], description: params[:description], owner_id: params.fetch(:owner_id, @guild.owner_id) })
      render json: @guild.as_json, status: :ok
    end

    def destroy
      set_guild
      only_guild_owner
      @guild.destroy
      head :no_content
    end

    private

    def only_guild_owner
      return if @guild.owner == current_api_user

      render_error("Only the owner of the guild can perform this action", status: :forbidden, code: "forbidden")
    end

    def guild_params
      params.permit(:name, :description)
    end

    def set_guild
      @guild = Guild.find_by!(id: params[:id])
    end
  end
end
