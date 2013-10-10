So, a [post by deebeer](http://www.reddit.com/r/csharp/comments/1nzbrq/as_being_a_big_cookie_clicker_fan_i_decided_to/)
 was sharing that he had re-written cookie clicker in csharp as a way of learning.  I'm not learning so much as I just thought it would be a fun exercise to try and recreate the game in my current language of choice as well as possibly alluding to some things that could improve his C# version.  I figured as I was doing it, I could also type up a guide for those who might want to learn some ruby or something. :)

For those that are unfamiliar with cookie clicker, it's a game with a giant cookie image on one side of the screen.  You can click the cookie to get a cookie.  At the start of the game, every click of the cookie nets you just a single cookie.  As you progress in the game you can buy research that gives you more cookies per click.  After amassing a small amount of cookies, you can buy things that will generate cookies for you.  The first object is a cookie clicker that 'clicks' the cookie once every 10 seconds.  There are a number of these style of cookie generators and each produces cookies at a different rate.  They also each have different research associated with them for increasing their effectiveness.  At random, golden cookies that give you a temporary boost may also appear on screen to be clicked.

The majority of the game has to deal with the cookie generators, you typically only end up clicking cookies enough to get started and very soon after the generators are making cookies faster than you can click and clicking only provides a marginal boost to your overall cookies per second.  Since I'm coding this in ruby, I'm going to skip the clickable bits at the moment.  We can model the majority of the game without needing to click a single thing.

So, I think a good place to start would be to define an object that generates cookies.  I'll create a cookie_clicker.rb file and define a class and give it a few attributes.

```
class CookieGenerator
  attr_accessor :name, :description, :rate, :cost
end
```

This is a good first stab at what the base CookieGenerator might look like.  There's a number of such objects in cookie clicker.  The first as I said above the game is the namesake of the game, the cookie clicker.  It can be defined as follows.  For the sake of making things easier on myself, I kept this inside the cookie_clicker.rb file for now.

```
class CookieClicker < CookieGenerator
  def initialize
    @name = "Cookie Clicker"
    @description = "A clicker that generates 1 cookie every 10 seconds."
    @rate = 0.1
    @cost = 15
  end
end
```

At this point, I can start up irb and require './cookie_clicker.rb' and play around with our new class.

```
[cookie_clicker] irb

1.9.3-p385 :001 > require './cookie_clicker.rb'
 => true
1.9.3-p385 :002 > CookieGenerator
 => CookieGenerator
1.9.3-p385 :003 > CookieClicker
 => CookieClicker
1.9.3-p385 :004 > CookieClicker.new
 => #<CookieClicker:0x007f925d896fb0 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15>
1.9.3-p385 :005 > c = _
 => #<CookieClicker:0x007f925d896fb0 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15>
1.9.3-p385 :006 > c.name
 => "Cookie Clicker"
1.9.3-p385 :007 > c.rate
 => 0.1
1.9.3-p385 :008 > c.cost
 => 15
```

Not all that exciting just yet, but, we've actually done something pretty neat with having a base class and a class inheriting from it.  All of our types of CookieGenerators will have similar attributes and we can probably share a number of functions among them too.  Right now, our cookie generator doesn't actually generate cookies though.  Let's fix that up.

In our CookieGenerator class, we're going to add a new attribute :created_at and we're going to make a function to return how many cookies the generator has made.  The rounding may make things ever so slightly inaccurate, but floating point numbers suck.

```
class CookieGenerator
  attr_accessor :name, :description, :rate, :cost, :created_at

  def cookies_generated
    return ((Time.now - @created_at).round * @rate).round(2)
  end
end
```

In our CookieClicker class, we're going to initialize the attribute :created_at with Time.now

```
class CookieClicker < CookieGenerator
  def initialize
    @name = "Cookie Clicker"
    @description = "A clicker that generates 1 cookie every 10 seconds."
    @rate = 0.1
    @cost = 15
    @created_at = Time.now
  end
end
```

With this done, we can play with irb quickly again and get a little bit more exciting of a result.

```
1.9.3-p385 :001 > require './cookie_clicker.rb'
 => true
1.9.3-p385 :002 > c = CookieClicker.new
 => #<CookieClicker:0x007ff56a095f58 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-09 18:21:13 -0500>
1.9.3-p385 :003 > Time.now
 => 2013-10-09 18:21:16 -0500
1.9.3-p385 :004 > Time.now
 => 2013-10-09 18:21:31 -0500
1.9.3-p385 :005 > c.cookies_generated
 => 2.4
1.9.3-p385 :006 > Time.now
 => 2013-10-09 18:21:40 -0500
1.9.3-p385 :007 > c.cookies_generated
 => 2.9
```

Sweet, we can make a CookieClicker and it's generating cookies!  In the game, you typically end up with a ton of these objects... let's hop back in irb and see what we can do there.

```
1.9.3-p385 :001 > require './cookie_clicker.rb'
 => true
1.9.3-p385 :002 > CookieGenerators = []
 => []
1.9.3-p385 :003 > 6.times do
1.9.3-p385 :004 >     CookieGenerators << CookieClicker.new
1.9.3-p385 :005?>   end
 => 6
1.9.3-p385 :006 > CookieGenerators
 => [#<CookieClicker:0x007fff4c8b24c0 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-09 21:25:33 -0500>, ... SNIP! ...]
1.9.3-p385 :007 > CookieGenerators.inject(0) { |sum, i|
1.9.3-p385 :008 >     sum + i.cookies_generated
1.9.3-p385 :009?>   }
 => 129.6
```

We can create a collection of CookieGenertor objects and then sum all their cookies generated.  Let's see if this works as good as I hope by making another type of CookieGenerator.

```
class CookieBaker < CookieGenerator
  def initialize
    @name = "Cookie Baker"
    @description = "A dedicated baker producing a dozen cookies a second."
    @rate = 12
    @cost = 500
    @created_at = Time.now
  end
end
```

```
1.9.3-p385 :001 > require './cookie_clicker.rb'
 => true
1.9.3-p385 :002 > cookiegenerators = []
 => []
1.9.3-p385 :003 > 6.times do
1.9.3-p385 :004 >     cookiegenerators << CookieClicker.new
1.9.3-p385 :005?>   cookiegenerators << CookieBaker.new
1.9.3-p385 :006?>   end
 => 6
1.9.3-p385 :007 > cookiegenerators
 => [#<CookieClicker:0x007fe25b0c1af8 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-09 21:50:13 -0500>, ... SNIP! ... #<CookieBaker:0x007fe25b0c0bf8 @name="Cookie Baker", @description="A dedicated baker producing a dozen cookies a second.", @rate=12, @cost=500, @created_at=2013-10-09 21:50:13 -0500>]
1.9.3-p385 :008 > cookiegenerators.inject(0) { |sum, i|
1.9.3-p385 :009 >     sum + i.cookies_generated
1.9.3-p385 :010?>   }
 => 2976.6
1.9.3-p385 :011 > quit
```

That works!  So, we can get our cookies per second and the number of cookies generated by all our objects simply by adding them to an array and using a similar 'inject' for each.  Let's define some extra methods and attributes in our CookieGenerator class to make some of this easier.  We'll add a 'generators' attribute to the accessor and make it a class variable, all our generators will have access to this and it'll be the same across all of our generators.

```
class CookieGenerator
  attr_accessor :name, :description, :rate, :cost, :created_at, :generators
  @@generators = []

  def all
     @@generators
  end

  def total_cps
    @@generators.inject(0) { |sum, i|
      sum + i.rate
    }
  end

  def total_cookies_earned
    @@generators.inject(0) { |sum, i|
      sum + i.cookies_generated
    }
  end

  def cookies_generated
    return ((Time.now - @created_at).round * @rate).round(2)
  end

end
```

After that, it's back to irb again.  It's really taking shape now.

```
1.9.3-p385 :001 > require './cookie_clicker.rb'
 => true
1.9.3-p385 :002 > CookieClicker.new
 => #<CookieClicker:0x007f86d8915bc0 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-09 22:39:46 -0500>
1.9.3-p385 :003 > CookieBaker.new
 => #<CookieBaker:0x007f86d891a418 @name="Cookie Baker", @description="A dedicated baker producing a dozen cookies a second.", @rate=12, @cost=500, @created_at=2013-10-09 22:39:49 -0500>
1.9.3-p385 :004 > c = _
 => #<CookieBaker:0x007f86d891a418 @name="Cookie Baker", @description="A dedicated baker producing a dozen cookies a second.", @rate=12, @cost=500, @created_at=2013-10-09 22:39:49 -0500>
1.9.3-p385 :005 > c.all
 => [#<CookieClicker:0x007f86d8915bc0 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-09 22:39:46 -0500>, #<CookieBaker:0x007f86d891a418 @name="Cookie Baker", @description="A dedicated baker producing a dozen cookies a second.", @rate=12, @cost=500, @created_at=2013-10-09 22:39:49 -0500>]
1.9.3-p385 :006 > c.total_cps
 => 12.1
1.9.3-p385 :007 > c.total_cookies_earned
 => 157.6
1.9.3-p385 :008 > c.total_cookies_earned
 => 181.8
1.9.3-p385 :009 > quit
```

So, a mild jump ahead while I quickly implement the rest of the cookie generator types.  I'll post all the cookie generator types below, including the two we've already done.

```
class CookieClicker < CookieGenerator
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
  def initialize
    @name = "Cookie Factory"
    @description = "A cookie time machine producing 98,765 cookies a second."
    @rate = 98765
    @cost = 123456789
    @created_at = Time.now
    @@generators << self
  end
end

class CookieCondenser < CookieGenerator
  def initialize
    @name = "Cookie Condensor"
    @description = "A cookie condensor producing 999,999 cookies a second."
    @rate = 999999
    @cost = 3999999999
    @created_at = Time.now
    @@generators << self
  end
end
```

For those paying attention, they might realise that this is an awful lot of repeated code.  What if there was a way of generating all of these with much less code?  Well, there is a few ways we can reduce the amount of code for all these.  At current in fact, there's no 'special' code unique to any of the objects.  They could all be just a generic CookieGenerator with the appropriate attributes set on that particular object.

Also, in ruby, you can easily use code to generate code.  So we could do something like....

```
%w[CookieClicker CookieBaker CookieFarm CookieFactory CookieMine CookieShipment CookieLabratory CookiePortal CookieTimeMachine CookieCondenser].each { |klass|

Object::const_set(klass, Class.new(CookieGenerator) {
  def initialize
    @@generators ||= []
    @name = self.class.to_s
    @description = "A #{@name} that produces cookies."
    @created_at = Time.now
    @@generators << self
  end
  })
}
```

This is pretty dang neat in my opinion.  I don't want to dwell on this too much, as I'd rather continue with the project than theorycode forever, but, there's countless ways to accomplish the same thing.  As I said before the snippet, we could even get away with simply leaving all the CookieGenerator objects as a CookieGenerator and part of me even argues that at current that's the better course and I'm breaking a programming idiom of 'you aren't gonna need it'.  I just think that having them as different class types may allow me to do some things i want to do later more easily.  I could be wrong and maybe someone that comes along and sees this can clue me in. :)

