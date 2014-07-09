
module Elos
  class MetaDatum < ActiveRecord::Base
    self.table_name = "metadata"

    # key, value
    belongs_to :datum

  end

  class Datum < ActiveRecord::Base
    self.table_name = "data"

    # time_start, time_end, action, subject
    has_many :metadata, class: Elos::MetaDatum
    belongs_to :location
    belongs_to :service
  end

  class Location < ActiveRecord::Base

    # latitude, longitude, name

  end
end

