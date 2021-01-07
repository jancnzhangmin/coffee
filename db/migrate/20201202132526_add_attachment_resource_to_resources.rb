class AddAttachmentResourceToResources < ActiveRecord::Migration[6.0]
  def self.up
    change_table :resources do |t|
      t.attachment :resource
    end
  end

  def self.down
    remove_attachment :resources, :resource
  end
end
