require 'active_model'

module ApiableModelErrors

  def self.included(base)
    base.alias_method_chain :add, :api_errors
  end

  def to_api_hash
    errors_for_api.each_with_object({}) do |(attribute, errors), hash|
      hash[attribute] = []
      errors.each_with_index do |(message, options), index|
        if message.is_a?(String)
          error = {:message => message}
        else
          error = {
            :code => message,
            :message => messages[attribute][index],
            :options => options
          }
        end
        hash[attribute] << error
      end
    end
  end

  def errors_for_api
    @errors_for_api ||= {}
  end

  def add_with_api_errors(attribute, message = :invalid, options = {})
    add_without_api_errors(attribute, message, options).tap do
      errors_for_api[attribute] ||= []
      errors_for_api[attribute] << [message, options || {}]
    end
  end

  def has_message?(attribute, message, options = nil)
    if errors = errors_for_api[attribute]
      if error = errors.select { |e| e[0] == message }.first
        if options.nil?
          true # No options specified, if it exists, it's here
        elsif options == error[1]
          true # The options match those on the subejct
        else
          false # The options selected don't match those on the error
        end
      else
        false # No errors of this type
      end
    else
      false # No errors for this attribute
    end
  end

end

ActiveModel::Errors.send :include, ApiableModelErrors
