package main

import "core:fmt"
import "core:net"
import "core:strings"

import "rhttp"

run :: proc() {
    
    //Initiate the server
    s : rhttp.Server;

    rhttp.init_server(&s);
    defer rhttp.destroy_server(&s)

    rhttp.add_route(
        &s.router,
        rhttp.Route{
            path = "/json",
            action = send_json
        }
    )

    rhttp.add_route(
        &s.router,
        rhttp.Route{
            path = "/xml",
            action = send_xml
        }
    )

    rhttp.add_route(
        &s.router,
        rhttp.Route{
            path = "/csv",
            action = send_csv
        }
    )

    rhttp.add_route(
        &s.router,
        rhttp.Route{
            path = "/yaml",
            action = send_yaml
        }
    )

    rhttp.add_route(
        &s.router,
        rhttp.Route{
            path = "/text",
            action = send_txt
        }
    )

    //Start the server
    rhttp.start_server(&s)
}

//JSON
send_json :: proc () -> (r : rhttp.Response) {

    rhttp.init_response(&r)
    r.body.content = "{\"message\": \"Sending JSON from RunicHttp\"}"

    r.settings.content_type = .JSON
    r.status_line.status.code = .OK
    r.status_line.status.desc = "Some error message"

    rhttp.add_header(&r.headers, "Access-Control-Allow-Origin", "*")

    return r
}

//XML
send_xml :: proc () -> (r : rhttp.Response) {

    rhttp.init_response(&r)
    r.body.content = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<response>\n    <message>Sending JSON from RunicHttp</message>\n</response>"
    r.status_line.status.code = .OK

    return r
}

//CSV
send_csv :: proc () -> (r : rhttp.Response) {

    rhttp.init_response(&r)
    r.body.content = strings.concatenate({
        "id,name,age,email\n",
        "1,John Doe,28,john.doe@example.com\n",
        "2,Jane Smith,34,jane.smith@example.com\n",
        "3,Michael Johnson,25,michael.johnson@example.com\n",
        "4,Emily Davis,40,emily.davis@example.com\n",
        "5,Chris Brown,22,chris.brown@example.com"
    })
    r.status_line.status.code = .OK

    return r
}

//YAML
send_yaml :: proc () -> (r : rhttp.Response) {

    rhttp.init_response(&r)
    r.body.content = strings.concatenate({
        "users:\n",
        "  - id: 1\n",
        "    name: John Doe\n",
        "    age: 28\n",
        "    email: john.doe@example.com\n",
        "  - id: 2\n",
        "    name: Jane Smith\n",
        "    age: 34\n",
        "    email: jane.smith@example.com\n",
        "  - id: 3\n",
        "    name: Michael Johnson\n",
        "    age: 25\n",
        "    email: michael.johnson@example.com\n"
    })
    r.status_line.status.code = .OK

    return r
}

//Text
send_txt :: proc () -> (r : rhttp.Response) {

    rhttp.init_response(&r)
    r.body.content = "Hello, Sending data as Text from RunicHttp server"
    r.status_line.status.code = .OK

    return r
}



//
main :: proc () {
    {
        run();
    
    }
}
