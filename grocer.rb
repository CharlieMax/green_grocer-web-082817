def consolidate_cart(cart)
  consolidated = {}
  cart.each do |the_cart|
    the_cart.each do |key, value|
      unless consolidated[key]
        consolidated[key] = value
        consolidated[key][:count] = 0
      end
      consolidated[key][:count] += 1
    end
  end
  consolidated
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count]= cart[coupon[:item]][:count] - coupon[:num]
      if cart.key?("#{coupon[:item]} W/COUPON")
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      else
        cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  total = 0
  (apply_clearance(apply_coupons(consolidate_cart(cart), coupons))).each do |k, v|
    total += v[:price] * v[:count]
  end
  total = total * 0.9 if total > 100
  total
end
