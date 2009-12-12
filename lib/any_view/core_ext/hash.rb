unless Hash.method_defined?(:reverse_merge!)
  class Hash
    def reverse_merge!(other = {})
      other.each{|k,v| self[k] ||= v}
      self
    end
  end
end
