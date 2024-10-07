# frozen_string_literal: true

class Person
  attr_accessor :name, :accumulated_score, :scored_three_hundreds

  def initialize(name)
    @name = name
    @scored_three_hundreds = false
    @accumulated_score = 0
  end
end
