module UUIDHelper
  # def set_uuid
  #   self.id = UUIDTools::UUID.random_create.to_s
  #   
  # end
  
  def set_uuid
    uuid = UUIDTools::UUID.random_create
    self.id = uuid.to_s
    if self.class == User
      self.node = uuid.to_i % 1024
    elsif self.user
      self.node = self.user.node
    end
  end
end
