class Survey < ActiveRecord::Base
  has_many(:question)
end
