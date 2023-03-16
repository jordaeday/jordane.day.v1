require "http/server"
require "router"
require "./bouba-kiki/bouba-kiki.cr"

class WebServer
    include Router

    def draw_routes
        get "/" do |context, params|
            context.response.print helper("./html/index.html")
            context
        end
        get "/projects" do |context, params|
            context.response.print helper("./html/projects.html")
            context
        end
        get "/projects/bouba-kiki" do |context, params|
            context.response.print helper("./html/bouba-kiki.html")
            context
        end
        get "/projects/bouba-kiki/get" do |context, params|
            text = context.request.query_params["text"]
            if text
                context.response.print do_stuff(text)
            end
            context
        end
        # get "/projects/sudoku" do |context, params|
        #     context.response.print File.read("./html/sudoku.html") #make this file lawl
        # end
        get "*" do |context, params|
            begin
                context.response.print File.read("./html" + context.request.path)
            rescue
                context.response.content_type = "text/html"
                context.response.status_code = 404
                context.response.print helper("./html/error.html")
            end
            context
        end
    end

    def helper(path)
        page = File.read("./html/template.html")
        page = page.gsub("content_here", File.read(path))
        return page
    end

    def run
        server = HTTP::Server.new(route_handler)
        server.bind_tcp "0.0.0.0", 8080
        server.listen
    end
end

web_server = WebServer.new
web_server.draw_routes
puts "log"
web_server.run