# encoding: utf-8


module TextUtils
  module ValueHelper


  def match_country( value )
    if value =~ /^country:/   ## country:
      country_key = value[8..-1]  ## cut off country: prefix
      country = Country.find_by_key!( country_key )
      yield( country )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def is_region?( value )
    # assume region code e.g. TX or N
    value =~ /^[A-Z]{1,2}$/
  end

  ## fix/todo: use match_region_for_country! w/ !!! why? why not?
  def match_region_for_country( value, country_id )  ## NB: required country_id 
    if value =~ /^region:/   ## region:
      region_key = value[7..-1]  ## cut off region: prefix
      region = Region.find_by_key_and_country_id!( region_key, country_id )
      yield( region )
      true  # bingo - match found
    elsif is_region?( value )  ## assume region code e.g. TX or N
      region = Region.find_by_key_and_country_id!( value.downcase, country_id )
      yield( region )
      true  # bingo - match found
    else
      false # no match found
    end
  end


  def match_city( value )
    if value =~ /^city:/   ## city:
      city_key = value[5..-1]  ## cut off city: prefix
      city = City.find_by_key( city_key )
      yield( city )  # NB: might be nil (city not found)
      true # bingo - match found
    else
      false # no match found
    end
  end


  def match_brewery( value )
    if value =~ /^by:/   ## by:  -brewed by/brewery
      brewery_key = value[3..-1]  ## cut off by: prefix
      brewery = Brewery.find_by_key!( brewery_key )
      yield( brewery )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def is_year?( value )
    # founded/established year e.g. 1776
    value =~ /^[0-9]{4}$/
  end

  def match_year( value )
    if is_year?( value )  # founded/established year e.g. 1776
      yield( value.to_i )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def is_website?( value )
    # check for url/internet address e.g. www.ottakringer.at
    #  - must start w/  www. or
    #  - must end w/   .com
    #
    # fix: support more url format (e.g. w/o www. - look for .com .country code etc.)
    value =~ /^www\.|\.com$/
  end

  def match_website( value )
    if is_website?( value )   # check for url/internet address e.g. www.ottakringer.at
      # fix: support more url format (e.g. w/o www. - look for .com .country code etc.)
      yield( value )
      true # bingo - match found
    else
      false # no match found
    end
  end



  def is_address?( value )
    # if value includes // assume address e.g. 3970 Weitra // Sparkasseplatz 160
    value =~ /\/{2}/
  end

  def is_taglist?( value )
    value =~ /^[a-z0-9\|_ ]+$/
  end


  def find_grade( value )  # NB: returns ary [grade,value] / two values
    grade = 4  # defaults to grade 4  e.g  *** => 1, ** => 2, * => 3, -/- => 4

    value = value.sub( /\s+(\*{1,3})\s*$/ ) do |_|  # NB: stars must end field/value
      if $1 == '***'
        grade = 1
      elsif $1 == '**'
        grade = 2
      elsif $1 == '*'
        grade = 3
      else
        # unknown grade; not possible, is'it?
      end
      ''  # remove * from title if found
    end

    [grade,value]
  end


  def find_key_n_title( values )  # NB: returns ary [attribs,more_values] / two values

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ### todo/fix: allow check - do NOT allow mixed use of with key and w/o key
    ##  either use keys or do NOT use keys; do NOT mix in a single fixture file

    ### support autogenerate key from first title value

    # if it looks like a key (only a-z lower case allowed); assume it's a key
    #   - also allow . in keys e.g. world.quali.america, at.cup, etc.
    #   - also allow 0-9 in keys e.g. at.2, at.3.1, etc.

    # fix/todo: add support for leading underscore _
    #   or allow keys starting w/ digits?
    if values[0] =~ /^([a-z][a-z0-9.]*[a-z0-9]|[a-z])$/    # NB: key must start w/ a-z letter (NB: minimum one letter possible)
      key_col         = values[0]
      title_col       = values[1]
      more_values     = values[2..-1]
    else
      key_col         = '<auto>'
      title_col       = values[0]
      more_values     = values[1..-1]
    end

    attribs = {}

    ## check title_col for grade (e.g. ***/**/*) and use returned stripped title_col if exits
    grade, title_col = find_grade( title_col )

    # NB: for now - do NOT include default grade e.g. if grade (***/**/*) not present; attrib will not be present too
    if grade == 1 || grade == 2 || grade == 3  # grade found/present
      logger.debug "   found grade #{grade} in title"
      attribs[:grade] = grade
    end

    ## title (split of optional synonyms)
    # e.g. FC Bayern Muenchen|Bayern Muenchen|Bayern
    titles = title_col.split('|')

    attribs[ :title ]    =  titles[0]

    ## add optional synonyms if present
    attribs[ :synonyms ] =  titles[1..-1].join('|')  if titles.size > 1

    if key_col == '<auto>'
      ## autogenerate key from first title
      key_col = TextUtils.title_to_key( titles[0] )
      logger.debug "   autogen key »#{key_col}« from title »#{titles[0]}«"
    end

    attribs[ :key ] = key_col

    [attribs, more_values]
  end

  end # module ValueHelper
end # module TextUtils