So, next, probably spending cookies.  Someone with more foresight than I may have noticed something, I can't get the 'rate' or cost of any of our cookie generators without creating an instance of the object.  A quick bout of changes to make each of our class definitions look like the below should fix that up.

```
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
```

I do wish I knew a better way of doing that, I suppose i could have done @name = self.name etc and it would have saved a little bit.  I can't seem to figure out at the moment how to have an attribute both on self and on the instanced object.  Anyone know?

Also, we'll add some code to the CookieGenerator class so that we can access those.

```
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
```

So, next we might want to create a player object, to keep track of how many cookies are clicked and spent by the player.  This one gets to be a small chunk of code pretty quick.

```
class Player
  attr_accessor :cookies_spent, :cookies_clicked

  def initialize
    @cookies_clicked = 0
    @cookies_spent = 0
  end

  def buyGenerator(generatorType, amount)
    cost_to_buy = ((Object::const_get(generatorType).cost) * amount)
    generator_to_buy = Object::const_get(generatorType).name

    if cookies > cost_to_buy
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
```

This (rather large) block of code, at least compared to some of the rest of the stuff we've done in setting this up implements a player object to buy cookie generators and does our simple 'click' to get a single cookie.  It'll also increment a variable whenever cookies are spent, and it'll keep track of all cookies by reporting (CookieGenerator.total_cookies_earned + cookies_clicked) - cookies_spent .  Yeah, it's not a great model, but, it works for the purposes of this particular game.

