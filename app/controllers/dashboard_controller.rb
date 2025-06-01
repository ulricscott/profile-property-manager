require "uri"
require "net/http"
require "openssl"


class DashboardController < ApplicationController
  def index
    request = KlaviyoAPI::Profiles.get_profiles()
    @profiles = request[:data]
    render "index"
  end

  def update
    failed_ids = [] # Array to be used to compare against array of attempted profile ids in order to deliver failure alert
    update_params[:profile_ids].each do |id|
      body = {
        data: {
          type: "profile",
          id: id,
          attributes: {},
          meta: {
            patch_properties: {
              append: { engagement: update_params[:engagement] },
              unappend: { engagement: [ "very high", "high", "medium", "low", "very low", "" ].reject { |e| e == update_params[:engagement] } }
            }
          }

        }
      }

      begin
        KlaviyoAPI::Profiles.update_profile(id, body, {})
      rescue KlaviyoAPI::ApiError => e
        failed_ids.push id # builds array of ids that yield errors
        puts e
      end
    end

    render json: {
      message: "Updated profiles",
      updated_ids: update_params[:profile_ids].reject { |e| failed_ids.include?(e) },
      failed_ids: failed_ids
    }
  end

   private

   def update_params
    params.require(:dashboard).permit(:engagement, profile_ids: [])
   end
end
