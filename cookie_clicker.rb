class CookieGenerator
  attr_accessor :name, :description, :rate, :cost, :created_at, :generators
  @@generators ||= []

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.all
     @@generators
  end

  def self.rate
    @rate
  end

  def self.cost
    @cost
  end

  def self.name
    @name
  end

  def self.description
    @description
  end

  def self.total_cps
    @@generators.inject(0) { |sum, i|
      sum + i.rate
    }
  end

  def self.total_cookies_earned
    @@generators.inject(0) { |sum, i|
      sum + i.cookies_generated
    }.round(2)
  end

  def cookies_generated
    return ((Time.now - @created_at).round * @rate).round(2)
  end

end

class CookieClicker < CookieGenerator
  @name = "Cookie Clicker"
  @description = "A clicker that generates 1 cookie every 10 seconds."
  @rate = 0.1
  @cost = 15

  def initialize
    @name = "Cookie Clicker"
    @description = "A clicker that generates 1 cookie every 10 seconds."
    @rate = 0.1
    @cost = 15
    @created_at = Time.now
    @@generators << self
  end
end

class CookieBaker < CookieGenerator
  @name = "Cookie Baker"
  @description = "A dedicated baker producing a cookies every 2 seconds."
  @rate = 0.5
  @cost = 100

  def initialize
    @name = "Cookie Baker"
    @description = "A dedicated baker producing a cookies every 2 seconds."
    @rate = 0.5
    @cost = 100
    @created_at = Time.now
    @@generators << self
  end
end

class CookieFarm < CookieGenerator
  @name = "Cookie Farm"
  @description = "A cookie farm producing 4 cookies a second."
  @rate = 4
  @cost = 500

  def initialize
    @name = "Cookie Farm"
    @description = "A cookie farm producing 4 cookies a second."
    @rate = 4
    @cost = 500
    @created_at = Time.now
    @@generators << self
  end
end

class CookieFactory < CookieGenerator
  @name = "Cookie Factory"
  @description = "A cookie factory producing 10 cookies a second."
  @rate = 10
  @cost = 3000

  def initialize
    @name = "Cookie Factory"
    @description = "A cookie factory producing 10 cookies a second."
    @rate = 10
    @cost = 3000
    @created_at = Time.now
    @@generators << self
  end
end

class CookieMine < CookieGenerator
  @name = "Cookie Mine"
  @description = "A cookie mine producing 40 cookies a second."
  @rate = 40
  @cost = 10000

  def initialize
    @name = "Cookie Mine"
    @description = "A cookie mine producing 40 cookies a second."
    @rate = 40
    @cost = 10000
    @created_at = Time.now
    @@generators << self
  end
end

class CookieShipment < CookieGenerator
  @name = "Cookie Shipment"
  @description = "A cookie shipment from space producing 100 cookies a second."
  @rate = 100
  @cost = 40000

  def initialize
    @name = "Cookie Shipment"
    @description = "A cookie shipment from space producing 100 cookies a second."
    @rate = 100
    @cost = 40000
    @created_at = Time.now
    @@generators << self
  end
end

class CookieLabratory < CookieGenerator
  @name = "Cookie Labratory"
  @description = "A cookie labratory producing 400 cookies a second."
  @rate = 400
  @cost = 200000

  def initialize
    @name = "Cookie Labratory"
    @description = "A cookie labratory producing 400 cookies a second."
    @rate = 400
    @cost = 200000
    @created_at = Time.now
    @@generators << self
  end
end

class CookiePortal < CookieGenerator
  @name = "Cookie Portal"
  @description = "A cookie portal to the underworld producing 6,666 cookies a second."
  @rate = 6666
  @cost = 1666666

  def initialize
    @name = "Cookie Portal"
    @description = "A cookie portal to the underworld producing 6,666 cookies a second."
    @rate = 6666
    @cost = 1666666
    @created_at = Time.now
    @@generators << self
  end
end

class CookieTimeMachine < CookieGenerator
  @name = "Cookie Time Machine"
  @description = "A cookie time machine producing 98,765 cookies a second."
  @rate = 98765
  @cost = 123456789

  def initialize
    @name = "Cookie Time Machine"
    @description = "A cookie time machine producing 98,765 cookies a second."
    @rate = 98765
    @cost = 123456789
    @created_at = Time.now
    @@generators << self
  end
end

class CookieCondenser < CookieGenerator
  @name = "Cookie Condensor"
  @description = "A cookie condensor producing 999,999 cookies a second."
  @rate = 999999
  @cost = 3999999999

  def initialize
    @name = "Cookie Condensor"
    @description = "A cookie condensor producing 999,999 cookies a second."
    @rate = 999999
    @cost = 3999999999
    @created_at = Time.now
    @@generators << self
  end
end

class Player
  attr_accessor :cookies_spent, :cookies_clicked

  def initialize
    @cookies_clicked = 0
    @cookies_spent = 0
  end

  def buyGenerator(generatorType, amount)
    cost_to_buy = ((Object::const_get(generatorType).cost) * amount)
    generator_to_buy = Object::const_get(generatorType).name

    if cookies >= cost_to_buy
      puts "Buying #{amount} #{generator_to_buy}"
      @cookies_spent += cost_to_buy
      amount.times do
        Object::const_get(generatorType).new
      end

    else
      puts "You need #{(cost_to_buy - cookies).round} more cookies to buy #{amount} #{generator_to_buy}"
    end
  end

  def cookies
    return (((CookieGenerator.total_cookies_earned != nil ? CookieGenerator.total_cookies_earned : 0) + @cookies_clicked) - @cookies_spent).round(2)
  end

  def click
    @cookies_clicked += 1
  end
end

