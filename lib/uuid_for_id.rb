module UUIDForID
  
  def self.included(base)
    base.after_initialize :set_uuid
  end

  def set_uuid
    self.id = UUIDTools::UUID.random_create.to_s
  end
end
