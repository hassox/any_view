class String
  unless method_defined?(:titleize)
    def titleize
      gsub("_", " ").gsub(/\b('?[a-z])/){$1.upcase}
    end
  end

  unless method_defined?(:underscore)
    def underscore
      gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        gsub("-", "_").
        downcase
    end
  end
end
