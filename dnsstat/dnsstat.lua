local request_hash = {}
do
      dumpers = {}
      local dns_resp_f = Field.new("dns.flags.response")
      local time_epo_f = Field.new("frame.time_epoch")
      local dns_id_f   = Field.new("dns.id")
      local function init_listener()
            local tap = Listener.new("ip", "udp")
            function tap.packet(pinfo,tvb,ip)
                  local dns_flags_response = tostring(dns_resp_f())
                  local frame_time_epoch = tostring(time_epo_f())
                  local dns_id = tostring(dns_id_f())

                  -- not sure why this equality check fails.
                  if (dns_flags_response == 1) then
                        request_hash[dns_id] = frame_time_epoch
                  end

                  -- not sure why this equality check fails.
                  if ((dns_flags_response == 0) and not (request_hash[dns_id] == nil)) then
                        local delta = frame_time_epoch - request_hash[dns_id]
                        print(delta)
                  end

                  print(string.format("debug: epoch: %s id: %s resp: %s", frame_time_epoch, dns_id, dns_flags_response))
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


