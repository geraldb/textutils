# encoding: utf-8


module TextUtils
  module StringFilter

      ##  turn accented char into ascii look alike if possible
      ##
      ## todo: add some more
      ## see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references  for more
      
      ## todo: add unicode codepoint name ???

    ASCIIFY_MAPPINGS = [
        ['ß', 'ss'],  # -- Latin small letter sharp s (ess-zed); see German Eszett // &szlig

        ['æ', 'ae'],  # -- Latin small letter ae (Latin small ligature ae) // &aelig
        ['ä', 'ae'],  # -- Latin small letter a with diaeresis // &auml
        ['ā', 'a' ],  # e.g. Liepājas, Kāṭhmāḍaũ
        ['á', 'a' ],  # e.g. Bogotá, Králové
        ['à', 'a' ],  # e.g. Thành Phố Hồ Chí Minh [Saigon]
        ['ã', 'a' ],  # e.g  São Paulo
        ['ă', 'a' ],  # e.g. Chișinău
        ['â', 'a' ],  # e.g  Goiânia
        ['å', 'a' ],  # e.g. Vålerenga
        ['ą', 'a' ],  # e.g. Śląsk

        ['ç', 'c' ],  # e.g. São Gonçalo, Iguaçu, Neftçi
        ['ć', 'c' ],  # e.g. Budućnost
        ['č', 'c' ],  # e.g. Tradiční, Výčepní

        ['ḍ', 'd' ],  # e.g. Kāṭhmāḍaũ [Kathmandu]

        ['é', 'e' ],  # e.g. Vélez, Králové
        ['è', 'e' ],  # e.g. Rivières
        ['ê', 'e' ],  # e.g. Grêmio
        ['ě', 'e' ],  # e.g. Budějovice
        ['ĕ', 'e' ],  # e.g. Svĕtlý
        ['ė', 'e' ],  # e.g. Vėtra
        ['ë', 'e' ],  # e.g. Skënderbeu

        ['ğ', 'g' ],  # e.g. Qarabağ

        ['ḥ', 'h' ],  # e.g. Ad-Dawḥah [Doha]

        ['ì', 'i' ],  # e.g. Potosì
        ['í', 'i' ],  # e.g. Ústí
        ['ï', 'i' ],  # e.g. El Djazaïr
        ['ī', 'i' ],  # e.g. Al-Iskandarīyah [Alexandria]

        ['ł', 'l' ],  # e.g. Wisła, Wrocław
        ['ñ', 'n' ],  # e.g. Porteño
        ['ň', 'n' ],  # e.g. Plzeň, Třeboň

        ['ö', 'oe'],
        ['ő', 'o' ],  # e.g. Győri
        ['ó', 'o' ],  # e.g. Colón, Łódź, Kraków
        ['õ', 'o' ],  # e.g. Nõmme
        ['ô', 'o' ],  # e.g. Amazônia (pt)
        ['ō', 'o' ],  # e.g. Tōkyō, Pishōr
        ['ŏ', 'o' ],  # e.g. P'yŏngyang [Pyongyang]
        ['ø', 'o' ],  # e.g. Fuglafjørdur, København
        ['ố', 'o' ],  # e.g. Thành Phố Hồ Chí Minh [Saigon]
        ['ồ', 'o' ],  # e.g. Thành Phố Hồ Chí Minh [Saigon]
        ['ộ', 'o' ],  # e.g. Hà Nội [Hanoi]

        ['ř', 'r' ],  # e.g. Třeboň

        ['ș', 's' ],  # e.g. Chișinău, București
        ['ş', 's' ],  # e.g. Beşiktaş
        ['š', 's' ],  # e.g. Košice
        ['ṣ', 's' ], # e.g. Al-Mawṣil [Mosul]

        ['ť', 't' ],  # e.g. Měšťan
        ['ṭ', 't' ],  # e.g. Al-Kharṭūm [Khartoum], Kāṭhmāḍaũ

        ['ü', 'ue'],
        ['ú', 'u' ],  # e.g. Fútbol
        ['ù', 'u' ],  # e.g. Xyauyù (it)
        ['ū', 'u' ],  # e.g. Sūduva
        ['ů', 'u' ],  # e.g. Sládkův
        ['ũ', 'u' ],  # e.g. Kāṭhmāḍaũ [Kathmandu]

        ['ı', 'u' ],  # e.g. Bakı   # use u?? (Baku) why-why not?

        ['x̌', 'x'],   # e.g. Pex̌awar  [Peshawar]

        ['ý', 'y' ],  # e.g. Nefitrovaný
        ['ź', 'z' ],  # e.g. Łódź
        ['ž', 'z' ],  # e.g. Domžale, Petržalka
        ['ż', 'z' ],  # e.g. Lomża  (polish)

        ['Æ', 'Ae' ], # -- Latin capital letter AE
        ['Á', 'A' ],  # e.g. Águila (es)
        ['Å', 'A' ],  # e.g. Åland Islands -- Latin capital letter A with ring above // &Aring;

        ['Ç', 'C' ],  # --  Latin capital letter C with cedilla -- &Ccedil
        ['Č', 'C' ],  # e.g. České

        ['Ḥ', 'H' ],  # e.g. Ḥalab [Aleppo]
        ['Ḫ', 'H' ],  # e.g. Ḫamīs Mušayṭ
        ['İ', 'I' ],  # e.g. İnter
        ['Í', 'I' ],  # e.g. ÍBV
        ['Ł', 'L' ],  # e.g. Łódź

        ['Ö', 'Oe' ], # e.g. Örebro -- Latin capital letter O with diaeresis // &Ouml;
        ['Ō', 'O' ],  # e.g. Ōsaka [Osaka] -- 
        ['Ø', 'O' ],  # e.g. Nogne Ø Imperial Stout (no) -- Latin capital letter O with stroke (Latin capital letter O slash) // &Oslash

        ['Ř', 'R' ],  # e.g. Řezák

        ['Ś', 'S' ],  # e.g. Śląsk
        ['Š', 'S' ],  # e.g. MŠK   -- Latin capital letter S with caron // &Scaron;
        ['Ş', 'S' ],  # e.g. Şüvälan
        ['Ṣ', 'S' ],  # e.g. Ṣan'ā' [Sana'a]

        ['Ṭ', 'T' ],  # e.g. Ṭarābulus [Tripoli]
        ['Ú', 'U' ],  # e.g. Ústí, Újpest
        ['Ž', 'Z' ],   # e.g. Žilina
        ['Ż', 'Z' ]    # e.g. Żywiec (polish) -- Latin captial letter Z with caron
      ]


  def asciify( content, options={} )
    ### fix: use content.each_char and hash_map or similar instead of gsub

    ASCIIFY_MAPPINGS.each do |mapping|
      content = content.gsub( mapping[0], mapping[1] )
    end
    content
  end

  def slugify( content, options={} )
    # 1) asciify
    content = asciify( content ).downcase

    # 2) replace space () with dash (-)
    content = content.gsub( ' ', '-' )
    content    
  end


  end # module StringFilter

  module Filter
    include StringFilter
  end # module Filter

end   # module TextUtils
