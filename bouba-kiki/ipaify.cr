require "http/client"
require "json"
require "xml"

def get_list(input)
    user_string = input
    bod = "orthography=#{user_string}&baseline=&aspiration=on&approximant_devoicing=on&initial_devoicing=on&affrication=on&glottal=on&glottal_t=on&flapping=on&dark_l=on&nasalization=on&vowel_devoicing=on&syllabic_consonants=on"

    #puts(bod)
    response = HTTP::Client.post("https://ling.meluhha.com/process", headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}, body: bod)
    #puts(response)
    #puts(response.body)

    json = JSON.parse(response.body)
    #puts("json: #{json}")
    data = json["orthography"].as_s
    #puts("ortho: #{data}")
    xml = XML.parse("<wrapper>"+data[1, data.size-2]+"</wrapper>")
    words_list = ipa_list(xml)
    #puts(words_list)
    #puts(typeof(xml.children))
    return words_list
end

def ipa_list(xml)
    words = ""
    words_list = [] of String
    first = xml.first_element_child
    if first
        first.children.each do |child| # Select only element children
            if child["style"]? != "display:none;"
                words_list << "#{child.inner_text}"
            end
        end
    end
    #puts(words_list)

    small_words_list = [] of String
    index = 0;
    words_list.each do |word|
        if index+1 == words_list.size
            small_words_list << words_list[index]
            break
        end
        if words_list[index+1] == " " 
            small_words_list << words_list[index]
        end
        index += 1
    end
    #puts(small_words_list)
    return arr_number_remover(small_words_list)
end

def arr_number_remover(list)
    new_list = [] of String
    list.each do |word|
        if w = /.*[^,\d]/.match(word)
            new_list << w[0]
        end
    end
    #puts(new_list)
    return new_list
end