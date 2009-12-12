class Hash
  unless method_defined?(:reverse_merge!)
    def reverse_merge!(other = {})
      other.each{|k,v| self[k] ||= v}
      self
    end
  end

  unless method_defined?(:slice!)
    def slice!(*keys)
      keys = keys.flatten
      out = {}
      keys.each{|k| out[k] = self[k]}
      replace out
      self
    end

    def slice(*keys)
      out = dup
      out.slice!(*keys)
    end
  end

  unless method_defined?(:symbolize_keys)
    def symbolize_keys
      out = dup
      out.symbolize_keys!
    end
  end

  unless method_defined?(:symbolize_keys!)
    def symbolize_keys!
      symbolizable_keys = []
      keys.each{|k| symbolizable_keys << k if k.respond_to?(:to_sym) && !k.is_a?(Symbol)}
      symbolizable_keys.each do |k|
        self[k.to_sym] = delete(k)
      end
      self
    end
  end
end
