module SuperTableFilter
  extend ActiveSupport::Concern

  included do ||
    serialize :filters_store, coder: YAML, type: Hash
    serialize :behaviour_store, coder: YAML, type: Hash

    def set_filter(field, by)
      return if field.nil?

      by = false if by == 'false'
      by = true if by == 'true'
      self.filters_store[field.to_s] = by
      self.save!
    rescue
      self.filters_store = {}
      self.save!
    end

    def filter(field)
      filters_store[field.to_s]
    rescue
      self.filters_store = {}
      self.save!
    end

    def set_behaviour(field, by)
      return if field.nil?

      by = false if by == 'false'
      by = true if by == 'true'
      self.behaviour_store[field.to_s] = by
      self.save!
    rescue
      self.behaviour_store = {}
      self.save!
    end

    def behaviour(field)
      behaviour_store[field.to_s]
    rescue
      self.behaviour_store = {}
      self.save!
    end

    def handle_radio(field, by, related)
      return if field.blank?

      if by == 'true'
        related.each do |filter|
          set_filter(filter, false)
        end
      end

      set_filter(field, by)
    end

    def filter_instance(filter_name, klass)
      return if filter(filter_name).nil?
      return klass.find_by(id: filter(filter_name).to_i) if klass.find_by(id: filter(filter_name).to_i)
    end

    def set_filters_on_behaviours(field, by)
      return if field.nil?
      by = false if by == 'false'
      by = true if by == 'true'
      self.behaviour_store['filters'] = {} unless self.behaviour_store['filters']
      self.behaviour_store['filters'][field.to_s] = by
      self.save!
    rescue
      self.behaviour_store['filters'] = {}
      self.save!
    end

    def behaviour_filters
      behaviour_store['filters']
    end

    def behaviour_filter(field)
      behaviour_store['filters'][field.to_s] if behaviour_store['filters']
    end
  end
end