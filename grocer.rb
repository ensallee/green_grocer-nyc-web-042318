require 'pry'

def consolidate_cart(cart)
  new_hash={}
  cart.each do |list|
    list.each do |item, qualities|
      if new_hash[item]
        qualities[:count] += 1
      else
        qualities[:count] = 1
        new_hash[item] = qualities
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |item, qualities|
    new_cart[item] = qualities
    coupons.each do |deal|
      if new_cart[item][:count] >= deal[:num]
        deal.each do |key, value|
          if value == item
            new_cart["#{item} W/COUPON"] ||= {}
            new_cart["#{item} W/COUPON"][:price] ||= deal[:cost]
            new_cart["#{item} W/COUPON"][:clearance] ||= cart[item][:clearance]
          if new_cart["#{item} W/COUPON"][:count]
            new_cart["#{item} W/COUPON"][:count] += 1
          else
            new_cart["#{item} W/COUPON"][:count] = 1
          end
          new_cart[item][:count]=new_cart[item][:count] - deal[:num]
          end
        end
      end
    end
  end
  new_cart
end

def apply_clearance(cart)
  cart.each do |item, qualities|
    if(qualities[:clearance])
      qualities[:price]=qualities[:price]*0.80
      qualities[:price]=qualities[:price].round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  new_cart_coupons=apply_coupons(new_cart, coupons)
  coupons_and_clearance=apply_clearance(new_cart_coupons)

  total=0
  coupons_and_clearance.each do |item, qualities|
    total += qualities[:price] * qualities[:count]
  end

  if total > 100
    total= total*0.90
  end
  total
end
