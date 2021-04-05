yamux = Proto("yamux", "Yamux Protocol")
yamux.fields.version = ProtoField.uint8("yamux.version", "Version")
yamux.fields.type = ProtoField.uint8("yamux.type", "Type")
yamux.fields.flags = ProtoField.uint16("yamux.flags", "Flags")
yamux.fields.streamId = ProtoField.uint32("yamux.stream_id", "Stream ID")
yamux.fields.length = ProtoField.uint32("yamux.length", "Length")

function yamux.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "Yamux"

    local subtree = tree:add(yamux,buffer(), "Yamux Protocol Data")
    if buffer(0,1):uint() ~= 0 then
      subtree:add(buffer(0),"Payload (" .. buffer:len() .. " bytes)")
    else
      subtree:add(yamux.fields.version, buffer(0,1))
      subtree:add(yamux.fields.type, buffer(1,1))
      subtree:add(yamux.fields.flags, buffer(2,2))
      subtree:add(yamux.fields.streamId, buffer(4,4))
      subtree:add(yamux.fields.length, buffer(8,4))
      subtree:add(buffer(12),"Payload (" .. buffer:len() - 12 .. " bytes)")
    end
end
tcp_table = DissectorTable.get("ws.port")
tcp_table:add(8080, yamux)

