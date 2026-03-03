module Api
  class GuildsController < ApplicationController
    protect_from_forgery with: :null_session

    def show
      begin
        guild = Guild.find_by!(uuid: params[:id])
        render json: guild.as_json, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: GuildNotFound.new, status: :not_found
      end
    end

    def create
      attrs = guild_params.to_h
      guild = Guild.new(attrs)
      begin
        guild.save!
        head :ok
      rescue ActiveRecord::InvalidForeignKey
        render json: UserNotFound.new, status: :unprocessable_entity
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
        guild = Guild.find_by!(uuid: params[:id])
        guild.update_columns({ name: params[:name], description: params[:description], owner_id: params.fetch(:owner_id, guild.owner_id) , banner_picture_path: params[:banner_picture_path] })
        head :ok
      rescue NoMethodError
        render json: InvalidGuildData.new, status: :unprocessable_entity
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        render json: DuplicateGuild.new, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound
        render json: GuildNotFound.new, status: :not_found
      end
    end

    def destroy
      begin
        Guild.find_by!(uuid: params[:id]).destroy
        head :ok
      rescue ActiveRecord::RecordNotFound
        render json: GuildNotFound.new, status: :not_found
      end
    end

    def guild_params
      params.require(:guild).permit(:name, :description, :owner_id, :banner_picture_path, :creator_id)
      # might be able to refactor/reduce to asked id
    end
  end
end
