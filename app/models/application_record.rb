require 'w3c_validators'
require 'csv'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
