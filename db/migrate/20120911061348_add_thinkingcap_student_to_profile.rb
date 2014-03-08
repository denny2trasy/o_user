class AddThinkingcapStudentToProfile < ActiveRecord::Migration
  def self.up
    add_column  :profiles,  :thinkingcap_student, :string
  end

  def self.down
    remove_column :profiles,  :thinkingcap_student
  end
end
