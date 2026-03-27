module Api
  module V1
    class GuildInvitesController < BaseController
      def join
        invite = GuildInvite.find_by!(token: params[:token], active: true)
        guild = invite.guild
        status = guild.members.exists?(id: current_api_user.id) ? :ok : :created

        guild.invite_member!(current_api_user)
        render json: { guild: guild.as_json, invite: invite.as_json }, status: status
      end
    end
  end
end
