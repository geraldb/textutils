# encoding: utf-8


module TextUtils
  module AddressHelper

  def normalize_address( old_address_line )
    # for now only checks german 5-digit zip code
    #
    #  e.g.  Alte Plauener Straße 24 // 95028 Hof  becomes
    #        95028 Hof // Alte Plauener Straße 24 

    new_address_line = old_address_line   # default - do nothing - just path through

    lines = old_address_line.split( '//' )

    if lines.size == 2   # two lines / check for switching lines
      line1 = lines[0].strip
      line2 = lines[1].strip
      if line2 =~ /^[0-9]{5}\s/
        new_address_line = "#{line2} // #{line1}"   # swap - let line w/ 5-digit zip code go first
      end
    end

    new_address_line
  end
  

  #  todo/fix: add _in_adr or _in_addr to name - why? why not?

  def find_city_for_country( country_key, address )

    return nil if address.blank?    # do NOT process nil or empty address lines; sorry

    lines = address.split( '//' )

    if country_key == 'at' || country_key == 'de'
      # first line strip numbers (assuming zip code) and whitespace
      line1 = lines[0]
      line1 = line1.gsub( /\b[0-9]+\b/, '' )   # use word boundries (why? why not?)
      line1 = line1.strip
      
      return nil if line1.blank?   # nothing left sorry; better return nil
      
      line1   # assume its the city
    else
      nil   # unsupported country/address schema for now; sorry
    end
  end
  

  end # module AddressHelper
end # module TextUtils