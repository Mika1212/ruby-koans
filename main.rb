# frozen_string_literal: true

class Main
  s = "Когда-то давным давно, когда я только пришел на Степик..."
  c = 0
  i = 0
  s.each_char do |x|
    i = i + 1
    if x == "а"
      puts i
      c += 1
    end
  end
  puts c
end
