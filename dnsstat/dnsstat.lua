local request_hash = {}
do
      local function init_listener()
            local tap = Listener.new("ip", "dns")
            function tap.packet(pinfo,tvb,ip)
                  if (dns.flags.response == 0)
                        request_hash[dns.id] = frame.time_epoch
                  
