package rhttp;

import "core:net"
import "core:fmt"
import "core:strings"
import "core:bytes"
import "base:runtime"
import "core:time"

Mini_struct :: struct {
    str : string,
    integer : int,
    boolean : bool,
    float : f32,
}

test_struct :: struct {

    str : string,
    integer : int,
    boolean : bool,
    float : f32,
    array : [2]string,
    object : Mini_struct
}

@(private="file")
SERVER_TEMP_BUFFER :: 4096;

Server :: struct {

    //User data
    config : Server_config,
    
    //Package private
    router : Router,
    socket : net.TCP_Socket

}

init_server :: proc(s : ^Server, config : Server_config = defualt_server_config) {

    fmt.printfln("Initializing Server....");
    
    router : Router;
    init_router(&router);

    s.config = config;
    s.router = router;
    
}

start_server :: proc(s : ^Server) {

    fmt.printf("Starting server.........");

    listen_socket, listen_err := net.listen_tcp(net.Endpoint{
        address = net.parse_address(s.config.url),
        port = s.config.port,
    });

    if listen_err != nil {
        fmt.panicf("listen error: %s", listen_err);
    }

    fmt.printf("Server is running on port %d\n", s.config.port);

    main_loop : for {
        // Accept a client connection
        client_socket, _, accept_err := net.accept_tcp(listen_socket);
        if accept_err != nil {
            fmt.panicf("accept error: %s", accept_err);
        } else {
            fmt.println("Client connected!");

            //Prepare buffer
            request_buffer := make([dynamic]byte);
            defer delete(request_buffer);

            //Read
            recv_loop : for {
                buff : [SERVER_TEMP_BUFFER]byte;
                bytes_read, err := net.recv_tcp(client_socket, buff[:]);
                if err != nil {
                    fmt.panicf("error while receiving data: %s", err);
                }

                for b in buff {
                    append(&request_buffer, b)
                }
                //TODO: Find out when to break the loop
                break recv_loop;
            }

            request_handle_error : RhttpError
            response_data : []byte
            
            request, parse_err := parse_request(string(request_buffer[:]));
            defer destroy_request(&request)
            if parse_err.status != .NONE {
                request_handle_error = parse_err
            }

            response : Response;
            defer destroy_response(&response);
            handle_err : RhttpError;

            //Handle the request
            if request_handle_error.status == .NONE {
                response, handle_err = handle_request(s.router, request); 
                
                //Set error to user based error
                if handle_err.status != .NONE {
                    request_handle_error = handle_err
                }
            }
            
            add_standard_response_info(&response);
            response_data = parse_response(response, request_handle_error);

            //send data back to client
            sent, send_err := net.send_tcp(client_socket, response_data);
            if send_err != nil {
                fmt.panicf("Error sending data: %#v", send_err);
            }
        }
        
        net.close(client_socket);
    }
}

//This should simply be called when encountering an error which should result in shutdown
@(private)
shutdown_server_gracefully :: proc(s : ^Server) {

}

destroy_server :: proc(s : ^Server) {
    fmt.printfln("Destoying server....");
    destroy_router(&s.router);
}
