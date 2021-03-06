# Essentially a fake ActiveRecord::Base
module MockModel
  extend ActiveSupport::Concern

  included do
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    define_model_callbacks :save, :update, :create, :destroy

    include ActiveModel::Dirty
    include ActiveModel::Validations
  end

  module ClassMethods
    def find(ids)
      ids.map { |id| new(id: id) }
    end

    def where(query)
      find query[:id]
    end

    def primary_key
      'id'
    end

    def base_class
      self
    end

    def create(attributes = {})
      record = new(attributes)
      record.save
      record
    end

    def define_attributes(attributes)
      define_attribute_methods attributes

      attributes.each do |attribute|
        define_method attribute do
          instance_variable_get("@#{attribute}")
        end

        define_method "#{attribute}=" do |value|
          send("#{attribute}_will_change!")
          instance_variable_set("@#{attribute}", value)
        end
      end

      define_method 'attributes' do
        Hash[attributes.map { |attr| [attr.to_s, send(attr)] }]
      end
    end
  end

  def initialize(attrs = {})
    self.attributes = attrs
  end

  def attributes=(attrs)
    attrs.each do |key, val|
      send("#{key}=", val)
    end
  end

  def id=(value)
    @id = value
  end

  def id
    @id ||= rand(10000).to_s
  end

  def save
    @persisted = true
    callback_method = new_record? ? :create : :update
    run_callbacks callback_method
  end

  def destroy
    @destroyed = true
    run_callbacks :destroy
  end

  def ==(other)
    id == other.id
  end

  def changed?
    true
  end

  def new_record?
    !@persisted
  end

  def persisted?
    @persisted
  end

  def destroyed?
    @destroyed
  end

  def reload
  end
end
