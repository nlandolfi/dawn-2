require "data.rb"

module Elos

  class UserProfile < ActiveRecord::Base

    #first_name, last_name, email

  end

  class User < ActiveRecord::Base


    has_many :data, class: Elos::Datum
    has_many :services

    belongs_to :profile, foreign_key: :profile_id, class: Elos::UserProfile

  end
end

