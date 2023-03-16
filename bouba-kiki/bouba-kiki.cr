require "./ipaify.cr"

def do_stuff(input)
    #puts(input)
    list = get_list(input)
    bouba = ["ɑ", "oʊ", "u", "b", "m", "d", "n", "l"]
    kiki = ["i", "ɪ", "ɝ", "p", "f", "t", "s", "z", "ʃ", "k"]
    ipaArray = [] of String

    sent_bouba_value = 0.0
    word_bouba_value = [] of Float64
    sent_kiki_value = 0.0
    word_kiki_value = [] of Float64
    total_sent_value = 0

    percent_bouba = 0
    percent_kiki = 0

    #calcs b/k value per word
    list.each do |word|
        bouba_value = 0.0
        kiki_value = 0.0

        ipaArray << word

        bouba.each do |b_let|
            if word.includes?(b_let)
                bouba_value += 1
            end
        end
        bouba_value = bouba_value / list.size
        word_bouba_value << bouba_value

        kiki.each do |k_let|
            if word.includes?(k_let)
                kiki_value += 1
            end
        end
        kiki_value = kiki_value / list.size
        word_kiki_value << kiki_value
    end

    #calcs b/k value for sentence
    word_bouba_value.each do |value|
        sent_bouba_value += value
    end
    word_kiki_value.each do |value|
        sent_kiki_value += value
    end
    total_sent_value = sent_kiki_value + sent_bouba_value

    #calcs percent b/k
    percent_bouba = sent_bouba_value/total_sent_value
    percent_kiki = sent_kiki_value/total_sent_value

    #return
    return [word_bouba_value, word_kiki_value, sent_bouba_value, sent_kiki_value, percent_bouba, percent_kiki, ipaArray]
end