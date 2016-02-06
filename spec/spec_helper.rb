$:.unshift(File.expand_path(File.join('..', '..', 'lib'), __FILE__))
require 'apiable_model_errors'

class ExampleClass
  include ActiveModel::Validations
  attr_reader :example
  def initialize(example = nil)
    @example = example
  end
end
