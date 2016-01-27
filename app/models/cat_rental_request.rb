class CatRentalRequest < ActiveRecord::Base
  POSSIBLE_STATUS = ['PENDING', 'APPROVED', 'DENIED']

  validates :status, inclusion: POSSIBLE_STATUS
  validates :status, :start_date, :end_date, :cat_id, presence: true
  validate :clashing_dates
  validate :correct_dates

  belongs_to :cat,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: 'Cat'


  def approve!
    my_overlaps = overlapping_requests
    CatRentalRequest.transaction do
      self.update(status:"APPROVED")
      my_overlaps.each do |request|
        #request.update(status:"DENIED")
        request.deny! #THIS IS BROKEN?
      end
    end
  end

  def deny!
    self.update(status:"DENIED") if self.status == "PENDING"
  end

  def pending?
    self.status == "PENDING"
  end

  def overlapping_requests
    clash_array = []
    cat.rental_requests.each do |request|
      next if request.id == self.id
      if conflicts?(request)
        clash_array << request
      end
    end
    clash_array
  end

  def overlapping_approved_requests
    overlapping_requests.select { |request| request.status == "APPROVED"}
  end

  def clashing_dates
    if status == "APPROVED" && overlapping_approved_requests.any?
      errors[:base] << "conflicts with approved requests"
    end
  end

  def conflicts?(request)
    if start_date.between?(request.start_date, request.end_date)
      true
    elsif end_date.between?(request.start_date, request.end_date)
      true
    elsif (start_date < request.start_date && end_date > request.end_date)
      true
    else
      false
    end
  end

  def correct_dates
    unless self.start_date <= self.end_date
      errors[:base] << "start date must not be after end date"
    end
  end

  #   overlapping_requests #approved
  #    clashes = false
  #    cat.rental_requests.each do |request|
  #      next if request.id == self.id
  #      if conflicts?(request)
  #        clashes = true
  #        break
  #      end
  #    end
  #    clashes
  #  end
    # def conflicts?(request)
    #   return false unless request.status == 'APPROVED'
    #   if start_date.between?(request.start_date, request.end_date)
    #     true
    #   elsif end_date.between?(request.start_date, request.end_date)
    #     true
    #   elsif (start_date < request.start_date && end_date > request.end_date)
    #     true
    #   else
    #     false
    #   end


end
