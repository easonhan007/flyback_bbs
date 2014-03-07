class Attendance < ActiveRecord::Base

  belongs_to :course
  belongs_to :account


  def account_selected?(account)
    return false unless account.is_a?(Account)
    c_ids = accounts.map {|c| c.id}
    c_ids.include?(account.id)
  end

  def self.attendance_status(status)
    case status
    when :a
      "正常"
    when :b
      "迟到"
    when :c
      "早退"
    when :d
      "缺席"
    end
  end

  def self.status_mapping
    Attendance.all.map {|sym| [Attendance.attendance_status(sym), sym]}
  end
end
