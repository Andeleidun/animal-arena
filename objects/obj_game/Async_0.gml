/// @description Async-Networking: handle UDP broadcasts
var _type = async_load[? "type"];
if (_type == network_socket_udp)
{
    var _buffer = async_load[? "buffer"];
    if (_buffer != -1)
    {
        var _ip = async_load[? "ip"];
        var _data = buffer_read(_buffer, buffer_string);

        if (string_copy(_data, 1, 5) == "HOST:")
        {
            var _code = string_copy(_data, 6, string_length(_data) - 5);
            var _found = false;
            for (var _i = 0; _i < ds_list_size(discovered_hosts); _i++)
            {
                var _entry = discovered_hosts[| _i];
                if (_entry[? "ip"] == _ip)
                {
                    _entry[? "code"] = _code;
                    _entry[? "timer"] = 300;
                    _found = true;
                    break;
                }
            }
            if (!_found)
            {
                var _map = ds_map_create();
                ds_map_add(_map, "ip", _ip);
                ds_map_add(_map, "code", _code);
                ds_map_add(_map, "timer", 300);
                ds_list_add(discovered_hosts, _map);
            }
        }

        buffer_delete(_buffer);
    }
}
