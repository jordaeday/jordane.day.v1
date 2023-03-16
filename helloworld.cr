require "http/server"
require "router"

#info needed:
#done watching/not started/ in progress | who watch w/ (name object instead of string? future?)
# | name of show | streaming platform | not_done? season and ep : nil

class WebServer
    include Router

    @@list = Array(Array(Int32 | String | String | String)).new
    @@list = [[0,"name ppl","show name","streaming","done?"], [1,"name ppl","show name","streaming","done?"]]

    def get_list
        return @@list
    end
    def set_list(list)
        @@list = list
    end
    def add_to_list(addition = [0,"name ppl","show name","streaming","done?"])
        list = get_list
        list << addition
        set_list(list)
    end

    def draw_routes
        get "/" do |context, params|
            context.response.print "hewwo router.cr :3333\n\n"
            context.response.print "pages:\n"
            context.response.print "/add    -> add a movie/show to list\n"
            context.response.print "/list   -> view your list\n"
            context.response.print "/edit   -> edit an entry\n"
            context.response.print "/nuke   -> remove all entries\n"
            context
        end
        get "/other" do |context, params|
            context.response.print "other pagie wagie :33333"
            context
        end
        get "/add" do |context, params|
            context.response.print "add page\n\n"
            add_to_list
            context.response.print "added!"
            context
        end
        get "/list" do |context, params|
            context.response.print "list page\n\n"
            list = get_list
            count_entries = list.size
            count = 0
            while count < count_entries
                context.response.print "#{list[count]}\n"
                count += 1
            end
            context
        end
        get "/edit" do |context, params|
            context.response.print "edit page"
            context
        end
        get "/nuke" do |context, params|
            context.response.print "nuke page\n\n"
            list = Array(Array(Int32 | String | String | String)).new
            set_list(list)
            context.response.print "nuked!"
            context
        end
    end

    def run
        server = HTTP::Server.new(route_handler)
        server.bind_tcp 8080
        server.listen
    end
end

web_server = WebServer.new
web_server.draw_routes
puts "log"
web_server.run