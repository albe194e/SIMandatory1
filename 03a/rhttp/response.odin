package rhttp;

import "core:fmt"
import "core:strings"
import "core:bytes"
import "core:reflect"

Response :: struct {

    status_line : Status_line,
    headers : Headers,
    settings : Response_settings,
    body : Response_body
}

Response_body :: struct {
    content : string
}

Status_line :: struct {

    version : string,
    status : Response_status
}

Response_status :: struct {
    code : Status_code,
    desc : string
}

Response_settings :: struct {
    content_type : Content_type
}

//Determines what format should be build
Content_type :: enum {
    NONE,
    JSON,
    XML
}

parse_response :: proc(r : Response, err : RhttpError) -> []byte {

    to_concat := make([dynamic]string)
    defer delete(to_concat)

    fmt.printfln("ERR: %#v", err)
    fmt.printfln("R: %#v", r)

    err_parse : bool
    status : Response_status
    
    //Error parse
    if err.status != .NONE {
        err_parse = true
        status.code = err.status;
        status.desc = err.message;

    } else if cast(u16)r.status_line.status.code >= 400 {
        err_parse = true
        status = r.status_line.status
    } else {
        status = r.status_line.status
    }

    //Status line
    append(&to_concat, strings.concatenate({
        r.status_line.version,
        " ", 
        convert_status_code_to_str(status.code), 
        "\r\n"}));

    //Headers
    for k, v in r.headers.kv {
        append(&to_concat, strings.concatenate({k, ": ", v, "\r\n"}));
    }

    append(&to_concat, "\r\n")


    //Body
    body : []byte;
    if err_parse {
        body = transmute([]byte)r.status_line.status.desc
    } else {
        body = transmute([]byte)r.body.content
    }
    //body := build_json_body(r.body.content)

    fmt.printfln("Response: %s", strings.concatenate(to_concat[:]))

    response := transmute([]byte)strings.concatenate(to_concat[:])

    return bytes.concatenate({response, body})
}

add_standard_response_info :: proc(r : ^Response) {

    //Add standard headers
    implicit_headers(r)

}

@(private="file")
check_response :: proc(r : Response, err : RhttpError) -> bool {

    fmt.printfln("R: %#v", r)
    fmt.printfln("ERR: %#v", err)
    
    if err.status != .NONE {
        return false;
    }

    if cast(u16)r.status_line.status.code >= 400 {
        return false;
    }

    return true
}


init_response :: proc(r : ^Response) {

    r.status_line.version = "HTTP/1.1"
}

destroy_response :: proc(r : ^Response) {

    delete(r.headers.kv)
}
