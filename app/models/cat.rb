class Cat < ActiveRecord::Base
  SEXES = ['M', 'F']
  COLORS = ['black', 'white', 'striped', 'gray', 'tan', 'orange']

  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :sex, inclusion: SEXES
  validates :color, inclusion: COLORS

  has_many :rental_requests,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: 'CatRentalRequest',
    dependent: :destroy

    
  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end



end
