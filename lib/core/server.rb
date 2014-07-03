
module Dawn
  class Server < ActiveRecord::Base

    belongs_to :service
    belongs_to :meta_service

  end
end
