package rhttp;

import "core:bytes"
import "core:strings"
import "core:fmt"
import "core:time"
import "core:reflect"

Headers :: struct {
    kv : map[string]string
}

/* --- User methods --- */


add_header :: proc(headers : ^Headers, k, v : string) {
    headers.kv[k] = v
}


/* --- Private methods --- */

//Standard response headers not set by user
@(private)
implicit_headers :: proc(r : ^Response) {

    //Content-length
    //content_length := len(transmute([]byte)r.body.content)
    //add_header(&r.headers, "Content-Length", fmt.aprintf("%i", content_length))

    //Date
    //TODO: Properly format date and rewrite code so server calculates date occationaly to increase speed.
    date_time := time.now()
    date_buff : [120]u8
    //r.headers.kv["Date"] = strings.clone(time.to_string_dd_mm_yy(date_time, date_buff[:]))

    //Content-type
    add_header(&r.headers, "Content-Type", fmt.aprintf("application/%v", content_type_to_str(r.settings.content_type)))

    //Server
    add_header(&r.headers, "Server", "RunicHttp/Alpha release")
}

@(private)
content_type_to_str :: proc(ct : Content_type) -> string {

    enum_str, ok := reflect.enum_name_from_value(ct)

    if !ok {
        fmt.panicf("Could not parse content_type: %v ", ct)
    }

    return strings.to_lower(enum_str)
}