At this point, we have a semi-playable game/version of cookie clicker in irb, to demonstrate.

```
1.9.3-p385 :001 > require "./cookie_clicker.rb"
 => true
1.9.3-p385 :002 > p = Player.new
 => #<Player:0x007fa59986a0b0 @cookies_clicked=0, @cookies_spent=0>
1.9.3-p385 :003 > p.cookies
 => 0.0
1.9.3-p385 :004 > p.click
 => 1
1.9.3-p385 :005 > p.cookies
 => 1.0
1.9.3-p385 :006 > 15.times do
1.9.3-p385 :007 >     p.click
1.9.3-p385 :008?>   end
 => 15
1.9.3-p385 :009 > p.cookies
 => 16.0
1.9.3-p385 :010 > p.buyGenerator "CookieClicker", 1
Buying 1 Cookie Clicker
 => 1
1.9.3-p385 :011 > p.cookies
 => 1.3
1.9.3-p385 :012 > p.cookies
 => 1.6
1.9.3-p385 :013 >
1.9.3-p385 :014 >   CookieGenerator.all
 => [#<CookieClicker:0x007fa599941ee8 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-10 12:21:44 -0500>]
1.9.3-p385 :015 > p.cookies
 => 11.8
1.9.3-p385 :016 > p.click
 => 17
1.9.3-p385 :017 > 500.times do
1.9.3-p385 :018 >     p.click
1.9.3-p385 :019?>   end
 => 500
1.9.3-p385 :020 > p.buyGenerator "CookieBaker", 5
Buying 5 Cookie Baker
 => 5
1.9.3-p385 :021 > p.cookies
 => 23.5
1.9.3-p385 :022 > CookieGenerator.all
 => [#<CookieClicker:0x007fa599941ee8 @name="Cookie Clicker", @description="A clicker that generates 1 cookie every 10 seconds.", @rate=0.1, @cost=15, @created_at=2013-10-10 12:21:44 -0500>, #<CookieBaker:0x007fa5999763a0 @name="Cookie Baker", @description="A dedicated baker producing a cookies every 2 seconds.", @rate=0.5, @cost=100, @created_at=2013-10-10 12:24:01 -0500>, #<CookieBaker:0x007fa599976300 @name="Cookie Baker", @description="A dedicated baker producing a cookies every 2 seconds.", @rate=0.5, @cost=100, @created_at=2013-10-10 12:24:01 -0500>, #<CookieBaker:0x007fa599976260 @name="Cookie Baker", @description="A dedicated baker producing a cookies every 2 seconds.", @rate=0.5, @cost=100, @created_at=2013-10-10 12:24:01 -0500>, #<CookieBaker:0x007fa5999761c0 @name="Cookie Baker", @description="A dedicated baker producing a cookies every 2 seconds.", @rate=0.5, @cost=100, @created_at=2013-10-10 12:24:01 -0500>, #<CookieBaker:0x007fa599976120 @name="Cookie Baker", @description="A dedicated baker producing a cookies every 2 seconds.", @rate=0.5, @cost=100, @created_at=2013-10-10 12:24:01 -0500>]
1.9.3-p385 :023 > p.cookies
 => 127.5
1.9.3-p385 :024 >
```
