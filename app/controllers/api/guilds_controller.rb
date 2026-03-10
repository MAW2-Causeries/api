module Api
  class GuildsController < ApplicationController
    protect_from_forgery with: :null_session

    rescue_from ActiveRecord::RecordNotFound, with: :guild_not_found
    rescue_from ActiveRecord::NoMethodError, with: :record_invalid
    rescue_from ActiveRecord::InvalidForeignKey, with: :user_not_found

    def show
        render json: set_guild.as_json, status: :ok
    end

    def create
      attrs = guild_params.to_h
      guild = Guild.new(attrs)
      unless guild.name.match?(/^[A-Za-z0-9]+$/)
        render json: InvalidGuildData.new, status: :bad_request #another ways to show error
      end 
      begin
        guild.save!
        head :ok
      rescue ActiveRecord::RecordInvalid
        if User.find_by(uuid: guild.owner_id).nil? || User.find_by(uuid: guild.creator_id).nil?
          render json: UserNotFound.new, status: :unprocessable_entity
        else
          render json: DuplicateGuild.new, status: :unprocessable_entity
        end
      end
    end

    def update
      begin
        set_guild.update!({ name: params[:name], description: params[:description], owner_id: params.fetch(:owner_id, guild.owner_id), banner_picture_path: params[:banner_picture_path] })
        head :ok
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        render json: DuplicateGuild.new, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        Guild.find_by!(uuid: params[:id]).destroy
        head :ok
      end
    end

    def guild_params
      params.require(:guild).permit(:name, :description, :owner_id, :banner_picture_path, :creator_id)
      # might be able to refactor/reduce to asked id
    end

    def set_guild
      Guild.find_by!(uuid: params[:id])
    end

    def guild_not_found
      render json: GuildNotFound.new, status: :not_found
    end

    def user_not_found
      render json: UserNotFound.new, status: :unprocessable_entity
    end

    def record_invalid
      render json: InvalidGuildData.new, status: :unprocessable_entity
    end
  end
end
