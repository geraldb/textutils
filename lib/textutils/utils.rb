# encoding: utf-8


class File
  def self.read_utf8( path )
    text = open( path, 'r:bom|utf-8' ) do |file|
      file.read
    end
    ### for convenience for now convert fancy dash to "plain" dash
    ## todo: check char codes for "fancy" dash alternatives
    text.gsub!( /—|–/ ) do |_|
      puts "*** warning: convert fancy dash to 'plain' dash in file >#{path}<"
      ### exit 1   #### do NOT tolerate!! cleanup dashes for now
      '-'
    end
    text
  end
end # class File

  
  ############
  ### fix/todo: share helper for all text readers/parsers- where to put it?  
  ###
  
  def title_esc_regex( title_unescaped )
      
      ##  escape regex special chars e.g. . to \. and ( to \( etc.
      # e.g. Benfica Lis.
      # e.g. Club Atlético Colón (Santa Fe)

      ## NB: cannot use Regexp.escape! will escape space '' to '\ '
      ## title = Regexp.escape( title_unescaped )
      title = title_unescaped.gsub( '.', '\.' )
      title = title.gsub( '(', '\(' )
      title = title.gsub( ')', '\)' )

      ##  match accented char with or without accents
      ##  add (ü|ue) etc.
      ## also make - optional change to (-| ) e.g. Blau-Weiss == Blau Weiss

      ## todo: add some more
      ## see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references  for more
      ##
      ##  reuse for all readers!
      
      alternatives = [
        ['-', '(-| )'],  ## e.g. Blau-Weiß Linz
        ['æ', '(æ|ae)'],  ## e.g. 
        ['á', '(á|a)'],  ## e.g. Bogotá, Sársfield
        ['ã', '(ã|a)'],  ## e.g  São Paulo
        ['ä', '(ä|ae)'],  ## e.g. 
        ['ç', '(ç|c)'],  ## e.g. Fenerbahçe
        ['é', '(é|e)'],  ## e.g. Vélez
        ['ê', '(ê|e)'],  ## e.g. Grêmio
        ['ñ', '(ñ|n)'],  ## e.g. Porteño
        ['ň', '(ň|n)'],  ## e.g. Plzeň
        ['Ö', '(Ö|Oe)'], ## e.g. Österreich
        ['ö', '(ö|oe)'],  ## e.g. Mönchengladbach
        ['ó', '(ó|o)'],   ## e.g. Colón
        ['ș', '(ș|s)'],   ## e.g. Bucarești
        ['ß', '(ß|ss)'],  ## e.g. Blau-Weiß Linz
        ['ü', '(ü|ue)'],  ## e.g. 
        ['ú', '(ú|u)']  ## e.g. Fútbol
      ]
      
      alternatives.each do |alt|
        title = title.gsub( alt[0], alt[1] )
      end

      title
  end
