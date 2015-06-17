local request_hash = {}
do
      dumpers = {}
      local function init_listener()
            local tap = Listener.new("ip", "dns")
            function tap.packet(pinfo,tvb,ip)
                  if (dns.flags.response == 0) then
                        request_hash[dns.id] = frame.time_epoch
                  end
                  if (dns.flags.response == 1) and not (request_hash[dns.id] == nil) then
                        local delta = frame.time_epoch - request_hash[dns.id]
                        print(delta)
                  else
                        print(string.format("haven't seen dns.id %s\n", dns.id))
                  end
            end
            function tap.reset()
                   for item,dumper in pairs(dumpers) do
                           mark_closed(item)
                           dumper:close()
                           print("Tap reset")
                   end
                   dumpers = {}
            end

       end
       init_listener()
end


