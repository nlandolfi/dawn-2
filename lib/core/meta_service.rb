
module Dawn
  class MetaService < ActiveRecord::Base

    has_many :servers
    has_many :services, through: :servers

  end
end

