require "pry"

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item_desc|
    item_desc.each do |item, attributes|
      new_cart[item] ||= attributes
      new_cart[item][:count] ||= 0
      new_cart[item][:count] += 1
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  if coupons != []
    cart_w_coup = {}
    cart.each do |item, attributes|
      attributes.each do |attribute, value|
        coupons.each do |coupon|
          coup_count = 0
          coupon.each do |coup_attribute, coup_value|
            if coupon[:item] == item
              if attributes[:count] >= coupon[:num]
                coup_count += 1
                cart_w_coup[item] ||= attributes
                cart_w_coup[item][:count] -= coupon[:num]
                item1 = item + " W/COUPON"
                cart_w_coup[item1] ||= {}
                cart_w_coup[item1][:clearance] ||= attributes[:clearance]
                cart_w_coup[item1][:count] = coup_count
                cart_w_coup[item1][:price] = coupon[:cost]
              end
            else
              cart_w_coup[item] ||= attributes
            end
          end
        end
      end
    end
    cart_w_coup
  else
    cart
  end
end

def apply_clearance(cart)
  cart.each do |item, attributes|
    if attributes[:clearance] == true
      attributes[:price] = (0.80*attributes[:price]).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total_cost = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |item, attributes|
    total_cost += attributes[:count]*attributes[:price]
  end
  if total_cost > 100
    total_cost = (total_cost*0.90).round(2)
  else
    total_cost
  end
end
