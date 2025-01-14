# frozen_string_literal: true

# BasicObject monkey patch
class BasicObject
  # Returns the method names (as symbol) defined inside the object class
  def internal_methods
    return methods if instance_of? BasicObject

    methods.select { |method_name| method(method_name).owner == self.class }
  end

  # Returns the method names (as symbol) defined
  # outside the object class.
  # Warning: it does not return overridden methods.
  def external_methods
    (inherited_methods + extended_methods + included_methods).uniq
  end

  # Returns overridden methods.
  def overridden_methods
    internal_methods & external_methods
  end

  # Returns inherited methods.
  def inherited_methods
    self.class.superclass.instance_methods
  end

  # Returns extended methods.
  def extended_methods
    self.class.singleton_class.included_modules.reduce [] do |acc, wodule|
      acc + wodule.instance_methods
    end
  end

  # Returns included methods.
  def included_methods
    self.class.included_modules.reduce [] do |acc, wodule|
      acc + wodule.instance_methods
    end
  end
end
